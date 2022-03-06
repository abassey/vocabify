import 'package:flutter/material.dart';
import "game.dart";

class GameView extends StatefulWidget {
  const GameView({Key? key,}) : super(key: key);

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  bool _isEditMode = false;
  double iconSize = 20;
  List<Game> games = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBar(),
      body: GameViewContainer(),
    );
  }

  // Overall body container in the gameview
  Widget GameViewContainer() {
    return Container(
      child: _buildRow(),
    );
  }
  Widget _buildRow() {
    return ListTile(
      leading: Text("WordMemorizer",
          textScaleFactor: 1.6,
          style: const TextStyle(fontWeight: FontWeight.bold)),
      title: Text(
        "Played 10 times",
        textScaleFactor: 1.3,
        textAlign: TextAlign.right,
      ),
      onTap: () {},
    );
  }
  // The AppBar widget in gameview
  AppBar SearchBar() {
    return AppBar(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _isEditMode
              ? const TextBoxSearch()
              : const Text("Games", textAlign: TextAlign.start),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
      centerTitle: false,
      actions: [
        Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
                onPressed: () =>{
                  setState(() {
                    _isEditMode = !_isEditMode;
                    if (_isEditMode) {
                      iconSize = 15;
                    } else {
                      iconSize = 20;
                    }
                  }),
                },
                icon: !_isEditMode
                    ? const Icon(Icons.search)
                    : const Icon(Icons.close))),
        //temporarily a popup button until add friend functionality is added
      ],
    );
  }
}

// The textbar widget
class TextBoxSearch extends StatelessWidget {
  const TextBoxSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      alignment: Alignment.centerLeft,
      color: Colors.white,
      height: 30,
      child: const TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(fontSize: 15)),
      ),
    );
  }
}