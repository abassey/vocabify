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
      Positioned.fill(
        child: GestureDetector(
          onTap: () {
            print("add vault tapped");
            //addToGrid();
          },
          child: const Icon(
            Icons.add_box,
            size: 100,
            color: Colors.white,
          ),
        ),
      ),
    ],
  ),
  Container(
    margin: const EdgeInsets.all(10.0),
    width: 30.0,
    height: 50.0,
    color: Colors.yellow,
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void addToGrid() {
    setState(() {
      gridChild.add(Container(
        margin: const EdgeInsets.all(8.0),
        width: 30.0,
        height: 50.0,
        color: Colors.purple,
      ));
    });
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
          child: GridView.count(
            crossAxisCount: 2,
            children:
                List.generate(gridChild.length, (index) => gridChild[index]),
          ),
        )
      ],
    ));
  }
}
