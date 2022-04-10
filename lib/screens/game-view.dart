import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocabify/data/vault.dart';
import '../providers/app_provider.dart';
import 'game.dart';
import 'match_game.dart';

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
      // appBar: SearchBar(),
      body: GameViewContainer(),
      //there is only one game right now
      //body: MatchGameView(vault: Provider.of<AppProvider>(context).coreVault, vaultIndex: -1),
    );
  }

  //skeleton concept for a vault selection; make future?
  DropdownButton _selectVaultDropdown() {
    List<Vault> vault = (Provider.of<AppProvider>(context)..vaults) as List<Vault>;
    String selected = Provider.of<AppProvider>(context).coreVault.name;

    List<DropdownMenuItem> menuItemList = vault
        .map((val) => DropdownMenuItem(value: val, child: Text(val.name)))
        .toList();

    return DropdownButton(
      value: selected,
      onChanged: (val) => setState(() => selected = val),
      items: menuItemList,
    );   
  }

  Future selectVault() => showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: Text('Which Vault', textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
      content: Container (
        child: _selectVaultDropdown(),
      ),
    ),
    
  );


  // Overall body container in the gameview; game selector
  Widget GameViewContainer() {
    return Container(
      child: _buildRow(),
    );
  }
  Widget _buildRow() {
    return ListTile(
      leading: const Text("Definition Match",
          textScaleFactor: 1.6,
          style: TextStyle(fontWeight: FontWeight.bold)),
      // title: const Text(
      //   "Played 10 times",
      //   textScaleFactor: 1.3,
      //   textAlign: TextAlign.right,
      // ),
      onTap: () => MatchGameView(vault: Provider.of<AppProvider>(context).coreVault, vaultIndex: -1),
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