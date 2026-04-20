import 'package:flutter/material.dart';

class AppTheme{
  static ThemeData lightTheme(ColorScheme scheme){
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      
    );
  }
}