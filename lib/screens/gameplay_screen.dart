import 'package:avoid_it/providers/game_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameplayScreen extends StatefulWidget {
  const GameplayScreen({Key? key}) : super(key: key);

  @override
  _GameplayScreenState createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    gameProvider.updateProviderdata();
    final _userInput = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Avoid It"),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder(
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
                      return snapshot.data!['winner'].toString() == "none"
                          ? Column(
                              children: [
                                Text("Points = ${snapshot.data!['Points']}"),
                                Text(
                                  snapshot.data!['currentTurn'] + "'s Turn",
                                ),
                                Form(
                                  key: _formKey,
                                  child: TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        try {
                                          int.parse(value!);
                                        } catch (e) {
                                          return "error";
                                        }
                                        if (snapshot.data!['currentTurn'] ==
                                                gameProvider.myName &&
                                            ((value.isEmpty) ||
                                                int.tryParse(value)! > 4 ||
                                                int.tryParse(value)! <= 0)) {
                                          return "Enter a number between 1 and 4";
                                        } else if (snapshot
                                                    .data!['currentTurn'] ==
                                                gameProvider.myName &&
                                            int.tryParse(value)! >
                                                snapshot.data!['Points']) {
                                          return "Enter a number between 1 and ${snapshot.data!['Points']} ";
                                        }
                                      },
                                      enabled: snapshot.data!['currentTurn'] ==
                                          gameProvider.myName,
                                      keyboardType: TextInputType.number,
                                      controller: _userInput),
                                ),
                                ElevatedButton.icon(
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: (snapshot.data!['currentTurn'] ==
                                          gameProvider.myName)
                                      ? () async {
                                          if (!(_formKey.currentState!
                                              .validate())) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text('error')),
                                            );
                                            return;
                                          }
                                          debugPrint(_userInput.text);
                                          await gameProvider.makeMove(
                                              int.parse(_userInput.text),
                                              snapshot.data!['Points'],
                                              snapshot.data!['currentTurn']);
                                        }
                                      : null,
                                  icon: const Icon(Icons.add),
                                  label: const Text('Make Move'),
                                ),
                              ],
                            )
                          : SizedBox(
                              child: AlertDialog(
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          await gameProvider
                                              .restart(snapshot.data!['MAX']);
                                        },
                                        child: Text("Restart"))
                                  ],
                                  elevation: 20,
                                  insetPadding: EdgeInsets.all(40),
                                  alignment: Alignment.center,
                                  content: Text(
                                    snapshot.data!['winner'] + " Won the game",
                                    style: TextStyle(fontSize: 40),
                                  )),
                            );
                    }
                    return Text("Welcome");
                  }),
            ],
          ),
        ));

/*

          Row(
            children: [
              Expanded(
                child: TextField(
                  enabled: currentTurn == Users[0],
                  controller: _textEditingController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (String num) {
                    changePoints;
                  },
                ),
              ),
              Spacer(),
              Expanded(
                child: TextField(
                  enabled: currentTurn == Users[1],
                  controller: _textEditingController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (String num) {
                    changePoints;
                  },
                ),
              ),
            ],
          ),
          */
  }
}
