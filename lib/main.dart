import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.blue,
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
          selectedItemColor: Colors.white,
        ),
        body: const HomeScreen(),
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
            print("new vault to access tapped");
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
              print("core vault tapped -> this goes to core vault page");
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
