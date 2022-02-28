import 'package:flutter/material.dart';
import 'vault-view.dart';
import 'friend-account.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;

  final screens = [
    //screen objects placed here
    const HomeScreen(),
    const Text('page_2 - GAME', style: TextStyle(fontSize: 30)),
    const Text('page_3 - ADD WORD', style: TextStyle(fontSize: 30)),
    const Page1(),
    const Text('page_5 - ACCOUNT', style: TextStyle(fontSize: 30)),
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
        appBar: AppBar(
          title: const Text("Vocabify"),
        ),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => const VaultView(vaultTitle: "Vault View")));
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
    } else {
      print("other vault to be accessed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const VaultView(vaultTitle: "Core Vault View")));
            },
            child: const SizedBox(
              width: 500,
              height: 150,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.pink),
              ),
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
    ));
  }
}

//This can be deleted when tess adds her friend list, its just to show the functionality of account page for now
class Page1 extends StatelessWidget {
  const Page1({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator
          .push(
            context,
            MaterialPageRoute(builder: (context) => const FriendsAccount(name: 'Brayden', wordsLearned: 200))
          );
      },
      child: const Text('friend-account')
    );
  }
}
