import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
class GameProvider with ChangeNotifier {
  List<String> get players {
    return _players;
  }
  String _myName = "admin";
  String get myName {
    return _myName;
  }

  set setMyName(String n) {
    _myName = n;
    notifyListeners();
  }

  Future<void> restart(int max) {
    return _fireStoreReference
        .doc(_roomId)
        .update({'winner': 'none', 'Points': max}).then((value) => null);
  }

  String checkWinner(int _p, String turn) {
    _currentTurn = turn;
    if (_p == 1) {
      return _currentTurn;
    } else if (_p == 0) {
      return _players.indexOf(_currentTurn) == 0
          ? _players.last
          : _players[_players.indexOf(_currentTurn) - 1];
    }
    return "none";
  }

  Future<void> makeMove(
      int decreasePoints, int pointsLeft, String lastTurn) async {
    return _fireStoreReference.doc(_roomId).update({
      'winner': checkWinner(pointsLeft - decreasePoints, lastTurn),
      'currentTurn': changeTurn(lastTurn),
      'Points': FieldValue.increment(-decreasePoints)
    }).then((value) => null);
  }

  var _roomId = "";
  var _currentTurn = "";
  final CollectionReference _fireStoreReference =
      FirebaseFirestore.instance.collection('data/roomsList/rooms');
  List<String> _players = [];
  Future<void> addPlayer(String playerName) {
    return _fireStoreReference.doc(_roomId).update({
      'players': FieldValue.arrayUnion([playerName])
    }).then((value) => null);
  }

  String get roomId {
    return _roomId;
  }

  set setRoomId(String userEnteredId) {
    _roomId = userEnteredId;
  }

  Future<void> createRoom(int Points, String adminName) {
    _roomId = List.generate(
        5,
        (index) =>
            'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890'[
                Random().nextInt(62)]).join();
    notifyListeners();
    return _fireStoreReference
        .doc(_roomId)
        .set({
          'MAX': Points,
          'winner': 'none',
          'players': [adminName],
          'Room Created At': DateTime.now().toString(),
          'Points': Points,
          'currentTurn': adminName,
          'admin': adminName,
          'gameRunning': false
        })
        .then((value) {})
        .catchError((error) => print("Failed to add data: $error"));
  }

  Future<void> sendGameStartDataToFirebase() {
    _roomId = List.generate(
        5,
        (index) =>
            'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890'[
                Random().nextInt(62)]).join();
    return _fireStoreReference.doc(_roomId).set(
      {
        'players': {..._players},
        'currentScore': 25,
        'currentTurn': _players[0]
      },
    ).then((value) {
      _currentTurn = _players[0];
      notifyListeners();
    }).catchError((error) => print("Failed to add data: $error"));
  }

  bool isGamePlaying = false;
  Future<void> changeGameState(bool val) {
    isGamePlaying = val;
    notifyListeners();
    return _fireStoreReference.doc(_roomId).update({'gameRunning': val});
  }

  String changeTurn(String a) {
    _currentTurn = a;
    return _players.indexOf(_currentTurn) == _players.length - 1
        ? _players[0]
        : _players[_players.indexOf(_currentTurn) + 1];

    // return _fireStoreReference
    //     .doc(_roomId)
    //     .update({'currentTurn': _currentTurn}).then((value) {
    //   print("Turn Changed");
    //}
    //);
  }

  Stream<DocumentSnapshot<Object?>> getRoomData() {
    return _fireStoreReference.doc(_roomId).snapshots();
  }

  void updateProviderdata() async {
    List a = await _fireStoreReference
        .doc(_roomId)
        .get()
        .then((value) => value.data() as Map<dynamic, dynamic>)
        .then((value) => value['players']);
    _players = [...a];
    _currentTurn = _players[0];
  }

  Stream<DocumentSnapshot<Object?>> getPlayerStreamData() {
    return _fireStoreReference.doc(_roomId).snapshots().map((event) => event);
  }
}
