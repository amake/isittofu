import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:isittofu/analyzer.dart';

class TextAnalysisPage extends StatefulWidget {
  const TextAnalysisPage({Key key}) : super(key: key);

  @override
  _TextAnalysisPageState createState() => _TextAnalysisPageState();
}

class _TextAnalysisPageState extends State<TextAnalysisPage> {
  TextEditingController _controller;
  TextAnalysis _analysis = TextAnalysis.empty();

  @override
  void initState() {
    _controller = TextEditingController()..addListener(_textChanged);
    super.initState();
  }

  void _textChanged() {
    setState(() {
      _analysis = const Analyzer().analyzeText(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Is it tofu?'),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            children: <Widget>[
              Card(
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
              ),
              //const SizedBox(height: 32),
              if (!_analysis.isEmpty) ...[
                Card(
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
                                  Text(_analysis.androidSupportString),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(Icons.phone_iphone),
                                  const SizedBox(width: 8),
                                  Text(_analysis.iosSupportString)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
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
                        itemCount: _analysis.sortedCodePoints.length,
                        separatorBuilder: (context, i) => const Divider(),
                        itemBuilder: (context, i) {
                          final codePoint = _analysis.sortedCodePoints[i];
                          return _CodePointTile(
                            _analysis.analysis[codePoint],
                            key: ValueKey(i),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
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
    final icon = analysis.supported
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
