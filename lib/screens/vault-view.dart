import 'package:flutter/material.dart';
import 'word-view.dart';
import 'package:provider/provider.dart';
import '../providers/vault_provider.dart';
import '../data/vault.dart';
import '../data/dictapi.dart';

enum WordTypes { noun, adj }

List _vaultItems = [
  {
    "word": "some word",
    "pronounce": "This is some part",
    "word_type": "Noun",
    "word_desc":
        "This is some word that is pretty cool! You can read some info about the word and learn something new.",
    "word_syns": ["Pepsi", "Coke", "Ice Cream", "Mario"]
  },
  {
    "word": "some word",
    "pronounce": "This is some part",
    "word_type": "Noun",
    "word_desc":
        "This is some word that is pretty cool! You can read some info about the word and learn something new.",
    "word_syns": ["Pepsi", "Coke", "Ice Cream", "Mario"]
  },
  {
    "word": "some word",
    "pronounce": "This is some part",
    "word_type": "Noun",
    "word_desc":
        "This is some word that is pretty cool! You can read some info about the word and learn something new.",
    "word_syns": ["Pepsi", "Coke", "Ice Cream", "Mario"]
  },
];

class VaultView extends StatefulWidget {
  VaultView({Key? key, required this.vaultTitle, required this.vaultItems}) : super(key: key);
  final String vaultTitle;
  List<dynamic> vaultItems;
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
        Provider.of<VaultProvider>(context).vaultItems[index]["word"]
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WordView(word: Provider.of<VaultProvider>(context).vaultItems[index]["word"])));
      },
    );
  }

  //TextEditing Controller fucntions
  @override
  void initState(){
    super.initState();
    Provider.of<VaultProvider>(context).initVaultItems(widget.vaultItems);
    controller = TextEditingController();
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vault_provider = Provider.of<VaultProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final word = await openDialog();
          if (word == null || word.isEmpty) return;
          vault_provider.addToVault(DictItem(word: word, definitions: ["test", "another def", "done"], synonyms: ["Pepsi", "coke"]));
        },
      ),
      appBar: AppBar(
        title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _isEditMode
                  ? const TextBoxSearch()
                  : Text(widget.vaultTitle, textAlign: TextAlign.start),
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
              itemBuilder: (context) => const [
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text("Edit"),
                      ),
                      value: 1,
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.share),
                        title: Text("Share"),
                      ),
                      value: 2,
                    )
                  ]),
        ],
      ),
      body: ListView.builder(
        itemCount: vault_provider.vaultItems.length + (vault_provider.vaultItems.length - 1 < 0 ? 0 : vault_provider.vaultItems.length - 1),
        itemBuilder: (context, i) {
          var index = (i ~/ 2);
          if (i.isOdd || index >= vault_provider.vaultItems.length) {
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
      ]
    ),
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
