import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:isittofu/text_analysis/analyzer.dart';
import 'package:isittofu/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpToggleButton extends StatelessWidget {
  const HelpToggleButton(this.enabled, {super.key});

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

class ExpandableHelpText extends StatelessWidget {
  const ExpandableHelpText(this.expanded, {super.key});

  final ValueNotifier<bool> expanded;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: expanded,
      builder: (context, value, child) => AnimatedSwitcher(
        duration: kOpenCloseAnimationDuration,
        transitionBuilder: (child, animation) =>
            SizeTransition(sizeFactor: animation, child: child),
        child: value ? _content(context) : const SizedBox.shrink(),
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 4),
        Text.rich(
          TextSpan(
            text: 'These are the versions of iOS and Android that support all '
                'of the characters in your text. The percentages are estimated '
                'from data published by ',
            children: [
              _linkSpan(
                text: 'Apple',
                url:
                    Uri.parse('https://developer.apple.com/support/app-store/'),
              ),
              const TextSpan(text: ' and '),
              _linkSpan(
                text: 'Google',
                url:
                    Uri.parse('https://developer.android.com/about/dashboards'),
              ),
              const TextSpan(text: ' (retrieved May 2023).'),
            ],
          ),
          style: DefaultTextStyle.of(context)
              .style
              .copyWith(color: Colors.black54),
        ),
        const SizedBox(height: 16),
        Text('Legend', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        const _Legend(),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 6),
      ],
    );
  }

  InlineSpan _linkSpan({required String text, required Uri url}) => WidgetSpan(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Text.rich(
            TextSpan(
              text: text,
              recognizer: TapGestureRecognizer()..onTap = () => launchUrl(url),
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      );
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final thresholdPct = (kLimitedSupportThreshold * 100).round();
    return IconTheme.merge(
      data: IconThemeData(size: IconTheme.of(context).size),
      child: DefaultTextStyle.merge(
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
        ),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              kIconFullySupported,
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                    'Supported by ≥$thresholdPct% of both iOS and Android devices (including the latest OS)'),
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
