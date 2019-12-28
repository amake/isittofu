import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:isittofu/analyzer.dart';
import 'package:isittofu/window/window.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

class TextAnalysisPage extends StatelessWidget {
  const TextAnalysisPage({Key key}) : super(key: key);

  String get initialText => window.decodedQuery['q'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Is it tofu?'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => launch('https://github.com/amake/isittofu'),
          )
        ],
      ),
      body: ChangeNotifierProvider(
        create: (context) =>
            TextAnalysisModel(context, initialText: initialText),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Builder(
              builder: (context) => ListView(
                children: <Widget>[
                  const _TextInputCard(),
                  //const SizedBox(height: 32),
                  if (!Provider.of<TextAnalysisModel>(context)
                      .analysis
                      .isEmpty) ...[
                    const _CompatibilitySummary(),
                    const _CharacterBreakdown(),
                  ] else
                    const _LoadingProgress(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingProgress extends StatelessWidget {
  const _LoadingProgress({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable:
          Provider.of<TextAnalysisModel>(context, listen: false).busy,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      builder: (context, value, child) =>
          value ? child : const SizedBox.shrink(),
    );
  }
}

class _TextInputCard extends StatefulWidget {
  const _TextInputCard({Key key}) : super(key: key);

  @override
  _TextInputCardState createState() => _TextInputCardState();
}

class _TextInputCardState extends State<_TextInputCard> {
  TextEditingController _controller;

  @override
  void initState() {
    final initialText =
        Provider.of<TextAnalysisModel>(context, listen: false).text;
    _controller = TextEditingController(text: initialText)
      ..addListener(_textChanged);
    super.initState();
  }

  void _textChanged() =>
      Provider.of<TextAnalysisModel>(context).setText(_controller.text);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Is your text visible on mobile? Enter it here to see if any of it turns to "tofu".',
              style: Theme.of(context).textTheme.title,
            ),
            const SizedBox(height: 24),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Input text to check here...',
              ),
              maxLines: 10,
              minLines: 5,
              controller: _controller,
              // This doesn't work right in Flutter Web: on mobile the
              // keyboard won't show up, but the field has focus and can't
              // be refocused so you can't force it to appear either.
              //autofocus: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _CompatibilitySummary extends StatelessWidget {
  const _CompatibilitySummary({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final analysis = Provider.of<TextAnalysisModel>(context).analysis;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Overall Compatibility',
              style: Theme.of(context).textTheme.title,
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              child: Wrap(
                runSpacing: 16,
                spacing: 16,
                alignment: WrapAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _supportLevelIcon(analysis.androidSupportLevel),
                      const SizedBox(width: 8),
                      const Icon(Icons.android),
                      const SizedBox(width: 8),
                      Text(analysis.androidSupportString),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _supportLevelIcon(analysis.iosSupportLevel),
                      const SizedBox(width: 8),
                      const Icon(Icons.phone_iphone),
                      const SizedBox(width: 8),
                      Text(analysis.iosSupportString)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CharacterBreakdown extends StatelessWidget {
  const _CharacterBreakdown({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      header: const Text('Character Breakdown'),
      columns: const [
        DataColumn(label: Text('')),
        DataColumn(label: Text('Character')),
        DataColumn(label: Text('Code Point')),
        DataColumn(label: Text('iOS Support')),
        DataColumn(label: Text('Android Support')),
      ],
      source: Provider.of<TextAnalysisModel>(context, listen: false),
    );
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
        DataCell(_supportLevelIcon(codePointAnalysis.supportLevel)),
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

Widget _supportLevelIcon(SupportLevel level) {
  switch (level) {
    case SupportLevel.fullySupported:
      return const Icon(Icons.thumb_up, color: Colors.green);
    case SupportLevel.limitedSupport:
      return const Icon(Icons.warning, color: Colors.yellow);
    case SupportLevel.unsupported:
      return const Icon(Icons.not_interested, color: Colors.red);
  }
  throw Exception('Unkonwn level: $level');
}
