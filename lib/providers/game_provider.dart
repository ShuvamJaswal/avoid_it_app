// import 'package:avoid_it/helper/player.dart';
// import 'package:flutter/cupertino.dart';

// class GameProvider with ChangeNotifier {
//   final List<Player> _players = [
//     Player(name: "Shuvam"),
//     Player(name: "Jaswal"),
//   ];
//   List<Player> get players {
//     return _players;
//   }

//   GameProvider() {
//     currentTurn = players[0];
//   }

//   var currentTurn;
//   void changeTurn() {
//
//   }

//   int? currentTurnIndex;
//   void findIndexOfCurrentTurn() {
//     currentTurnIndex = _players.indexOf(currentTurn);
//     notifyListeners();
//   }

//   void addPlayer(Player p) {
//     _players.add(p);
//     notifyListeners();
//   }

//   int _totalPoints = 20;
//   void getPointsFromCloud() {}
//   int get totalPoints {
//     return _totalPoints;
//   }

//   void decreasePoint(String _points) {
//     if (_totalPoints > 1) {
//       _totalPoints -= int.parse(_points);
//       notifyListeners();
//     }
//   }

//   void checkWinner() {
//     if (_totalPoints == 1) {
//       print(currentTurn.name);
//     } else if (_totalPoints == 0) {
//       changeTurn(); //because last player chose to take all points(chosen points=points left, so the other player will be winner to get other playes name i used change turn)
//       print(currentTurn.name);
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class GameProvider with ChangeNotifier {
  List<String> get players {
    return _players;
  }

  var _roomId = "";
  var _currentTurn = "";
  CollectionReference _fireStoreReference =
      FirebaseFirestore.instance.collection('data/roomsList/rooms');
  List<String> _players = [];
  void addPlayer(String playerName) {
    _players.add(playerName);
    notifyListeners();
  }

  Future<void> sendGameStartDataToFirebase() {
    print('sending data');
    return _fireStoreReference.add(
      {
        'players': {..._players},
        'currentScore': 25,
        'currentTurn': _players[0]
      },
    ).then((value) {
      _roomId = value.id;
      _currentTurn = _players[0];
      notifyListeners();
    }).catchError((error) => print("Failed to add data: $error"));
  }

  Future<void> changeTurn() {
    _currentTurn = _players.indexOf(_currentTurn) == _players.length - 1
        ? _players[0]
        : _players[_players.indexOf(_currentTurn) + 1];
    return _fireStoreReference
        .doc(_roomId)
        .update({'currentTurn': _currentTurn}).then((value) {
      print("Turn Changed");
    });
  }

  Stream<DocumentSnapshot<Object?>> getRoomData() {
    return _fireStoreReference
        .doc(_roomId)
        .snapshots(); //changedocID when opening new page
    //  return _fireStoreReference.snapshots().map((snapShot) => snapShot);

    //.map((document) => document.data()));
  }
}
