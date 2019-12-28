import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpToggleButton extends StatelessWidget {
  const HelpToggleButton(this.enabled, {Key key})
      : assert(enabled != null),
        super(key: key);

  final ValueNotifier<bool> enabled;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: ValueListenableBuilder<bool>(
        valueListenable: enabled,
        builder: (context, value, _) =>
            value ? const Icon(Icons.help) : const Icon(Icons.help_outline),
      ),
      onPressed: () => enabled.value = !enabled.value,
    );
  }
}

const _kHelpHtml = 'These are the versions of iOS and Android that support all '
    'of the characters in your text. The percentages are estimated from '
    'data published by '
    '<a href="https://developer.apple.com/support/app-store/">Apple</a> '
    'and '
    '<a href="https://developer.android.com/about/dashboards">Google</a> '
    '(retrieved December 2019).';

class ExpandableHelpText extends StatelessWidget {
  const ExpandableHelpText(this.expanded, {Key key})
      : assert(expanded != null),
        super(key: key);

  final ValueNotifier<bool> expanded;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: expanded,
      builder: (context, value, child) => AnimatedCrossFade(
        alignment: Alignment.centerLeft,
        duration: const Duration(milliseconds: 200),
        firstChild: child,
        secondChild: const SizedBox.shrink(),
        crossFadeState:
            value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Html(data: _kHelpHtml, onLinkTap: launch),
          const SizedBox(height: 8),
          Text('Legend', style: Theme.of(context).textTheme.subhead),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 16),
            child: _Legend(),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({Key key}) : super(key: key);

  double get _scaleFactor => 0.6;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconTheme = IconTheme.of(context);
    return Theme(
      data: theme.copyWith(
        iconTheme: iconTheme.copyWith(size: iconTheme.size * _scaleFactor),
        textTheme: theme.textTheme.apply(fontSizeFactor: _scaleFactor),
      ),
      child: Column(
        children: <Widget>[
          Row(children: const <Widget>[
            Icon(Icons.thumb_up, color: Colors.green),
            SizedBox(width: 4),
            Text('Supported by ≥70% of both iOS and Android devices')
          ]),
          Row(children: const <Widget>[
            Icon(Icons.warning, color: Colors.yellow),
            SizedBox(width: 4),
            Text('Supported by <70% of either iOS or Android devices')
          ]),
          Row(children: const <Widget>[
            Icon(Icons.not_interested, color: Colors.red),
            SizedBox(width: 4),
            Text('Unsupported on iOS and/or Android')
          ]),
        ],
      ),
    );
  }
}
