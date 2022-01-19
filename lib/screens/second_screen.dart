import 'package:avoid_it/providers/game_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    print("SecondScreen");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Avoid It"),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                  stream: gameProvider.getRoomData(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.connectionState == ConnectionState.active) {
                      return Column(
                        children: [
                          Text(snapshot.data!['currentScore'].toString()),
                          Text(
                            snapshot.data!['currentTurn'],
                          ),
                        ],
                      );
                    }
                    return Text("Something Wrong");
                  })),
          ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () async {
              await gameProvider.changeTurn();
              // gameProvider.getRoomData().listen((event) {
              //   print(event);
              // });
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}
