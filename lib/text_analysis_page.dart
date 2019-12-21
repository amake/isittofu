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
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Input text to check here...',
                  ),
                  maxLines: 50,
                  minLines: 20,
                  controller: _controller,
                  style: Theme.of(context).textTheme.display1,
                  // This doesn't work right in Flutter Web: on mobile the
                  // keyboard won't show up, but the field has focus and can't
                  // be refocused so you can't force it to appear either.
                  //autofocus: true,
                ),
              ),
              const SizedBox(height: 32),
              if (!_analysis.isEmpty) ...[
                Row(
                  children: <Widget>[
                    const Icon(Icons.android),
                    const SizedBox(width: 16),
                    Text(_analysis.androidSupportString),
                    const Spacer(),
                    const Icon(Icons.phone_iphone),
                    const SizedBox(width: 16),
                    Text(_analysis.iosSupportString)
                  ],
                ),
                const SizedBox(height: 32),
              ],
              Expanded(
                child: ListView.separated(
                  itemCount: _analysis.uniqueCodePoints.length,
                  separatorBuilder: (context, i) => const Divider(),
                  itemBuilder: (context, i) => _CodePointTile(
                    _analysis.analysisForIndex(i),
                    key: ValueKey(i),
                  ),
                ),
              ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.android),
            const SizedBox(width: 16),
            Text(android),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.phone_iphone),
            const SizedBox(width: 16),
            Text(ios),
          ],
        ),
      ],
    );
  }
}
