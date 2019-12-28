import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:isittofu/text_analysis/help.dart';
import 'package:isittofu/text_analysis/model.dart';
import 'package:isittofu/window/window.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

const Icon kIconFullySupported = Icon(Icons.thumb_up, color: Colors.green);
const Icon kIconLimitedSupport = Icon(Icons.warning, color: Colors.yellow);
const Icon kIconUnsupported = Icon(Icons.not_interested, color: Colors.red);

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
              'Is your text visible on mobile? Enter it here to see if any of it turns to “tofu”.',
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
    final expanded = ValueNotifier(false);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Overall Compatibility',
                  style: Theme.of(context).textTheme.title,
                ),
                HelpToggleButton(expanded),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: ExpandableHelpText(expanded),
            ),
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
                      supportLevelIcon(analysis.androidSupportLevel),
                      const SizedBox(width: 8),
                      const Icon(Icons.android),
                      const SizedBox(width: 8),
                      Text(analysis.androidSupportString),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      supportLevelIcon(analysis.iosSupportLevel),
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
