import 'package:flutter/material.dart';
import 'package:learning_app/%D1%81ore/app_colors.dart';
import 'package:learning_app/%D1%81ore/app_theme.dart';
import 'package:learning_app/route/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme(
        ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
    );
  }
}

