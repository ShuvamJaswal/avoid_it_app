//Stop listening to stream in lobbyscfreen once im in next stream
//Stop listening to stream in lobbyscfreen once im in next stream

import 'dart:async';
import 'package:avoid_it/providers/game_provider.dart';
import 'package:avoid_it/screens/gameplay_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late StreamSubscription _subscription;
    final gameProvider = Provider.of<GameProvider>(context);
    _subscription = gameProvider.getRoomData().listen((event) {
      Map data = event.data() as Map<String, dynamic>;
      if (data['gameRunning']) {
        _subscription.cancel();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const GameplayScreen(),
        ));
      }
    });
    return Scaffold(
        appBar: AppBar(
          title: const Text("Avoid It"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: StreamBuilder<DocumentSnapshot>(
              stream: gameProvider.getRoomData(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.connectionState == ConnectionState.active) {
                  List players = snapshot.data!['players'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "Room Id= " + snapshot.data!.id,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Text("Currently Joined Players"),
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            shape: const RoundedRectangleBorder(
                                side: BorderSide(width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            title: Text(
                              players[index],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        itemCount: players.length,
                      ),
                      Container(
                        decoration: const BoxDecoration(color: Colors.amber),
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "Max Points" + snapshot.data!['Points'].toString(),
                        ),
                      ),
                      gameProvider.myName == snapshot.data!['admin']
                          ? TextButton(
                              onPressed: () {
                                if (players.length > 1) {
                                  gameProvider.changeGameState(true);
                                }
                              },
                              child: Text("Start"))
                          : const Text("Wait for Admin to start the game"),
                    ],
                  );
                }
                return const Text("Something Wrong");
              }),
        ));
  }
}
