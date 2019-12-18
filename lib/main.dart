import 'package:flutter/material.dart';
import 'package:isittofu/data/android10.g.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  List<int> _codepoints = const [];

  @override
  void initState() {
    _controller = TextEditingController()..addListener(_textChanged);
    super.initState();
  }

  void _textChanged() {
    setState(() {
      _codepoints = List.from(_controller.text.runes);
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: _codepoints.length,
                itemBuilder: (context, i) {
                  final cp = _codepoints[i];
                  final available = android10BloomFilter.mightContain(cp);
                  final message = available
                      ? 'Available on Android 10'
                      : 'Not available on Android 10';
                  final icon = available
                      ? const Icon(Icons.thumb_up)
                      : const Icon(Icons.not_interested);
                  return ListTile(
                    leading: icon,
                    title: Text(String.fromCharCode(cp)),
                    trailing: Text(message),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
