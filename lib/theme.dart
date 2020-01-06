import 'package:flutter/material.dart';

const Color kAccentColor = Color(0xff3eb3f8);
const Color kShadowColor = Color(0xffcccccc);
const Color kTextColor = Color(0xcc000000);
const Color kIconColor = Color(0xaa000000);

final Widget kIconFullySupported = CushionIcon(
  child: Transform.scale(
    scale: 0.75,
    child: Icon(Icons.thumb_up, color: Colors.green),
  ),
  color: Colors.green.shade50,
);
final Widget kIconLimitedSupport = CushionIcon(
  child: Transform.scale(
    scale: 0.8,
    child: Icon(Icons.warning, color: Colors.orange),
  ),
  color: Colors.orange.shade50,
);
final Widget kIconUnsupported = CushionIcon(
  child: Transform.scale(
    scale: 0.8,
    child: Icon(Icons.not_interested, color: Colors.red),
  ),
  color: Colors.red.shade50,
);

final ThemeData appTheme = _buildTheme();

ThemeData _buildTheme() {
  final inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
  );
  final base =
      ThemeData.localize(ThemeData.light(), Typography.englishLike2018);
  final actionsIconThemeBase =
      base.appBarTheme.actionsIconTheme ?? const IconThemeData();
  return base.copyWith(
    appBarTheme: base.appBarTheme.copyWith(
      color: Colors.transparent,
      elevation: 0,
      actionsIconTheme: actionsIconThemeBase.copyWith(
        color: kAccentColor,
        opacity: 0.3,
      ),
    ),
    iconTheme: base.iconTheme.copyWith(size: 27, color: kIconColor),
    textTheme: base.textTheme
        .copyWith(
          display1: base.textTheme.display1.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 54,
            height: 1.5,
            shadows: [
              Shadow(
                color: Colors.black12,
                blurRadius: 16,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          title: base.textTheme.title.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        )
        .apply(
          fontFamily: 'Poppins',
          bodyColor: kTextColor,
          displayColor: kTextColor,
        ),
    cardTheme: base.cardTheme.copyWith(
      margin: EdgeInsets.symmetric(
        horizontal: base.cardTheme.margin?.horizontal ?? 8,
        vertical: 24,
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    canvasColor: Colors.white,
    accentColor: kAccentColor,
    inputDecorationTheme: InputDecorationTheme(
      border: inputBorder,
      enabledBorder:
          inputBorder.copyWith(borderSide: BorderSide(color: Colors.black12)),
    ),
  );
}

class CushionIcon extends StatelessWidget {
  const CushionIcon({@required this.child, this.color, Key key})
      : assert(child != null),
        super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: color ?? theme.color.withOpacity(0.1),
      ),
      width: theme.size,
      height: theme.size,
      child: child,
    );
  }
}

class AnimatedShowHide extends StatelessWidget {
  const AnimatedShowHide(this.visible,
      {@required this.shownChild,
      this.hiddenChild = const SizedBox.shrink(),
      this.duration = const Duration(milliseconds: 200),
      Key key})
      : assert(visible != null),
        assert(shownChild != null),
        assert(hiddenChild != null),
        assert(duration != null),
        super(key: key);

  final ValueNotifier<bool> visible;
  final Widget shownChild;
  final Widget hiddenChild;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: visible,
      builder: (context, value, child) => AnimatedCrossFade(
        alignment: Alignment.centerLeft,
        duration: duration,
        firstChild: child,
        secondChild: hiddenChild,
        crossFadeState:
            value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      ),
      child: shownChild,
    );
  }
}
