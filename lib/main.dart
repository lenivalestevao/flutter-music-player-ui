import 'package:flutter/material.dart';

import 'core/scope.dart';
import 'core/theme.dart';
import 'features/home_shell.dart';
import 'player/player_controller.dart';

void main() => runApp(const WavelineApp());

class WavelineApp extends StatefulWidget {
  const WavelineApp({super.key});

  @override
  State<WavelineApp> createState() => _WavelineAppState();
}

class _WavelineAppState extends State<WavelineApp> {
  final _player = PlayerController();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlayerScope(
      controller: _player,
      child: MaterialApp(
        title: 'Waveline',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const HomeShell(),
      ),
    );
  }
}
