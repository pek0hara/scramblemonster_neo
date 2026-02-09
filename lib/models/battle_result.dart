import 'dart:math';
import 'monster.dart';

class BattleLog {
  final String attacker;
  final int damage;
  final bool isCritical;

  BattleLog({
    required this.attacker,
    required this.damage,
    this.isCritical = false,
  });
}

class BattleResult {
  final Monster player;
  final Monster enemy;
  final bool playerWon;
  final int scoreGained;
  final List<BattleLog> logs;

  BattleResult({
    required this.player,
    required this.enemy,
    required this.playerWon,
    required this.scoreGained,
    required this.logs,
  });

  static BattleResult execute(Monster player, Monster enemy) {
    final random = Random();
    final logs = <BattleLog>[];

    int playerHp = player.hp;
    int enemyHp = enemy.hp;

    // Determine turn order by intelligence
    bool playerFirst = player.intelligence >= enemy.intelligence;
    if (player.intelligence == enemy.intelligence) {
      playerFirst = random.nextBool();
    }

    bool playerTurn = playerFirst;

    while (playerHp > 0 && enemyHp > 0) {
      if (playerTurn) {
        // Player attacks
        final critChance = player.intelligence * 0.02;
        final isCrit = random.nextDouble() < critChance;
        int damage = max(1, (player.attackPower - enemy.defense).round());
        if (isCrit) damage = (damage * 1.5).round();
        damage = max(1, damage + random.nextInt(3) - 1);

        enemyHp -= damage;
        logs.add(BattleLog(
          attacker: 'player',
          damage: damage,
          isCritical: isCrit,
        ));
      } else {
        // Enemy attacks
        final critChance = enemy.intelligence * 0.02;
        final isCrit = random.nextDouble() < critChance;
        int damage = max(1, (enemy.attackPower - player.defense).round());
        if (isCrit) damage = (damage * 1.5).round();
        damage = max(1, damage + random.nextInt(3) - 1);

        playerHp -= damage;
        logs.add(BattleLog(
          attacker: 'enemy',
          damage: damage,
          isCritical: isCrit,
        ));
      }
      playerTurn = !playerTurn;
    }

    final playerWon = enemyHp <= 0;
    final scoreGained = playerWon ? enemy.level * 10 : 0;

    return BattleResult(
      player: player,
      enemy: enemy,
      playerWon: playerWon,
      scoreGained: scoreGained,
      logs: logs,
    );
  }
}
