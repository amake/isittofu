import 'package:flutter/material.dart';
import 'package:isittofu/data/android10.g.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 800),
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
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                    itemCount: _codePoints.length,
                    itemBuilder: (context, i) => CodePointTile(_codePoints[i])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CodePointTile extends StatelessWidget {
  const CodePointTile(this.codePoint, {Key key}) : assert(codePoint != null);

  final int codePoint;

  @override
  Widget build(BuildContext context) {
    final available = android10BloomFilter.mightContain(codePoint);
    final message =
        available ? 'Available on Android 10' : 'Not available on Android 10';
    final icon = available
        ? const Icon(Icons.thumb_up)
        : const Icon(Icons.not_interested);
    return ListTile(
      leading: icon,
      title: Text(String.fromCharCode(codePoint)),
      trailing: Text(message),
    );
  }
}
