import 'package:flutter/material.dart';
import 'package:isittofu/text_analysis/analyzer.dart';
import 'package:isittofu/theme.dart';
import 'package:isittofu/window/window.dart';

class TextAnalysisModel extends ChangeNotifier with CharacterTableSource {
  TextAnalysisModel(this.context, {String? initialText}) {
    setText(initialText ?? '');
    // Run analysis once to force load deferred imports
    const Analyzer().analyzeText('a');
  }

  @override
  final BuildContext context;

  String _text = '';

  String get text => _text;

  TextAnalysis _analysis = TextAnalysis.empty();

  @override
  TextAnalysis get analysis => _analysis;

  final ValueNotifier<bool> busy = ValueNotifier(false);
  final ValueNotifier<bool> isNotEmpty = ValueNotifier(false);

  Future<void> setText(String text) async {
    if (_text != text) {
      _text = text;
      busy.value = true;
      _analysis = await const Analyzer().analyzeText(text);
      isNotEmpty.value = !_analysis.isEmpty;
      busy.value = false;
      notifyListeners();
      window.setQuery({'q': text});
    }
  }
}

mixin CharacterTableSource implements DataTableSource {
  BuildContext get context;

  TextAnalysis get analysis;

  @override
  DataRow getRow(int index) {
    final codePoint = analysis.sortedCodePoints[index];
    final codePointAnalysis = analysis.codePointAnalyses[codePoint]!;
    return DataRow(
      key: ValueKey(codePoint),
      cells: [
        DataCell(supportLevelIcon(codePointAnalysis.supportLevel)),
        DataCell(DefaultTextStyle.merge(
          style: const TextStyle(fontSize: 24),
          child: Text(codePointAnalysis.codePointDisplayString),
        )),
        // Work around inflexibility of PaginatedDataTable by manually
        // re-applying app text theme
        DataCell(_fixBodyText(Text(codePointAnalysis.codePointHex))),
        DataCell(_fixBodyText(Text(codePointAnalysis.iosSupportString))),
        DataCell(_fixBodyText(Text(codePointAnalysis.androidSupportString)))
      ],
    );
  }

  Widget _fixBodyText(Widget child) => DefaultTextStyle.merge(
      style: appTheme.textTheme.bodyMedium, child: child);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => analysis.sortedCodePoints.length;

  @override
  int get selectedRowCount => 0;
}

Widget supportLevelIcon(SupportLevel? level) {
  switch (level) {
    case SupportLevel.fullySupported:
      return kIconFullySupported;
    case SupportLevel.limitedSupport:
      return kIconLimitedSupport;
    case SupportLevel.unsupported:
      return kIconUnsupported;
    case null:
      // Can happen during animated hiding/showing
      return const SizedBox.shrink();
  }
}
