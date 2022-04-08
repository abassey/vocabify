import 'package:flutter/material.dart';
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
  late TextEditingController controller;

  //TextEditing Controller fucntions
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
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
            ]),
      );

  void tapped(int index, BuildContext context) async {
    if (index == 0) {
      final vaultName = await openDialog();
      if (vaultName == null || vaultName.isEmpty) return;
      setState(() {
        Provider.of<AppProvider>(context, listen: false).addVaultToFireStore(
            Vault(name: vaultName, vaultitems: [], fbusers: []), context);
      });
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VaultView(
                  vault: Provider.of<AppProvider>(context, listen: false)
                      .vaults[index - 1])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Vocabify",
            style: TextStyle(fontSize: 23),
          ),
        ),
        body: Center(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  Vault coreVault =
                      Vault(name: "All Words", vaultitems: [], fbusers: []);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VaultView(
                              vault:
                                  coreVault))); //add provider of to this line ot save the words in this vault
                },
                child: Container(
                  width: 500,
                  height: 150,
                  decoration: const BoxDecoration(
                      color: Colors.teal,
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
