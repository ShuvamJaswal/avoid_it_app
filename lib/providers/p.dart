import 'package:avoid_it/helper/player.dart';
import 'package:flutter/cupertino.dart';

class Pr with ChangeNotifier {
  final List<Player> _players = [
    Player(name: "Shuvam"),
    Player(name: "Jaswal"),
  ];
  List<Player> get players {
    return _players;
  }

  Pr() {
    currentTurn = players[0];
  }

  var currentTurn;
  void changeTurn() {
    currentTurn = _players.indexOf(currentTurn) == _players.length - 1
        ? _players[0]
        : _players[_players.indexOf(currentTurn) + 1];
    notifyListeners();
  }

  int? currentTurnIndex;
  void findIndexOfCurrentTurn() {
    currentTurnIndex = _players.indexOf(currentTurn);
    notifyListeners();
  }

  void addPlayer(Player p) {
    _players.add(p);
    notifyListeners();
  }

  int _totalPoints = 20;
  int get totalPoints {
    return _totalPoints;
  }

  void decreasePoint(String _points) {
    if (_totalPoints > 1) {
      _totalPoints -= int.parse(_points);
      notifyListeners();
    }
  }

  void checkWinner() {
    if (_totalPoints == 1) {
      print(currentTurn.name);
    } else if (_totalPoints == 0) {
      changeTurn(); //because last player chose to take all points(chosen points=points left, so the other player will be winner to get other playes name i used change turn)
      print(currentTurn.name);
    }
  }
}
