import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const ScrambleMonsterApp());
}

class ScrambleMonsterApp extends StatelessWidget {
  const ScrambleMonsterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider()..startNewGame(),
      child: MaterialApp(
        title: 'スクランブルモンスター',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          useMaterial3: true,
        ),
        home: const GameScreen(),
      ),
    );
  }
}
