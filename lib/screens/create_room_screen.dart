import 'package:avoid_it/helper/input_decoration_helper.dart';
import 'package:avoid_it/providers/game_provider.dart';
import 'package:avoid_it/screens/second_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({Key? key}) : super(key: key);

  @override
  _CreateRoomScreenState createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Avoid It"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                cursorColor: const Color(0xFF69639F),
                decoration: buildInputDecoration("PlayerName"),
                controller: textFieldController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  if (textFieldController.text.isNotEmpty &&
                      !(gameProvider.players
                          .contains(textFieldController.text))) {
                    gameProvider.addPlayer(textFieldController.text);
                  }
                  textFieldController.clear();
                },
                icon: const Icon(Icons.add),
                label: const Text('add player'),
              ),
            ),
            if (gameProvider.players.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: gameProvider.players.length,
                  itemBuilder: (context, index) => Text(
                    gameProvider.players[index],
                  ),
                ),
              ),
            Spacer(),
            ElevatedButton.icon(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                gameProvider.sendGameStartDataToFirebase().then(
                      (value) => Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (context) => SecondScreen(),
                            ),
                          )
                          .onError((error, stackTrace) => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                    title: Text(
                                  "Something Went Wrong",
                                )),
                              )),
                    );
                // gameProvider.getRoomData().listen((event) {
                //   print(event);
                // });
              },
              icon: const Icon(Icons.navigate_next),
              label: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
