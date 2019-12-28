import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:isittofu/text_analysis/analyzer.dart';
import 'package:isittofu/text_analysis/page.dart';
import 'package:isittofu/window/window.dart';

class TextAnalysisModel extends ChangeNotifier with CharacterTableSource {
  TextAnalysisModel(this.context, {String initialText}) {
    setText(initialText ?? '');
    // Run analysis once to force load deferred imports
    const Analyzer().analyzeText('a');
  }

  @override
  final BuildContext context;

  String _text;

  String get text => _text;

  TextAnalysis _analysis = TextAnalysis.empty();

  @override
  TextAnalysis get analysis => _analysis;

  final ValueNotifier<bool> busy = ValueNotifier(false);

  Future<void> setText(String text) async {
    if (_text != text) {
      _text = text;
      busy.value = true;
      _analysis = await const Analyzer().analyzeText(text);
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
    final codePointAnalysis = analysis.codePointAnalyses[codePoint];
    return DataRow(
      key: ValueKey(codePoint),
      cells: [
        DataCell(supportLevelIcon(codePointAnalysis.supportLevel)),
        DataCell(Text(
          codePointAnalysis.codePointDisplayString,
          style: Theme.of(context)
              .textTheme
              .display1
              .copyWith(fontSize: IconTheme.of(context).size),
        )),
        DataCell(Text(codePointAnalysis.codePointHex)),
        DataCell(Text(codePointAnalysis.iosSupportString)),
        DataCell(Text(codePointAnalysis.androidSupportString))
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => analysis.sortedCodePoints.length;

  @override
  int get selectedRowCount => 0;
}

Widget supportLevelIcon(SupportLevel level) {
  switch (level) {
    case SupportLevel.fullySupported:
      return kIconFullySupported;
    case SupportLevel.limitedSupport:
      return kIconLimitedSupport;
    case SupportLevel.unsupported:
      return kIconUnsupported;
  }
  throw Exception('Unkonwn level: $level');
}
