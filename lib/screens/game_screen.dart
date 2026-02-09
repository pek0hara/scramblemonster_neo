import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/monster_card.dart';
import '../widgets/fusion_preview.dart';
import '../widgets/battle_result_dialog.dart';
import '../widgets/game_over_dialog.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('スクランブルモンスター'),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _showHelpDialog(context),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, game, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Status bar
                _buildStatusBar(game),
                const SizedBox(height: 12),

                // Fusion preview (shown during fusion)
                if (game.phase == GamePhase.fusionPreview)
                  FusionPreview(game: game),

                // Battle result (shown after battle)
                if (game.phase == GamePhase.battleResult)
                  BattleResultPanel(game: game),

                // Game over
                if (game.phase == GamePhase.gameOver)
                  GameOverDialog(game: game),

                if (game.phase != GamePhase.gameOver &&
                    game.phase != GamePhase.battleResult) ...[
                  const SizedBox(height: 12),

                  // Party section
                  _buildPartySection(game),
                  const SizedBox(height: 12),

                  // Event area
                  _buildEventArea(game),
                  const SizedBox(height: 16),

                  // Action buttons
                  _buildActionButtons(game),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBar(GameProvider game) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statusItem('スコア', game.score.toString(), Colors.blue),
          _statusItem('行動力', game.actionPoints.toString(), Colors.green),
        ],
      ),
    );
  }

  Widget _statusItem(String label, String value, Color color) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPartySection(GameProvider game) {
    if (game.party.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Center(
          child: Text(
            '「捜索」でモンスターを見つけよう！',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 4),
            child: Text(
              'パーティ (${game.party.length}/${GameProvider.maxPartySize})',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: game.party.map((monster) {
                final isSelected = _isMonsterSelected(game, monster);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: MonsterCard(
                    monster: monster,
                    isSelected: isSelected,
                    onTap: () => _onMonsterTap(game, monster),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  bool _isMonsterSelected(GameProvider game, monster) {
    if (game.phase == GamePhase.fusionSelect ||
        game.phase == GamePhase.fusionPreview) {
      return (game.fusionTarget1?.id == monster.id) ||
          (game.fusionTarget2?.id == monster.id);
    }
    return false;
  }

  void _onMonsterTap(GameProvider game, monster) {
    switch (game.phase) {
      case GamePhase.fusionSelect:
        game.selectFusionTarget(monster);
        break;
      case GamePhase.battleSelect:
        game.selectBattleMonster(monster);
        break;
      case GamePhase.partyFull:
        game.replacePartyMember(
            game.party.indexWhere((m) => m.id == monster.id));
        break;
      default:
        break;
    }
  }

  Widget _buildEventArea(GameProvider game) {
    if (game.eventMessage.isEmpty &&
        game.phase != GamePhase.partyFull &&
        game.phase != GamePhase.discovered) {
      return const SizedBox(height: 80);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: [
          Text(
            game.eventMessage,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          if (game.discoveredMonster != null &&
              (game.phase == GamePhase.discovered ||
                  game.phase == GamePhase.partyFull)) ...[
            const SizedBox(height: 8),
            MonsterCard(monster: game.discoveredMonster!),
            const SizedBox(height: 8),
            if (game.phase == GamePhase.partyFull) ...[
              const Text(
                'パーティが満員です。入れ替えるモンスターを選んでください',
                style: TextStyle(fontSize: 12, color: Colors.orange),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () => game.discardDiscovered(),
                child: const Text('破棄する'),
              ),
            ] else ...[
              TextButton(
                onPressed: () => game.dismissEvent(),
                child: const Text('OK'),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(GameProvider game) {
    final bool isActionPhase = game.phase == GamePhase.idle;
    final bool isFusing = game.phase == GamePhase.fusionSelect;
    final bool isBattleSelect = game.phase == GamePhase.battleSelect;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Search button
        ElevatedButton(
          onPressed: isActionPhase && game.canSearch ? () => game.search() : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(
            '捜索 (-${GameProvider.searchCost})',
            style: const TextStyle(fontSize: 14),
          ),
        ),
        // Fusion button
        if (isFusing)
          ElevatedButton(
            onPressed: () => game.cancelFusion(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('キャンセル', style: TextStyle(fontSize: 14)),
          )
        else
          ElevatedButton(
            onPressed:
                isActionPhase && game.canFuse ? () => game.startFusion() : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              '合体 (-${GameProvider.fusionCost})',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        // Battle button
        if (isBattleSelect)
          ElevatedButton(
            onPressed: () => game.cancelBattle(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('キャンセル', style: TextStyle(fontSize: 14)),
          )
        else
          ElevatedButton(
            onPressed: isActionPhase && game.canBattle
                ? () => game.startBattle()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              '対戦 (-${GameProvider.battleCost})',
              style: const TextStyle(fontSize: 14),
            ),
          ),
      ],
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('遊び方'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('■ 捜索 (-1行動力)',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('ランダムなモンスターを発見してパーティに加えます。'),
              SizedBox(height: 8),
              Text('■ 合体 (-10行動力)',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('2体のモンスターを合体させて強化します。'),
              SizedBox(height: 8),
              Text('■ 対戦 (-5行動力)',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('モンスターを選んで敵と戦います。\n勝利でスコア獲得、敗北でモンスター離脱。'),
              SizedBox(height: 8),
              Text('■ ゲーム終了',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('行動力が0になるとゲーム終了です。\nハイスコアを目指しましょう！'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }
}
