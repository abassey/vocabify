import 'package:flutter/material.dart';

class AccountView extends StatefulWidget {
  const AccountView({ Key? key, required this.name, required this.wordsLearned }) : super(key: key);
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
      appBar: AppBar(
        title: Text(widget.name + ' Profile')
      ),
      body: ListView(
        children: [
          buildTop(),
          buildBottom()
        ],
      )
    );
  }

  //everything below the profile picture
  Widget buildBottom(){
    return Column(
      children: [
        Text(widget.name, style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon((friendState == true) ? Icons.check_circle : Icons.unpublished,size: 30, color:(friendState == true) ? Colors.blue : Colors.red[900]),
              onPressed: () {
                setState(() {
                  friendState = !friendState;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text((friendState == true) ? 'FRIENDS ' : 'UN-FRIENDED', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        Text('Words Learned: ${widget.wordsLearned}', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green)),
        const Divider(thickness: 2),
        const Align( //This is just for the shared vault title
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('Shared Vaults', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))
          )
        ),
      ],
    );
  }

  //Builds a backdrop with a profile picture ontop
  Widget buildTop(){
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(child: backDrop(), margin: EdgeInsets.only(bottom: profileHeight / 2)),
        Positioned(top: backDropHeight - profileHeight / 2, child: profilePicture()),
      ]
    );
  }

  Widget backDrop() {
    return Container(
      color: Colors.blue,
      width: double.infinity,
      height: backDropHeight,
    );
  }

  Widget profilePicture() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(radius: profileHeight / 1.8, backgroundColor: Colors.grey[50]),
        CircleAvatar(
          radius: profileHeight / 2,
          backgroundColor: Colors.grey[50],
          backgroundImage: const NetworkImage(
            'https://s1.ticketm.net/dam/a/2d9/2f921db0-3766-4ceb-b1a8-597b8cc672d9_1277181_TABLET_LANDSCAPE_LARGE_16_9.jpg'
          ),
        ),
      ]
    );
  }
}