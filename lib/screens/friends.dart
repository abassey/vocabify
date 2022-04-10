import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocabify/screens/add-friends.dart';
import '../providers/app_provider.dart';
import 'friend-account.dart';
import 'dart:math';

class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({Key? key}) : super(key: key);

  @override
  State<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  bool _isEditMode = false;
  double iconSize = 20;
  List<dynamic> friendsList = [];

  @override
  Widget build(BuildContext context) {
    friendsList = Provider.of<AppProvider>(context).currentFriends;

    return Scaffold(
      appBar: friendsBar(),
      body: friendsListView(),
    );
  }

  AppBar friendsBar() {
    return AppBar(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Friends",
              textAlign: TextAlign.start, style: TextStyle(fontSize: 23)),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
      centerTitle: false,
      actions: [
        //temporarily a popup button until add friend functionality is added
        IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddFriends()));
            }),
      ],
    );
  }

  ListView friendsListView() {
    return ListView.builder(
      itemCount: friendsList.length +
          (friendsList.length - 1 < 0 ? 0 : friendsList.length - 1),
      itemBuilder: (context, i) {
        var index = (i ~/ 2);
        if (i.isOdd) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.0),
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
    Random random = Random();
    int randomNumber = random.nextInt(500);

    return ListTile(
      leading: Text(friend["name"],
          textScaleFactor: 1.6,
          style: const TextStyle(fontWeight: FontWeight.bold)),
      title: const Text(
        //this will not be const when we add games back in
        "0 games won",
        textScaleFactor: 1.3,
        textAlign: TextAlign.right,
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FriendsAccount(
                      name: friend["name"],
                      wordsLearned: randomNumber,
                    )));
      },
    );
  }
}
