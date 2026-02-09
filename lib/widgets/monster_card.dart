import 'package:flutter/material.dart';
import '../models/monster.dart';
import 'monster_painter.dart';

class MonsterCard extends StatelessWidget {
  final Monster monster;
  final bool isSelected;
  final bool highlightStats;
  final VoidCallback? onTap;

  const MonsterCard({
    super.key,
    required this.monster,
    this.isSelected = false,
    this.highlightStats = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statColor = highlightStats ? Colors.red : Colors.black87;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MonsterAvatar(monster: monster, size: 48),
            const SizedBox(height: 2),
            Text(
              'Lv.${monster.level}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: highlightStats ? Colors.red : Colors.black87,
              ),
            ),
            _statRow('魔力', monster.magic, statColor),
            _statRow('精神', monster.spirit, statColor),
            _statRow('知力', monster.intelligence, statColor),
          ],
        ),
      ),
    );
  }

  Widget _statRow(String label, int value, Color color) {
    return Text(
      '$label:$value',
      style: TextStyle(
        fontSize: 10,
        color: color,
        fontWeight: highlightStats ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
