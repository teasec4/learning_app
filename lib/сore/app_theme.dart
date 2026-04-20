import 'package:flutter/material.dart';

class AppTheme{
  static ThemeData lightTheme(ColorScheme scheme){
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      navigationBarTheme: NavigationBarThemeData(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: scheme.primary,
            );
          }
          return TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: scheme.onSurface,
          );
        })
      )
    );
  }
}