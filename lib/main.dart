import 'package:flutter/material.dart';
import 'package:vocabify/game-view.dart';
import 'vault-view.dart';
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

  List<Widget> screens = <Widget>[
    //screen objects placed here
    const HomeScreen(),
    const GameView(),
    const FriendsListScreen(),
    const AccountView(name: "My Name", wordsLearned: 32),
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
  late TextEditingController controller;

   //TextEditing Controller fucntions
  @override
  void initState(){
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  Future<String?> openDialog() => showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Vault Name'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Enter vault name'),
      ),
      actions: [
        TextButton(
          child: const Text('ADD'),
          onPressed: () {
            Navigator.of(context).pop(controller.text);
            controller.clear();
          },
        )
      ]
    ),
  );

  //grid functions
  List<Widget> gridChild = [
    Stack(
      children: [
        Positioned.fill(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            width: 30.0,
            height: 50.0,
            decoration: const BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.all(Radius.circular(20))),
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

  void addToGrid(String vaultName) {
    setState(() {
      gridChild.add(Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        VaultView(vaultTitle: vaultName)));
          },
          child: Container(
            width: 30.0,
            height: 50.0,
            decoration: const BoxDecoration(color: Color.fromARGB(255, 20, 74, 118), borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Center(child: Text(vaultName, style: const TextStyle(fontSize: 25, color: Colors.white))),
          ),
        ),
      ));
    });
  }

  void tapped(int index) async {
    if (index == 0) {
      final vaultName = await openDialog();
      if (vaultName == null || vaultName.isEmpty) return;
      addToGrid(vaultName);
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
                decoration: const BoxDecoration(color:Colors.teal, borderRadius: BorderRadius.all(Radius.circular(20))),
                child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "ALL WORDS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
