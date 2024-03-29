import 'package:flutter/material.dart';

const MaterialColor palette = MaterialColor(palettePrimaryValue, <int, Color>{
  50: Color(0xFFE5E6F3),
  100: Color(0xFFBFC1E1),
  200: Color(0xFF9497CD),
  300: Color(0xFF696DB8),
  400: Color(0xFF494EA9),
  500: Color(palettePrimaryValue),
  600: Color(0xFF242A92),
  700: Color(0xFF1F2388),
  800: Color(0xFF191D7E),
  900: Color(0xFF0F126C),
});

const int palettePrimaryValue = 0xFF292F9A;

ThemeData appTheme = ThemeData(
  useMaterial3: false,
  primarySwatch: palette,
);
