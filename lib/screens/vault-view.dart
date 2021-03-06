import 'package:flutter/material.dart';
import 'package:vocabify/data/dictapi.dart';
import 'package:vocabify/data/httpget.dart';
import 'package:vocabify/data/vault.dart';
import 'word-view.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../data/vault.dart';
import '../data/dictapi.dart';
import '../extensions/string_extensions.dart';

class VaultView extends StatefulWidget {
  const VaultView({Key? key, required this.vault, required this.vaultIndex})
      : super(key: key);
  final Vault vault;
  final int vaultIndex;

  @override
  _VaultViewState createState() => _VaultViewState();
}

class _VaultViewState extends State<VaultView> {
  late TextEditingController controller;
  double iconSize = 20;
  List<dynamic> friendsList = [];

  Widget _buildRow(index) {
    return ListTile(
      title: Text(
        widget.vault.vaultitems[index].word,
        style: const TextStyle(fontSize: 20),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WordView(
                      word: widget.vault.vaultitems[index],
                      vaultIndex: widget.vaultIndex,
                      isPeek: true,
                    )));
      },
    );
  }

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

  int getVaultItemCount() {
    return widget.vault.vaultitems.length +
        (widget.vault.vaultitems.length - 1 < 0
            ? 0
            : widget.vault.vaultitems.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    friendsList = appProvider.currentFriends;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final word = await openDialog();
          if (word == null || word.isEmpty) return;
          DictItem toAdd = await HttpGet(word: word).loadDictItem();
          if (widget.vaultIndex != -1) {
            appProvider.addVaultItem(widget.vaultIndex, toAdd);
          }
          appProvider.addCoreVaultItem(toAdd);
          // appProvider.updateFireStoreCoreVault();
        },
      ),
      appBar: AppBar(
        title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.vault.name,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 25),
              ),
            ],
            mainAxisSize: MainAxisSize.min),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              if (widget.vaultIndex != -1) {
                openShareVault();
              }
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: getVaultItemCount(),
        itemBuilder: (context, i) {
          var index = (i ~/ 2);
          if (i.isOdd || index >= getVaultItemCount()) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.0),
              child: Divider(
                color: Colors.black,
                thickness: 0.5,
              ),
            );
          }

          return _buildRow(index);
        },
      ),
    );
  }

  Future<String?> openDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text('Add Word'),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Enter your word'),
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

  //This is the screen for sharing the vault your in with a friend
  Future openShareVault() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text('Share Vault With:'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < friendsList.length; i++)
                  ElevatedButton(
                    child: Text(friendsList[i]["name"] as String,
                        style: const TextStyle(fontSize: 18)),
                    onPressed: () {
                      Provider.of<AppProvider>(context, listen: false)
                          .addSharedUserToVault(
                              friendsList[i]["name"] as String,
                              friendsList[i]["uid"] as String,
                              widget.vault);
                      Navigator.of(context).pop();
                    },
                  )
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Cancel', style: TextStyle(fontSize: 18)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ]),
      );
}
