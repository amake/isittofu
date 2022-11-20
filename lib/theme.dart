import 'package:flutter/material.dart';

const Color kAccentColor = Color(0xff3eb3f8);
const Color kShadowColor = Color(0xffcccccc);
const Color kTextColor = Color(0xcc000000);
const Color kIconColor = Color(0xaa000000);

const Duration kOpenCloseAnimationDuration = Duration(milliseconds: 200);

final Widget kIconFullySupported = CushionIcon(
  color: Colors.green.shade50,
  child: Transform.scale(
    scale: 0.75,
    child: const Icon(Icons.thumb_up, color: Colors.green),
  ),
);
final Widget kIconLimitedSupport = CushionIcon(
  color: Colors.orange.shade50,
  child: Transform.scale(
    scale: 0.8,
    child: const Icon(Icons.warning, color: Colors.orange),
  ),
);
final Widget kIconUnsupported = CushionIcon(
  color: Colors.red.shade50,
  child: Transform.scale(
    scale: 0.8,
    child: const Icon(Icons.not_interested, color: Colors.red),
  ),
);
final Widget kIconIssueA11y = CushionIcon(
  color: Colors.blue,
  child: Transform.scale(
    scale: 0.8,
    child: const Icon(Icons.accessibility, color: Colors.white),
  ),
);

final ThemeData appTheme = _buildTheme();

ThemeData _buildTheme() {
  final inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
  );
  // Emoji break in the main TextField (e.g. 🥶 shows as ��) with
  // `englishLike2018`. No other `Typography` style has this problem ¯\_(ツ)_/¯
  final base =
      ThemeData.localize(ThemeData.light(), Typography.englishLike2014);
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
          headlineMedium: base.textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 54,
            height: 1.5,
            shadows: [
              const Shadow(
                color: Colors.black12,
                blurRadius: 16,
                offset: Offset(0, 3),
              ),
            ],
          ),
          titleLarge: base.textTheme.titleLarge!.copyWith(
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
    inputDecorationTheme: InputDecorationTheme(
      border: inputBorder,
      enabledBorder: inputBorder.copyWith(
        borderSide: const BorderSide(color: Colors.black12),
      ),
    ),
  );
}

class CushionIcon extends StatelessWidget {
  const CushionIcon({required this.child, this.color, super.key});

  final Color? color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: color ?? theme.color?.withOpacity(0.1),
      ),
      width: theme.size,
      height: theme.size,
      child: child,
    );
  }
}
