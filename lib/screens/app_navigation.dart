import 'package:flutter/material.dart';

import 'account-view.dart';
import 'friends.dart';
import 'game-view.dart';
import 'home-screen.dart';
import '../providers/app_provider.dart';
import 'package:provider/provider.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({Key? key}) : super(key: key);

  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int currentIndex = 0;

  List<Widget> screens = <Widget>[
    //screen objects placed here
    const HomeScreen(),
    //const GameView(),
    const Text('Game view broken'),
    const FriendsListScreen(),
    const AccountView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.deepPurple[300],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white70,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: 'Bank',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.extension),
            label: 'Game',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
