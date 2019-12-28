import 'package:flutter/material.dart';
import 'package:isittofu/text_analysis/page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Is it tofu?',
      theme: ThemeData.localize(ThemeData.light(), Typography.englishLike2018),
      home: const TextAnalysisPage(),
    );
  }
}
