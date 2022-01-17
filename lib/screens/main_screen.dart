import 'package:avoid_it/helper/brain.dart';
import 'package:avoid_it/helper/player.dart';
import 'package:avoid_it/providers/p.dart';
import 'package:avoid_it/widgets/number_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void start() {}

  //List Users = [Player(name: "Player1"), Player(name: "Player2")];

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Avoid It"),
      ),
      body: Column(
        children: [
          Consumer<Pr>(
            child: const Text(
              "no data",
            ),
            builder: (context, value, child) {
              return Text("points left = ${value.totalPoints}");
            },
          ),
          Expanded(
            child: Consumer<Pr>(
              child: const Text(
                "no data",
              ),
              builder: (context, provider, child) {
                return Form(
                  key: _formKey,
                  child: ListView.builder(
                    itemBuilder: (context, index) => TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (provider.players.indexOf(provider.currentTurn) ==
                                index &&
                            ((value!.isEmpty) ||
                                int.parse(value) > 4 ||
                                int.parse(value) <= 0)) {
                          return "Enter a number between 1 and 4";
                        } else if (provider.players
                                    .indexOf(provider.currentTurn) ==
                                index &&
                            int.parse(value!) > provider.totalPoints) {
                          return "Enter a number between 1 and ${provider.totalPoints} ";
                        }
                      },
                      enabled: index ==
                          provider.players.indexOf(provider.currentTurn),
                      keyboardType: TextInputType.number,
                      controller: provider.players[index].textController,
                      decoration: InputDecoration(
                        labelText: provider.players[index].name,
                      ),
                    ),
                    itemCount: provider.players.length,
                  ),
                );
              },
            ),
          ),
          ElevatedButton.icon(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              if (!(_formKey.currentState!.validate())) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('error')),
                );
                return;
              }

              Provider.of<Pr>(context, listen: false)
                ..decreasePoint(Provider.of<Pr>(context, listen: false)
                    .currentTurn
                    .textController
                    .text)
                ..checkWinner()
                ..changeTurn();
              //      changeTurn();
              //changePoints();
            },
            icon: const Icon(Icons.add),
            label: const Text('add place'),
          ),
        ],
      ),
    );
  }
}






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