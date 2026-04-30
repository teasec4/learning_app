import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:learning_app/service/app_services.dart';
import 'package:learning_app/presentation/providers/deck_provider.dart';
import 'package:learning_app/presentation/providers/word_card_provider.dart';
import 'package:learning_app/presentation/providers/home_provider.dart';
import 'package:learning_app/route/router.dart';
import 'package:learning_app/core/app_colors.dart';
import 'package:learning_app/core/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appServices = AppServices();
  await appServices.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DeckProvider(appServices.deckRepository)..loadDecks(),
        ),
        ChangeNotifierProvider(
          create: (_) => WordCardProvider(appServices.wordCardRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(
            appServices.wordCardRepository,
            appServices.gameSessionRepository,
          )..refresh(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      title: 'Hanzi Battle',
      theme: AppTheme.lightTheme(ColorScheme.fromSeed(seedColor: AppColors.primary)),
      debugShowCheckedModeBanner: false,
    );
  }
}
