import 'package:flutter/material.dart';
import 'vault-view.dart';
import 'friend-account.dart';
import 'friends.dart';
import 'account-view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;

  final screens = [
    //screen objects placed here
    const HomeScreen(),
    const Center(child: Text('page_2 - GAME', style: TextStyle(fontSize: 30))),
    const Center(
        child: Text('page_3 - ADD WORD', style: TextStyle(fontSize: 30))),
    const FriendsListScreen(),
    const AccountView(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vocabify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.white,
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
              icon: Icon(Icons.add_box),
              label: 'Add Word',
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
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> gridChild = [
    Stack(
      children: [
        Positioned.fill(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            width: 30.0,
            height: 50.0,
            color: Colors.black54,
          ),
        ),
        const Positioned.fill(
          child: Icon(
            Icons.add_box,
            size: 100,
            color: Colors.white,
          ),
        ),
      ],
    ),
  ];

  void addToGrid() {
    setState(() {
      gridChild.add(Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const VaultView(vaultTitle: "Vault View")));
          },
          child: Container(
            margin: const EdgeInsets.all(8.0),
            width: 30.0,
            height: 50.0,
            color: Colors.purple,
          ),
        ),
      ));
    });
  }

  void tapped(int index) {
    if (index == 0) {
      addToGrid();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vocabify"),
      ),
      body: Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const VaultView(vaultTitle: "All Words")));
              },
              child: Container(
                width: 500,
                height: 150,
                decoration: const BoxDecoration(color: Colors.pink),
                child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "ALL WORDS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                          fontSize: 30),
                    )),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: gridChild.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => tapped(index),
                child: gridChild[index],
              ),
            ),
          )
        ],
      )),
    );
  }
}
