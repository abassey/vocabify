import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocabify/data/vault.dart';
import 'package:vocabify/providers/app_provider.dart';
import 'vault-view.dart';
import 'dart:math';

class FriendsAccount extends StatefulWidget {
  const FriendsAccount(
      {Key? key, required this.name, required this.wordsLearned})
      : super(key: key);
  final String name;
  final int wordsLearned;

  @override
  _FriendsAccountState createState() => _FriendsAccountState();
}

class _FriendsAccountState extends State<FriendsAccount> {
  final double backDropHeight = 200;
  final double profileHeight = 144;
  bool friendState = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.name + '\'s Profile')),
        body: ListView(
          children: [
            buildTop(),
            buildBottom(),
          ],
        ));
  }

  //everything below the profile picture
  Widget buildBottom() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Center(
            child: Text(widget.name, style:const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                  (friendState == true) ? Icons.check_circle : Icons.add_circle,
                  size: 30,
                  color: (friendState == true) ? Colors.blue : Colors.red[900]),
              onPressed: () {
                if(friendState){
                  String uid = Provider.of<AppProvider>(context, listen: false).getFriend(widget.name);
                  Provider.of<AppProvider>(context, listen: false).deleteFriend(uid);
                  setState(() {
                    friendState = false;
                  });
                }else{
                  String uid = Provider.of<AppProvider>(context, listen: false).friendUid;
                  Provider.of<AppProvider>(context, listen: false).friendUpdater(widget.name, uid);
                  setState(() {
                    friendState = true;
                  });
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text((friendState == true) ? 'FRIENDS ' : 'ADD FRIEND',
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        Text('Words Learned: ${widget.wordsLearned}',
            style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.green)),
        const SizedBox(height: 20),
        const Divider(thickness: 2),
      ],
    );
  }

  //Builds a vault container with the name in the middle
  Widget buildVault() {
    return GestureDetector(
      onTap: () {
        Vault vault = Vault(uid:'', name: "Vault View", vaultitems: [], fbusers: []);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => VaultView(vault: vault, vaultIndex: -1)));
      },
      child: Container(
          margin: const EdgeInsets.all(10.0),
          width: 200,
          height: 200,
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.grey[350]),
          child: const Center(
              child: Text('Shared Vault',
                  style:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.bold)))),
    );
  }

  //Builds a backdrop with a profile picture ontop
  Widget buildTop() {
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
              child: backDrop(),
              margin: EdgeInsets.only(bottom: profileHeight / 2)),
          Positioned(
              top: backDropHeight - profileHeight / 2, child: profilePicture()),
        ]);
  }

  Widget backDrop() {
    return Container(
      color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      width: double.infinity,
      height: backDropHeight,
    );
  }

  Widget profilePicture() {
    return Stack(alignment: Alignment.center, children: [
      CircleAvatar(
          radius: profileHeight / 1.8, backgroundColor: Colors.grey[50]),
      CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: Colors.grey[50],
        backgroundImage: const NetworkImage(
            'https://i.pinimg.com/474x/ba/ce/6a/bace6af70f7479f194ac067b73d5b5c8.jpg'),
      ),
    ]);
  }
}
