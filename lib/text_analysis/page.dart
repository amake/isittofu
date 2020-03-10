import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:isittofu/text_analysis/analyzer.dart';
import 'package:isittofu/text_analysis/help.dart';
import 'package:isittofu/text_analysis/model.dart';
import 'package:isittofu/theme.dart';
import 'package:isittofu/window/window.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TextAnalysisPage extends StatelessWidget {
  const TextAnalysisPage({Key key}) : super(key: key);

  String get initialText => window.decodedQuery['q'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Support the Author',
            onPressed: () => launch('https://github.com/sponsors/amake'),
          ),
          IconButton(
            icon: const Icon(Icons.info),
            tooltip: 'About & Source Code',
            onPressed: () => launch('https://github.com/amake/isittofu'),
          ),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (context) =>
            TextAnalysisModel(context, initialText: initialText),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Builder(
              builder: (context) {
                return ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: const <Widget>[
                    _TextInputCard(),
                    SizedBox(height: 24),
                    _AnalysisBody(),
                    // Offset the size of the appbar to make the content appear
                    // vertically centered when collapsed
                    SizedBox(height: kToolbarHeight),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _AnalysisBody extends StatelessWidget {
  const _AnalysisBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TextAnalysisModel>(context);
    return ValueListenableBuilder<bool>(
      valueListenable: model.isNotEmpty,
      builder: (context, value, child) => AnimatedSwitcher(
        duration: kOpenCloseAnimationDuration,
        transitionBuilder: (child, animation) =>
            SizeTransition(child: child, sizeFactor: animation),
        child: value
            ? Column(
                children: <Widget>[
                  const _CompatibilitySummary(),
                  if (model.analysis.hasIssues) const _IssuesList(),
                  const _CharacterBreakdown(),
                ],
              )
            : const _LoadingProgress(),
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

  void _textChanged() => Provider.of<TextAnalysisModel>(context, listen: false)
      .setText(_controller.text);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const _Logo(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Is your text visible on mobile? Check it out now!',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 26),
          Material(
            elevation: 10,
            shadowColor: kShadowColor,
            child: TextField(
              decoration: InputDecoration(
                hintText:
                    'Enter it here to see if any of it turns to “tofu”...',
                suffixIcon: _ClearTextButton(_controller),
              ),
              minLines: 1,
              maxLines: 10,
              controller: _controller,
              // This doesn't work right in Flutter Web: on mobile the
              // keyboard won't show up, but the field has focus and can't
              // be refocused so you can't force it to appear either.
              //autofocus: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClearTextButton extends StatelessWidget {
  const _ClearTextButton(this.controller, {Key key})
      : assert(controller != null),
        super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) =>
          value.text.isNotEmpty ? child : const SizedBox.shrink(),
      child: IconButton(
        icon: const CushionIcon(child: Icon(Icons.clear)),
        onPressed: controller.clear,
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: '<center>Is it <span>tofu?</span></center>'.toUpperCase(),
      shrinkToFit: true,
      defaultTextStyle: Theme.of(context).textTheme.headline4,
      customTextStyle: (node, style) {
        if (node is dom.Element && node.localName == 'span') {
          return style.copyWith(color: Theme.of(context).accentColor);
        } else {
          return style;
        }
      },
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
        // Right padding is small to allow the help button to get closer to the
        // right edge
        padding: const EdgeInsets.fromLTRB(24, 8, 8, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Overall Compatibility',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                HelpToggleButton(expanded),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 14),
              child: ExpandableHelpText(expanded),
            ),
            Container(
              width: double.infinity,
              // Compensate for small right-side padding
              padding: const EdgeInsets.only(right: 16),
              child: Wrap(
                runSpacing: 16,
                spacing: 16,
                alignment: WrapAlignment.spaceBetween,
                children: <Widget>[
                  _PlatformSummary(
                    supportLevel: analysis.androidSupportLevel,
                    text: analysis.androidSupportString,
                    icon: const Icon(Icons.android),
                  ),
                  _PlatformSummary(
                    supportLevel: analysis.iosSupportLevel,
                    text: analysis.iosSupportString,
                    icon: const Icon(Icons.phone_iphone),
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

class _PlatformSummary extends StatelessWidget {
  const _PlatformSummary({
    @required this.supportLevel,
    @required this.text,
    @required this.icon,
    Key key,
  })  : assert(text != null),
        assert(icon != null),
        super(key: key);
  final SupportLevel supportLevel;
  final String text;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        supportLevelIcon(supportLevel),
        const SizedBox(width: 8),
        Transform.scale(
          child: icon,
          scale: 0.8,
        ),
        const SizedBox(width: 8),
        Flexible(child: Text(text)),
      ],
    );
  }
}

class _IssuesList extends StatelessWidget {
  const _IssuesList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final analysis = Provider.of<TextAnalysisModel>(context).analysis;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Issues',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 32),
            for (final issue in analysis.issues)
              Row(
                children: <Widget>[
                  Tooltip(
                    child: kIconIssueA11y,
                    message: _issueTitle(issue),
                  ),
                  const SizedBox(width: 24),
                  Expanded(child: Text(_issueText(issue))),
                ],
              )
          ],
        ),
      ),
    );
  }
}

String _issueTitle(Issue issue) {
  switch (issue.type) {
    case IssueType.mathA11y:
      return 'Accessibility';
  }
  throw Exception('Unknown issue type: ${issue.type}');
}

String _issueText(Issue issue) {
  switch (issue.type) {
    case IssueType.mathA11y:
      return 'Mathematical alphanumeric symbols (${issue.codePointsAsCSV}) are '
          'not recommended for use as stylzed text, and can cause problems with '
          'accessibility tools like screen readers';
  }
  throw Exception('Unknown issue type: ${issue.type}');
}

class _CharacterBreakdown extends StatelessWidget {
  const _CharacterBreakdown({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      // Work around inflexibility of PaginatedDataTable by manually
      // re-applying app text theme
      header: DefaultTextStyle.merge(
        style: appTheme.textTheme.headline6,
        child: const Text('Character Breakdown'),
      ),
      columns: [
        const DataColumn(label: SizedBox.shrink()),
        DataColumn(label: _fixFontFamily(Text('Character'.toUpperCase()))),
        DataColumn(label: _fixFontFamily(Text('Code Point'.toUpperCase()))),
        DataColumn(label: _fixFontFamily(Text('iOS Support'.toUpperCase()))),
        DataColumn(
            label: _fixFontFamily(Text('Android Support'.toUpperCase()))),
      ],
      source: Provider.of<TextAnalysisModel>(context, listen: false),
    );
  }

  Widget _fixFontFamily(Widget child) => DefaultTextStyle.merge(
      style: TextStyle(fontFamily: appTheme.textTheme.bodyText2.fontFamily),
      child: child);
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
