import 'package:flutter/material.dart';

abstract final class AppColors {
  static const accent = Color(0xFF2EE6A6);
  static const bg = Color(0xFF0E1013);
  static const card = Color(0xFF181B20);
  static const card2 = Color(0xFF22262D);
  static const muted = Color(0xFF9AA3AE);
}

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.accent,
    brightness: Brightness.dark,
    surface: AppColors.bg,
  ).copyWith(primary: AppColors.accent, onPrimary: Colors.black);

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.bg,
    canvasColor: AppColors.bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.bg,
      indicatorColor: AppColors.card2,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 11,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w600
              : FontWeight.w400,
          color: states.contains(WidgetState.selected)
              ? Colors.white
              : AppColors.muted,
        ),
      ),
    ),
    sliderTheme: const SliderThemeData(
      trackHeight: 4,
      activeTrackColor: Colors.white,
      inactiveTrackColor: Colors.white24,
      thumbColor: Colors.white,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
      overlayShape: RoundSliderOverlayShape(overlayRadius: 14),
    ),
    popupMenuTheme: const PopupMenuThemeData(color: AppColors.card2),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.card,
      showDragHandle: true,
    ),
  );
}
