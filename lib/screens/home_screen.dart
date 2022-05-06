import 'package:avoid_it/providers/game_provider.dart';
import 'package:avoid_it/screens/lobby_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Avoid It"),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue, width: 2)),
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                  width: 300,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      var _pointsController = TextEditingController();

                      var _adminController = TextEditingController();
                      await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Enter Data'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      decoration: const InputDecoration(
                                          labelText: "Max Points"),
                                      controller: _pointsController,
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                          labelText: "Your name"),
                                      controller: _adminController,
                                    )
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('CANCEL'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Create'),
                                    onPressed: () async {
                                      if (_adminController.text.isNotEmpty) {
                                        gameProvider.setMyName =
                                            _adminController.text;
                                        showDialog(
                                          context: context,
                                          builder: (context) => const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        );
                                        await gameProvider
                                            .createRoom(
                                                int.tryParse(_pointsController
                                                        .text) ??
                                                    21,
                                                _adminController.text)
                                            .then((value) {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LobbyScreen(),
                                            ),
                                          );
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ));
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                    ),
                    icon: const Icon(Icons.create_new_folder_rounded),
                    label: const Text('Create Room'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 80,
                  width: 300,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      var _nameController = TextEditingController();
                      var _roomIdController = TextEditingController();
                      await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Enter Room Id.'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      decoration: const InputDecoration(
                                          labelText: "Your name"),
                                      controller: _nameController,
                                    ),
                                    TextField(
                                      decoration: const InputDecoration(
                                          labelText: "Room id"),
                                      controller: _roomIdController,
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('CANCEL'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Join'),
                                    onPressed: () async {
                                      if (_roomIdController.text.isNotEmpty &&
                                          _nameController.text.isNotEmpty &&
                                          !gameProvider.isGamePlaying) {
                                        gameProvider.setRoomId =
                                            _roomIdController.text;
                                        gameProvider.setMyName =
                                            _nameController.text;
                                        showDialog(
                                          context: context,
                                          builder: (context) => const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        );
                                        try {
                                          await gameProvider
                                              .addPlayer(_nameController.text);
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LobbyScreen(),
                                            ),
                                          );
                                        } catch (e) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content:
                                                Text("Something went wrong"),
                                          ));
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ));
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(Icons.add_box_rounded),
                    label: const Text('Join'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 300,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(60.0),
                          bottomRight: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0),
                          bottomLeft: Radius.circular(60.0)),
                      color: Colors.blue,
                    ),
                    padding: const EdgeInsets.all(40),
                    child: const Text(
                      "Create Room: Create a room and share the room ID with your friends. \n\nJoin Room: Enter the shared room ID to join a room ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
