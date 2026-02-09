import 'package:flutter/material.dart';
import '../providers/game_provider.dart';
import 'monster_card.dart';

class FusionPreview extends StatelessWidget {
  final GameProvider game;

  const FusionPreview({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    if (game.phase != GamePhase.fusionPreview ||
        game.fusionTarget1 == null ||
        game.fusionTarget2 == null ||
        game.fusionPreview == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MonsterCard(monster: game.fusionTarget1!, isSelected: true),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '+',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              MonsterCard(monster: game.fusionTarget2!, isSelected: true),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward, size: 28),
              ),
              MonsterCard(
                monster: game.fusionPreview!,
                highlightStats: true,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => game.cancelFusion(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                ),
                child: const Text('キャンセル'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: game.actionPoints >= GameProvider.fusionCost
                    ? () => game.confirmFusion()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                ),
                child:
                    const Text('合体 (-10)'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
