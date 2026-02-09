import 'package:flutter/material.dart';
import '../models/monster.dart';

/// Draws a pixel-art style monster using CustomPainter
class MonsterPainter extends CustomPainter {
  final MonsterType type;
  final int level;

  MonsterPainter({required this.type, required this.level});

  @override
  void paint(Canvas canvas, Size size) {
    final pixelSize = size.width / 8;

    // Background glow based on type
    final glowColor = _getTypeColor(type).withValues(alpha: 0.2);
    final glowPaint = Paint()..color = glowColor;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.45,
      glowPaint,
    );

    // Draw the monster body
    final bodyPaint = Paint()..color = _getTypeColor(type);
    final darkPaint = Paint()..color = _getTypeColor(type).withValues(alpha: 0.7);
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = Colors.black;

    switch (type) {
      case MonsterType.fire:
        _drawFireMonster(
            canvas, pixelSize, bodyPaint, darkPaint, eyePaint, pupilPaint);
        break;
      case MonsterType.aqua:
        _drawAquaMonster(
            canvas, pixelSize, bodyPaint, darkPaint, eyePaint, pupilPaint);
        break;
      case MonsterType.wind:
        _drawWindMonster(
            canvas, pixelSize, bodyPaint, darkPaint, eyePaint, pupilPaint);
        break;
      case MonsterType.earth:
        _drawEarthMonster(
            canvas, pixelSize, bodyPaint, darkPaint, eyePaint, pupilPaint);
        break;
      case MonsterType.light:
        _drawLightMonster(
            canvas, pixelSize, bodyPaint, darkPaint, eyePaint, pupilPaint);
        break;
      case MonsterType.dark:
        _drawDarkMonster(
            canvas, pixelSize, bodyPaint, darkPaint, eyePaint, pupilPaint);
        break;
    }

    // Level indicator - extra details for higher levels
    if (level >= 10) {
      final starPaint = Paint()..color = Colors.amber;
      canvas.drawCircle(Offset(pixelSize * 7, pixelSize), pixelSize * 0.4, starPaint);
    }
  }

  void _drawPixel(Canvas canvas, double px, int x, int y, Paint paint) {
    canvas.drawRect(
      Rect.fromLTWH(x * px, y * px, px, px),
      paint,
    );
  }

  void _drawFireMonster(Canvas canvas, double px, Paint body, Paint dark,
      Paint eye, Paint pupil) {
    // Flame-like body
    for (var pos in [
      [3, 1], [4, 1],
      [2, 2], [3, 2], [4, 2], [5, 2],
      [2, 3], [3, 3], [4, 3], [5, 3],
      [1, 4], [2, 4], [3, 4], [4, 4], [5, 4], [6, 4],
      [1, 5], [2, 5], [3, 5], [4, 5], [5, 5], [6, 5],
      [2, 6], [3, 6], [4, 6], [5, 6],
      [2, 7], [3, 7], [4, 7], [5, 7],
    ]) {
      _drawPixel(canvas, px, pos[0], pos[1], body);
    }
    // Flame tips
    for (var pos in [
      [2, 0], [5, 0], [1, 1], [6, 1],
    ]) {
      _drawPixel(canvas, px, pos[0], pos[1],
          Paint()..color = Colors.orange.shade300);
    }
    // Eyes
    _drawPixel(canvas, px, 3, 4, eye);
    _drawPixel(canvas, px, 5, 4, eye);
    _drawPixel(canvas, px, 3, 4, pupil..color = Colors.black87);
    _drawPixel(canvas, px, 5, 4, pupil);
    // Mouth
    _drawPixel(canvas, px, 3, 6, dark);
    _drawPixel(canvas, px, 4, 6, dark);
  }

  void _drawAquaMonster(Canvas canvas, double px, Paint body, Paint dark,
      Paint eye, Paint pupil) {
    // Round water body
    for (var pos in [
      [3, 1], [4, 1],
      [2, 2], [3, 2], [4, 2], [5, 2],
      [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3],
      [1, 4], [2, 4], [3, 4], [4, 4], [5, 4], [6, 4],
      [1, 5], [2, 5], [3, 5], [4, 5], [5, 5], [6, 5],
      [2, 6], [3, 6], [4, 6], [5, 6],
      [3, 7], [4, 7],
    ]) {
      _drawPixel(canvas, px, pos[0], pos[1], body);
    }
    // Bubbles
    _drawPixel(canvas, px, 7, 2, Paint()..color = Colors.lightBlue.shade100);
    _drawPixel(canvas, px, 0, 3, Paint()..color = Colors.lightBlue.shade100);
    // Eyes
    _drawPixel(canvas, px, 3, 3, eye);
    _drawPixel(canvas, px, 5, 3, eye);
    _drawPixel(canvas, px, 3, 4, Paint()..color = Colors.black87);
    _drawPixel(canvas, px, 5, 4, Paint()..color = Colors.black87);
  }

  void _drawWindMonster(Canvas canvas, double px, Paint body, Paint dark,
      Paint eye, Paint pupil) {
    // Swirl shape
    for (var pos in [
      [3, 0], [4, 0], [5, 0],
      [2, 1], [3, 1], [5, 1], [6, 1],
      [1, 2], [2, 2], [6, 2],
      [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3],
      [1, 4], [2, 4], [3, 4], [4, 4], [5, 4], [6, 4],
      [2, 5], [3, 5], [5, 5], [6, 5],
      [2, 6], [3, 6], [4, 6], [5, 6],
      [3, 7], [4, 7],
    ]) {
      _drawPixel(canvas, px, pos[0], pos[1], body);
    }
    // Eyes
    _drawPixel(canvas, px, 3, 3, eye);
    _drawPixel(canvas, px, 5, 3, eye);
    _drawPixel(canvas, px, 3, 4, Paint()..color = Colors.black87);
    _drawPixel(canvas, px, 5, 4, Paint()..color = Colors.black87);
  }

  void _drawEarthMonster(Canvas canvas, double px, Paint body, Paint dark,
      Paint eye, Paint pupil) {
    // Blocky golem
    for (var pos in [
      [2, 1], [3, 1], [4, 1], [5, 1],
      [2, 2], [3, 2], [4, 2], [5, 2],
      [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3],
      [1, 4], [2, 4], [3, 4], [4, 4], [5, 4], [6, 4],
      [1, 5], [2, 5], [3, 5], [4, 5], [5, 5], [6, 5],
      [1, 6], [2, 6], [5, 6], [6, 6],
      [1, 7], [2, 7], [5, 7], [6, 7],
    ]) {
      _drawPixel(canvas, px, pos[0], pos[1], body);
    }
    // Cracks/details
    _drawPixel(canvas, px, 3, 5, dark);
    _drawPixel(canvas, px, 4, 6, dark);
    // Eyes
    _drawPixel(canvas, px, 3, 3, eye);
    _drawPixel(canvas, px, 5, 3, eye);
    _drawPixel(canvas, px, 3, 3, Paint()..color = Colors.red.shade300);
    _drawPixel(canvas, px, 5, 3, Paint()..color = Colors.red.shade300);
  }

  void _drawLightMonster(Canvas canvas, double px, Paint body, Paint dark,
      Paint eye, Paint pupil) {
    // Angelic/star shape
    for (var pos in [
      [3, 0], [4, 0],
      [2, 1], [3, 1], [4, 1], [5, 1],
      [1, 2], [2, 2], [3, 2], [4, 2], [5, 2], [6, 2],
      [0, 3], [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3],
      [1, 4], [2, 4], [3, 4], [4, 4], [5, 4], [6, 4],
      [2, 5], [3, 5], [4, 5], [5, 5],
      [1, 6], [2, 6], [5, 6], [6, 6],
      [0, 7], [1, 7], [6, 7], [7, 7],
    ]) {
      _drawPixel(canvas, px, pos[0], pos[1], body);
    }
    // Eyes
    _drawPixel(canvas, px, 3, 3, eye);
    _drawPixel(canvas, px, 5, 3, eye);
    _drawPixel(canvas, px, 3, 3, Paint()..color = Colors.amber);
    _drawPixel(canvas, px, 5, 3, Paint()..color = Colors.amber);
  }

  void _drawDarkMonster(Canvas canvas, double px, Paint body, Paint dark,
      Paint eye, Paint pupil) {
    // Shadow/ghost shape
    for (var pos in [
      [3, 0], [4, 0],
      [2, 1], [3, 1], [4, 1], [5, 1],
      [1, 2], [2, 2], [3, 2], [4, 2], [5, 2], [6, 2],
      [1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3],
      [1, 4], [2, 4], [3, 4], [4, 4], [5, 4], [6, 4],
      [1, 5], [2, 5], [3, 5], [4, 5], [5, 5], [6, 5],
      [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [6, 6],
      [1, 7], [3, 7], [5, 7],
    ]) {
      _drawPixel(canvas, px, pos[0], pos[1], body);
    }
    // Glowing eyes
    _drawPixel(canvas, px, 3, 3, Paint()..color = Colors.red);
    _drawPixel(canvas, px, 5, 3, Paint()..color = Colors.red);
  }

  Color _getTypeColor(MonsterType type) {
    switch (type) {
      case MonsterType.fire:
        return Colors.deepOrange;
      case MonsterType.aqua:
        return Colors.blue;
      case MonsterType.wind:
        return Colors.teal;
      case MonsterType.earth:
        return Colors.brown;
      case MonsterType.light:
        return Colors.amber;
      case MonsterType.dark:
        return Colors.deepPurple;
    }
  }

  @override
  bool shouldRepaint(covariant MonsterPainter oldDelegate) {
    return oldDelegate.type != type || oldDelegate.level != level;
  }
}

class MonsterAvatar extends StatelessWidget {
  final Monster monster;
  final double size;

  const MonsterAvatar({
    super.key,
    required this.monster,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: MonsterPainter(type: monster.type, level: monster.level),
    );
  }
}
