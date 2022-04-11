import 'package:flutter/material.dart';
import 'package:vocabify/data/dictapi.dart';
import 'package:vocabify/data/httpget.dart';
import 'package:vocabify/screens/word-view.dart';
import 'vault-view.dart';
import 'package:vocabify/data/vault.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController vaultController;
  late TextEditingController peekController;

  //TextEditing Controller fucntions
  @override
  void initState() {
    super.initState();
    vaultController = TextEditingController();
    peekController = TextEditingController();
  }

  @override
  void dispose() {
    vaultController.dispose();
    peekController.dispose();
    super.dispose();
  }

  Future<String?> openDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text('Vault Name'),
            content: TextField(
              controller: vaultController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Enter vault name'),
            ),
            actions: [
              TextButton(
                child: const Text('ADD'),
                onPressed: () {
                  Navigator.of(context).pop(vaultController.text);
                  vaultController.clear();
                },
              )
            ]),
      );

  void tapped(int index, BuildContext context) async {
    if (index == 0) {
      final vaultName = await openDialog();
      if (vaultName == null || vaultName.isEmpty) return;
      setState(() {
        Provider.of<AppProvider>(context, listen: false).addVaultToFireStore(
            Vault(uid: '', name: vaultName, vaultitems: [], fbusers: []),
            context);
      });
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VaultView(
                  vault: Provider.of<AppProvider>(context).vaults[index - 1],
                  vaultIndex: index - 1)));
    }
  }

  Future<String?> peekDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text('Peek at Word'),
            content: TextField(
              controller: peekController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Enter your word'),
            ),
            actions: [
              TextButton(
                child: const Text('PEEK'),
                onPressed: () {
                  peek(context);
                },
              )
            ]),
      );

  void peek(BuildContext context) async {
    final toPeek = peekController.text;

    if (toPeek.isEmpty) return;
    DictItem peekWord = await HttpGet(word: toPeek).loadDictItem();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WordView(
                  word: peekWord,
                  isPeek: false,
                ))).then((result) {
      Navigator.of(context).pop();
    });
    peekController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
        appBar: AppBar(
            title: const Text(
              "Vocabify",
              style: TextStyle(fontSize: 23),
            ),
            actions: [
              IconButton(
                  onPressed: () => peekDialog(),
                  icon: const Icon(Icons.remove_red_eye_outlined))
            ]),
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
                          builder: (context) => VaultView(
                              vault:
                                  Provider.of<AppProvider>(context).coreVault,
                              vaultIndex:
                                  -1))); //add provider of to this line ot save the words in this vault
                },
                child: Container(
                  width: 500,
                  height: 150,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 28, 89, 121),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
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
                itemCount: Provider.of<AppProvider>(context).vaultItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => tapped(index, context),
                  child: Provider.of<AppProvider>(context).vaultItems[index],
                ),
              ),
            )
          ],
        )));
  }
}
