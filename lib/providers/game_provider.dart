import 'package:flutter/foundation.dart';
import '../models/monster.dart';
import '../models/battle_result.dart';

enum GamePhase {
  idle,
  fusionSelect,
  fusionPreview,
  battleSelect,
  battleResult,
  discovered,
  partyFull,
  gameOver,
}

class GameProvider extends ChangeNotifier {
  static const int initialAp = 1000;
  static const int searchCost = 1;
  static const int fusionCost = 10;
  static const int battleCost = 5;
  static const int maxPartySize = 5;

  int _score = 0;
  int _actionPoints = initialAp;
  List<Monster> _party = [];
  GamePhase _phase = GamePhase.idle;
  Monster? _discoveredMonster;
  Monster? _fusionTarget1;
  Monster? _fusionTarget2;
  Monster? _fusionPreview;
  Monster? _battleMonster;
  Monster? _battleEnemy;
  BattleResult? _lastBattleResult;
  String _eventMessage = '';
  int _highScore = 0;

  // Getters
  int get score => _score;
  int get actionPoints => _actionPoints;
  List<Monster> get party => List.unmodifiable(_party);
  GamePhase get phase => _phase;
  Monster? get discoveredMonster => _discoveredMonster;
  Monster? get fusionTarget1 => _fusionTarget1;
  Monster? get fusionTarget2 => _fusionTarget2;
  Monster? get fusionPreview => _fusionPreview;
  Monster? get battleMonster => _battleMonster;
  Monster? get battleEnemy => _battleEnemy;
  BattleResult? get lastBattleResult => _lastBattleResult;
  String get eventMessage => _eventMessage;
  int get highScore => _highScore;

  bool get canSearch => _actionPoints >= searchCost && _phase == GamePhase.idle;
  bool get canFuse =>
      _actionPoints >= fusionCost &&
      _party.length >= 2 &&
      (_phase == GamePhase.idle || _phase == GamePhase.fusionSelect);
  bool get canBattle =>
      _actionPoints >= battleCost &&
      _party.isNotEmpty &&
      _phase == GamePhase.idle;

  void startNewGame() {
    _score = 0;
    _actionPoints = initialAp;
    _party = [];
    _phase = GamePhase.idle;
    _discoveredMonster = null;
    _fusionTarget1 = null;
    _fusionTarget2 = null;
    _fusionPreview = null;
    _battleMonster = null;
    _battleEnemy = null;
    _lastBattleResult = null;
    _eventMessage = '';
    notifyListeners();
  }

  // Search for a monster
  void search() {
    if (_actionPoints < searchCost) return;

    _actionPoints -= searchCost;
    _discoveredMonster = Monster.generate(maxLevel: 5);
    _eventMessage = 'モンスターを発見した！';

    if (_party.length < maxPartySize) {
      _party.add(_discoveredMonster!);
      _phase = GamePhase.discovered;
    } else {
      _phase = GamePhase.partyFull;
    }

    _checkGameOver();
    notifyListeners();
  }

  // Replace a party member with discovered monster (when party is full)
  void replacePartyMember(int index) {
    if (_discoveredMonster == null || index < 0 || index >= _party.length) {
      return;
    }
    _party[index] = _discoveredMonster!;
    _discoveredMonster = null;
    _phase = GamePhase.idle;
    notifyListeners();
  }

  void discardDiscovered() {
    _discoveredMonster = null;
    _phase = GamePhase.idle;
    notifyListeners();
  }

  void dismissEvent() {
    if (_phase == GamePhase.discovered) {
      _phase = GamePhase.idle;
      _discoveredMonster = null;
      notifyListeners();
    }
  }

  // Fusion
  void startFusion() {
    if (!canFuse) return;
    _fusionTarget1 = null;
    _fusionTarget2 = null;
    _fusionPreview = null;
    _phase = GamePhase.fusionSelect;
    _eventMessage = '合体するモンスターを2体選んでください';
    notifyListeners();
  }

  void selectFusionTarget(Monster monster) {
    if (_phase != GamePhase.fusionSelect) return;

    if (_fusionTarget1 == null) {
      _fusionTarget1 = monster;
      _eventMessage = '2体目を選んでください';
    } else if (_fusionTarget1!.id == monster.id) {
      // Deselect
      _fusionTarget1 = null;
      _eventMessage = '合体するモンスターを2体選んでください';
    } else {
      _fusionTarget2 = monster;
      _fusionPreview = Monster.fuse(_fusionTarget1!, _fusionTarget2!);
      _phase = GamePhase.fusionPreview;
      _eventMessage = '合体結果のプレビュー';
    }

    notifyListeners();
  }

  void confirmFusion() {
    if (_phase != GamePhase.fusionPreview ||
        _fusionTarget1 == null ||
        _fusionTarget2 == null ||
        _fusionPreview == null) {
      return;
    }

    if (_actionPoints < fusionCost) return;

    _actionPoints -= fusionCost;
    _party.removeWhere(
        (m) => m.id == _fusionTarget1!.id || m.id == _fusionTarget2!.id);
    _party.add(_fusionPreview!);

    _score += _fusionPreview!.level;
    _eventMessage =
        '合体成功！ Lv.${_fusionPreview!.level} が誕生！';

    _fusionTarget1 = null;
    _fusionTarget2 = null;
    _fusionPreview = null;
    _phase = GamePhase.idle;

    _checkGameOver();
    notifyListeners();
  }

  void cancelFusion() {
    _fusionTarget1 = null;
    _fusionTarget2 = null;
    _fusionPreview = null;
    _phase = GamePhase.idle;
    _eventMessage = '';
    notifyListeners();
  }

  // Battle
  void startBattle() {
    if (!canBattle) return;
    _phase = GamePhase.battleSelect;
    _eventMessage = '出撃するモンスターを選んでください';
    notifyListeners();
  }

  void selectBattleMonster(Monster monster) {
    if (_phase != GamePhase.battleSelect) return;

    _actionPoints -= battleCost;
    _battleMonster = monster;
    _battleEnemy = Monster.generateEnemy(_score);

    final result = BattleResult.execute(_battleMonster!, _battleEnemy!);
    _lastBattleResult = result;

    if (result.playerWon) {
      _score += result.scoreGained;
      _eventMessage =
          '勝利！ スコア +${result.scoreGained}';
    } else {
      _party.removeWhere((m) => m.id == monster.id);
      _eventMessage =
          '敗北... ${monster.type.displayName}が離脱した';
    }

    _phase = GamePhase.battleResult;
    _checkGameOver();
    notifyListeners();
  }

  void dismissBattleResult() {
    _lastBattleResult = null;
    _battleMonster = null;
    _battleEnemy = null;
    _phase = GamePhase.idle;
    notifyListeners();
  }

  void cancelBattle() {
    _phase = GamePhase.idle;
    _eventMessage = '';
    notifyListeners();
  }

  void _checkGameOver() {
    if (_actionPoints <= 0) {
      _phase = GamePhase.gameOver;
      if (_score > _highScore) {
        _highScore = _score;
      }
      _eventMessage = 'ゲーム終了！ スコア: $_score';
    }
  }
}
