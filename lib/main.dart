import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loreforge/game/loreforge_game.dart';
import 'screens/main_menu_screen.dart';
import 'screens/wizard/session_zero_wizard.dart';
import 'screens/gameplay_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loreforge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainMenuScreen(),
        '/wizard': (context) => const SessionZeroWizard(),
        '/gameplay': (context) => const GameplayScreen(),
      },
    );
  }
}
