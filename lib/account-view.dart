import 'package:flutter/material.dart';
import 'dart:math';

class AccountView extends StatefulWidget {
  const AccountView(
      {Key? key, required this.name, required this.wordsLearned})
      : super(key: key);
  final String name;
  final int wordsLearned;

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
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
          ],
        ));
  }

  //everything below the profile picture
  Widget buildBottom() {
    return Column(
      children: [
        Text(widget.name,
            style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
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
                child: Text('Bio',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)))),
      ],
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
