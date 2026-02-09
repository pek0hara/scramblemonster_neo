import 'dart:math';

enum MonsterType {
  fire,
  aqua,
  wind,
  earth,
  light,
  dark,
}

extension MonsterTypeExtension on MonsterType {
  String get displayName {
    switch (this) {
      case MonsterType.fire:
        return 'ファイア';
      case MonsterType.aqua:
        return 'アクア';
      case MonsterType.wind:
        return 'ウィンド';
      case MonsterType.earth:
        return 'アース';
      case MonsterType.light:
        return 'ライト';
      case MonsterType.dark:
        return 'ダーク';
    }
  }
}

class Monster {
  final String id;
  final MonsterType type;
  final int level;
  final int magic;
  final int spirit;
  final int intelligence;

  Monster({
    required this.id,
    required this.type,
    required this.level,
    required this.magic,
    required this.spirit,
    required this.intelligence,
  });

  int get totalPower => magic + spirit + intelligence;

  double get attackPower => magic * (1.0 + intelligence * 0.02);

  double get defense => spirit * 0.5;

  int get hp => spirit + level * 2;

  static Monster generate({int? maxLevel}) {
    final random = Random();
    final type = MonsterType.values[random.nextInt(MonsterType.values.length)];
    final lv = random.nextInt(maxLevel ?? 5) + 1;

    int baseMagic, baseSpirit, baseIntelligence;

    switch (type) {
      case MonsterType.fire:
        baseMagic = 5 + random.nextInt(3);
        baseSpirit = 2 + random.nextInt(2);
        baseIntelligence = 3 + random.nextInt(2);
        break;
      case MonsterType.aqua:
        baseMagic = 2 + random.nextInt(2);
        baseSpirit = 5 + random.nextInt(3);
        baseIntelligence = 3 + random.nextInt(2);
        break;
      case MonsterType.wind:
        baseMagic = 3 + random.nextInt(2);
        baseSpirit = 2 + random.nextInt(2);
        baseIntelligence = 5 + random.nextInt(3);
        break;
      case MonsterType.earth:
        baseMagic = 3 + random.nextInt(3);
        baseSpirit = 3 + random.nextInt(3);
        baseIntelligence = 3 + random.nextInt(3);
        break;
      case MonsterType.light:
        baseMagic = 5 + random.nextInt(3);
        baseSpirit = 3 + random.nextInt(2);
        baseIntelligence = 2 + random.nextInt(2);
        break;
      case MonsterType.dark:
        baseMagic = 4 + random.nextInt(2);
        baseSpirit = 3 + random.nextInt(2);
        baseIntelligence = 4 + random.nextInt(2);
        break;
    }

    return Monster(
      id: DateTime.now().microsecondsSinceEpoch.toString() +
          random.nextInt(10000).toString(),
      type: type,
      level: lv,
      magic: baseMagic + (lv - 1) * 3 + random.nextInt(lv),
      spirit: baseSpirit + (lv - 1) * 3 + random.nextInt(lv),
      intelligence: baseIntelligence + (lv - 1) * 2 + random.nextInt(lv),
    );
  }

  static Monster generateEnemy(int score) {
    final random = Random();
    final scaleFactor = 1 + (score ~/ 50);
    final lv = max(1, scaleFactor + random.nextInt(3) - 1);
    final type = MonsterType.values[random.nextInt(MonsterType.values.length)];

    return Monster(
      id: 'enemy_${DateTime.now().microsecondsSinceEpoch}',
      type: type,
      level: lv,
      magic: 5 + lv * 3 + random.nextInt(lv + 1),
      spirit: 5 + lv * 3 + random.nextInt(lv + 1),
      intelligence: 3 + lv * 2 + random.nextInt(lv + 1),
    );
  }

  static Monster fuse(Monster a, Monster b) {
    final resultType = a.magic >= b.magic ? a.type : b.type;

    return Monster(
      id: DateTime.now().microsecondsSinceEpoch.toString() +
          Random().nextInt(10000).toString(),
      type: resultType,
      level: a.level + b.level,
      magic: max(a.magic, b.magic) + (min(a.magic, b.magic) ~/ 2),
      spirit: max(a.spirit, b.spirit) +
          (min(a.spirit, b.spirit) / 2).ceil(),
      intelligence: max(a.intelligence, b.intelligence) +
          (min(a.intelligence, b.intelligence) ~/ 2),
    );
  }
}
