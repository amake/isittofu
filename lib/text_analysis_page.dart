import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:isittofu/analyzer.dart';
import 'package:provider/provider.dart';

class TextAnalysisModel extends ChangeNotifier {
  String _text = '';

  String get text => _text;

  TextAnalysis _analysis = TextAnalysis.empty();

  TextAnalysis get analysis => _analysis;

  void setText(String text) {
    if (_text != text) {
      _text = text;
      _analysis = const Analyzer().analyzeText(text);
      notifyListeners();
    }
  }
}

class TextAnalysisPage extends StatelessWidget {
  const TextAnalysisPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Is it tofu?'),
      ),
      body: ChangeNotifierProvider(
        create: (context) => TextAnalysisModel(),
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
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
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
    _controller = TextEditingController()..addListener(_textChanged);
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
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Is your text visible on mobile? Enter it here to see if any of it turns to "tofu".',
              style: Theme.of(context).textTheme.title,
            ),
            const SizedBox(height: 8),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Overall Compatibility',
              style: Theme.of(context).textTheme.title,
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.android),
                      const SizedBox(width: 8),
                      Text(Provider.of<TextAnalysisModel>(context)
                          .analysis
                          .androidSupportString),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.phone_iphone),
                      const SizedBox(width: 8),
                      Text(Provider.of<TextAnalysisModel>(context)
                          .analysis
                          .iosSupportString)
                    ],
                  ),
                ),
              ],
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
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Character Breakdown',
              style: Theme.of(context).textTheme.title,
            ),
          ),
          const _CharacterTable(),
        ],
      ),
    );
  }
}

class _CharacterTable extends StatelessWidget {
  const _CharacterTable({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final analysis = Provider.of<TextAnalysisModel>(context).analysis;
    return DataTable(
      columns: const [
        DataColumn(label: Text('Supported?')),
        DataColumn(label: Text('Character')),
        DataColumn(label: Text('Code Point')),
        DataColumn(label: Text('iOS Support')),
        DataColumn(label: Text('Android Support')),
      ],
      rows: [
        for (final codePoint in analysis.sortedCodePoints)
          _buildCodePointRow(context, codePoint)
      ],
    );
  }

  DataRow _buildCodePointRow(BuildContext context, int codePoint) {
    final analysis =
        Provider.of<TextAnalysisModel>(context).analysis.analysis[codePoint];
    final icon = analysis.fullySupported
        ? const Icon(Icons.thumb_up, color: Colors.green)
        : const Icon(Icons.not_interested, color: Colors.red);
    return DataRow(
      key: ValueKey(codePoint),
      cells: [
        DataCell(icon),
        DataCell(Text(
          analysis.codePointDisplayString,
          style: Theme.of(context).textTheme.display1,
        )),
        DataCell(Text(analysis.codePointHex)),
        DataCell(Text(analysis.iosSupportString)),
        DataCell(Text(analysis.androidSupportString))
      ],
    );
  }
}
