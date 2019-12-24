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
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: Provider.of<TextAnalysisModel>(context)
                .analysis
                .sortedCodePoints
                .length,
            separatorBuilder: (context, i) => const Divider(),
            itemBuilder: (context, i) {
              final analysis = Provider.of<TextAnalysisModel>(context).analysis;
              final codePoint = analysis.sortedCodePoints[i];
              return _CodePointTile(
                analysis.analysis[codePoint],
                key: ValueKey(i),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CodePointTile extends StatelessWidget {
  const _CodePointTile(this.analysis, {Key key})
      : assert(analysis != null),
        super(key: key);

  final CodePointAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final icon = analysis.fullySupported
        ? const Icon(Icons.thumb_up)
        : const Icon(Icons.not_interested);
    return ListTile(
      leading: icon,
      title: Text(
        analysis.codePointDisplayString,
        style: Theme.of(context).textTheme.display1,
      ),
      subtitle: Text(analysis.codePointHex),
      trailing: _PlatformSupport(
        ios: analysis.iosSupportString,
        android: analysis.androidSupportString,
      ),
    );
  }
}

class _PlatformSupport extends StatelessWidget {
  const _PlatformSupport({@required this.android, @required this.ios, Key key})
      : assert(android != null),
        assert(ios != null),
        super(key: key);

  final String android;
  final String ios;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    return Theme(
      data: Theme.of(context)
          .copyWith(iconTheme: iconTheme.copyWith(size: iconTheme.size * 0.75)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.android),
              const SizedBox(width: 8),
              Text(android, style: Theme.of(context).textTheme.overline),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.phone_iphone),
              const SizedBox(width: 8),
              Text(ios, style: Theme.of(context).textTheme.overline),
            ],
          ),
        ],
      ),
    );
  }
}
