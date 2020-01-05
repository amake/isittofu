import 'package:flutter/material.dart';
import 'package:isittofu/text_analysis/page.dart';
import 'package:isittofu/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Is it tofu?',
      theme: appTheme,
      home: const TextAnalysisPage(),
    );
  }
}
