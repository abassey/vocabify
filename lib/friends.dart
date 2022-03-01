import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'friendsdata.dart';

class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({Key? key}) : super(key: key);

  @override
  State<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  bool _isEditMode = false;
  double iconSize = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start, 
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            _isEditMode ? const TextBoxSearch() : Text("Friends List", textAlign: TextAlign.start),
            Row(
              children: [ 
                Icon(Icons.person_add_alt_1_rounded , size: iconSize),
              ]
            ),
          ], 
          mainAxisSize: MainAxisSize.min,
        ),
        centerTitle: false,
        actions: [
        Padding(
          padding: const EdgeInsets.all(10), 
          child: IconButton(onPressed: () => {
            setState(() {
              _isEditMode = !_isEditMode;
              if (_isEditMode) {
                iconSize = 15;
              } else {
                iconSize = 20;
              }
            }),
          }, icon: !_isEditMode ? const Icon(Icons.search) : const Icon(Icons.close)) 
        )
        ],
      ),
      body: friendsListView(),
    );
  }

  ListView friendsListView() {
    return ListView.builder(
      itemCount: friendsList.length + 1,
      itemBuilder: (context, i) {
        var index = (i ~/ 2);
        if (i.isOdd || index >= friendsList.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Divider(
              color: Colors.black87,
              thickness: 0.5,
            ),
          );
        }
        return _buildRow(friendsList[index]);
      },
    );
  }

  Widget _buildRow(friend) {
    return ListTile(
      leading: Text(
        friend["name"], 
        textScaleFactor: 1.6,
        style: TextStyle(fontWeight: FontWeight.bold) 
      ),
      title: Text(
        friend["gamesWon"] + " games won",
        textScaleFactor: 1.3,
        textAlign: TextAlign.right,
      )
    );
  }
}

class TextBoxSearch extends StatelessWidget {
  const TextBoxSearch({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      alignment: Alignment.centerLeft,
      color: Colors.white,
      height: 30,
      child: const TextField(
        decoration:
            InputDecoration(border: InputBorder.none, hintText: 'Search', hintStyle: TextStyle(fontSize: 15)),
      ),
    );
  }
}