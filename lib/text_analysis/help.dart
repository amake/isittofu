import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:isittofu/text_analysis/analyzer.dart';
import 'package:isittofu/theme.dart';
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
        builder: (context, value, _) => Opacity(
          opacity: value ? 1 : 0.3,
          child: const Icon(
            Icons.help,
            color: kAccentColor,
          ),
        ),
      ),
      onPressed: () => enabled.value = !enabled.value,
      tooltip: 'Learn More',
      padding: EdgeInsets.zero,
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
    return AnimatedShowHide(
      expanded,
      shownChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 4),
          Html(
            data: _kHelpHtml,
            onLinkTap: launch,
            defaultTextStyle: DefaultTextStyle.of(context)
                .style
                .copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 16),
          Text('Legend', style: Theme.of(context).textTheme.subhead),
          const SizedBox(height: 10),
          const _Legend(),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final thresholdPct = (kLimitedSupportThreshold * 100).round();
    return IconTheme.merge(
      data: IconThemeData(size: IconTheme.of(context).size),
      child: DefaultTextStyle.merge(
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.body1.fontSize,
        ),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              kIconFullySupported,
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                    'Supported by ≥$thresholdPct% of both iOS and Android devices'),
              )
            ]),
            const SizedBox(height: 16),
            Row(children: <Widget>[
              kIconLimitedSupport,
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                    'Supported by <$thresholdPct% of either iOS or Android devices'),
              )
            ]),
            const SizedBox(height: 16),
            Row(children: <Widget>[
              kIconUnsupported,
              const SizedBox(width: 12),
              const Expanded(child: Text('Unsupported on iOS and/or Android'))
            ]),
          ],
        ),
      ),
    );
  }
}
