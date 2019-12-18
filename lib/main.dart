import 'package:flutter/material.dart';
import 'package:isittofu/data/android.dart' as android;
import 'package:isittofu/data/ios.dart' as ios;
import 'package:isittofu/util.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Is it tofu?'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller;
  List<int> _codePoints = const [];

  @override
  void initState() {
    _controller = TextEditingController()..addListener(_textChanged);
    super.initState();
  }

  void _textChanged() {
    setState(() {
      _codePoints = List.from(_controller.text.runes.unique());
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
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Input text to check here...',
                  ),
                  maxLines: 50,
                  minLines: 20,
                  controller: _controller,
                  style: Theme.of(context).textTheme.display1,
                  autofocus: true,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.separated(
                  itemCount: _codePoints.length,
                  separatorBuilder: (context, i) => const Divider(),
                  itemBuilder: (context, i) => CodePointTile(
                    _codePoints[i],
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

class CodePointTile extends StatelessWidget {
  const CodePointTile(this.codePoint, {Key key})
      : assert(codePoint != null),
        super(key: key);

  final int codePoint;

  @override
  Widget build(BuildContext context) {
    print('Inspecting codepoint $codePoint');
    final iosIndices = ios.supportingIndices(codePoint);
    print('iOS indices: $iosIndices');
    final iosRanges = iosIndices.ranges();
    print('iOS ranges: $iosRanges');
    final iosMessage = ios.supportedString(iosRanges);
    print('iOS message: $iosMessage');
    final androidIndices = android.supportingIndices(codePoint);
    print('Android indices: $androidIndices');
    final androidRanges = androidIndices.ranges();
    print('Android ranges: $androidRanges');
    final androidMessage = android.supportedString(androidRanges);
    print('Android message: $androidMessage');
    print('Done inspecting codepoint $codePoint');
    final icon = iosIndices.isNotEmpty && androidIndices.isNotEmpty
        ? const Icon(Icons.thumb_up)
        : const Icon(Icons.not_interested);
    return ListTile(
      leading: icon,
      title: Text(
        String.fromCharCode(codePoint),
        style: Theme.of(context).textTheme.display1,
      ),
      subtitle: Text('U+${codePoint.toRadixString(16)}'),
      trailing: PlatformSupport(
        ios: iosMessage,
        android: androidMessage,
      ),
    );
  }
}

class PlatformSupport extends StatelessWidget {
  const PlatformSupport({this.android, this.ios, Key key})
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
