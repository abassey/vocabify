import 'package:flutter/material.dart';
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
        appBar: AppBar(title: Text(widget.name + ' Profile')),
        body: ListView(
          children: [
            buildTop(),
            buildBottom(),
            //Add vaults
            for (int i = 0; i < 3; i++) buildVault()
          ],
        ));
  }

  //everything below the profile picture
  Widget buildBottom() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(widget.name,
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                  (friendState == true)
                      ? Icons.check_circle
                      : Icons.add_circle,
                  size: 30,
                  color: (friendState == true) ? Colors.blue : Colors.red[900]),
              onPressed: () {
                setState(() {
                  friendState = !friendState;
                });
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
        const Divider(thickness: 2),
        const Align(
            //This is just for the shared vault title
            alignment: Alignment.bottomLeft,
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('Shared Vaults',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)))),
      ],
    );
  }

  //Builds a vault container with the name in the middle
  Widget buildVault() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const VaultView(vaultTitle: "Vault View")));
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