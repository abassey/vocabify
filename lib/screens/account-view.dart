import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final double backDropHeight = 200;
  final double profileHeight = 144;
  bool friendState = true;

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(appProvider.name != null ? appProvider.name! : "Profile", style: const TextStyle(fontSize: 23)),
          actions: [
            const Center(child:Text('Logout',  style: TextStyle(fontSize: 18))),
            IconButton(
                onPressed: () =>
                    appProvider.signOut(),
                icon: const Icon(Icons.logout)
            )
          ],
        ),
        body: ListView(
          children: [
            buildTop(context),
            buildBottom(context),
          ],
        ));
  }

  //everything below the profile picture
  Widget buildBottom(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(appProvider.name != null ? appProvider.name! : "Profile",
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text('Words Learned: ${Provider.of<AppProvider>(context).wordsLearned}',
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green)),
        ),
      ],
    );
  }

  //Builds a backdrop with a profile picture ontop
  Widget buildTop(BuildContext context) {
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
