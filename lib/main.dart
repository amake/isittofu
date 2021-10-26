import 'package:flutter/material.dart';
import 'package:isittofu/text_analysis/page.dart';
import 'package:isittofu/theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Is It Tofu?',
      theme: appTheme,
      home: const TextAnalysisPage(),
    );
  }
}
