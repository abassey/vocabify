import 'package:flutter/material.dart';
import 'package:vocabify/data/dictapi.dart';
import 'package:vocabify/data/httpget.dart';
import 'package:vocabify/data/vault.dart';
import 'package:vocabify/data/vaulthandling.dart';
import 'word-view.dart';
import 'package:provider/provider.dart';
import '../providers/vault_provider.dart';
import '../providers/app_provider.dart';
import '../data/vault.dart';
import '../data/dictapi.dart';

class VaultView extends StatefulWidget {
  const VaultView({Key? key, required this.vault, required this.vaultIndex}) : super(key: key);
  final Vault vault;
  final int vaultIndex;

  @override
  _VaultViewState createState() => _VaultViewState();
}

class _VaultViewState extends State<VaultView> {
  late TextEditingController controller;
  bool _isEditMode = false;
  double iconSize = 20;

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
                    word: widget.vault.vaultitems[
                        index]))); //this should change to dicttime to get the list of meanings and phonetics
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

  @override
  Widget build(BuildContext context) {
    final vault_provider = Provider.of<VaultProvider>(context);
    final app_provider = Provider.of<AppProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final word = await openDialog();
          if (word == null || word.isEmpty) return;
          DictItem toAdd = await HttpGet(word: word).loadDictItem();
          setState(() {
           // VaultHandlerAPI(vault: widget.vault).addWordtoVault(toAdd, widget.vaultIndex);
            app_provider.addVaultItems(widget.vaultIndex, toAdd);
          });
        },
      ),
      appBar: AppBar(
        title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _isEditMode
                  ? const TextBoxSearch()
                  : Text(
                      widget.vault.name,
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 25),
                    ),
            ],
            mainAxisSize: MainAxisSize.min),
        centerTitle: false,
        actions: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                  onPressed: () => {
                        setState(() {
                          _isEditMode = !_isEditMode;
                          if (_isEditMode) {
                            iconSize = 15;
                          } else {
                            iconSize = 20;
                          }
                        }),
                      },
                  icon: !_isEditMode
                      ? const Icon(Icons.search)
                      : const Icon(Icons.close))),
          PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                    const PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text("Edit"),
                      ),
                      value: 1,
                    ),
                    PopupMenuItem(
                      child: const ListTile(
                        leading: Icon(Icons.share),
                        title: Text("Share"),
                      ),
                      value: 2,
                      onTap: () {
                        //show a popup dialog with friends listed
                        //Here we show the list of the users friends and pick one,
                        //Save this to the 
                      },
                    )
                  ]),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.vault.vaultitems.length +
            (widget.vault.vaultitems.length - 1 < 0
                ? 0
                : widget.vault.vaultitems.length - 1),
        itemBuilder: (context, i) {
          var index = (i ~/ 2);
          if (i.isOdd || index >= widget.vault.vaultitems.length) {
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
}

class TextBoxSearch extends StatelessWidget {
  const TextBoxSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      alignment: Alignment.centerLeft,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: const TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(fontSize: 15)),
      ),
    );
  }
}
