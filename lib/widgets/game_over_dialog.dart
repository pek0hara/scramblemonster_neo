import 'package:flutter/material.dart';
import '../providers/game_provider.dart';

class GameOverDialog extends StatelessWidget {
  final GameProvider game;

  const GameOverDialog({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    if (game.phase != GamePhase.gameOver) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'ゲーム終了',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'スコア: ${game.score}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ハイスコア: ${game.highScore}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          if (game.score >= game.highScore && game.score > 0) ...[
            const SizedBox(height: 8),
            Text(
              'NEW RECORD!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.amber.shade700,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            'パーティ: ${game.party.length}体',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => game.startNewGame(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text('もう一度プレイ'),
          ),
        ],
      ),
    );
  }
}
