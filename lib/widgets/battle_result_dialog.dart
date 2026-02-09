import 'package:flutter/material.dart';
import '../providers/game_provider.dart';
import 'monster_card.dart';

class BattleResultPanel extends StatelessWidget {
  final GameProvider game;

  const BattleResultPanel({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    if (game.phase != GamePhase.battleResult || game.lastBattleResult == null) {
      return const SizedBox.shrink();
    }

    final result = game.lastBattleResult!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: result.playerWon
            ? Colors.green.shade50
            : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: result.playerWon ? Colors.green : Colors.red,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            result.playerWon ? '勝利！' : '敗北...',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: result.playerWon ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text('味方', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  MonsterCard(monster: result.player),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('VS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Column(
                children: [
                  const Text('敵', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  MonsterCard(monster: result.enemy),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Battle log summary
          Container(
            constraints: const BoxConstraints(maxHeight: 80),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: result.logs.length,
              itemBuilder: (context, index) {
                final log = result.logs[index];
                final isPlayer = log.attacker == 'player';
                return Text(
                  '${isPlayer ? "味方" : "敵"}の攻撃！ ${log.damage}ダメージ${log.isCritical ? " クリティカル！" : ""}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isPlayer ? Colors.blue.shade700 : Colors.red.shade700,
                  ),
                );
              },
            ),
          ),
          if (result.playerWon)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'スコア +${result.scoreGained}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => game.dismissBattleResult(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
