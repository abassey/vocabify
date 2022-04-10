import 'package:flutter/material.dart';
import 'package:vocabify/data/dictapi.dart';
import 'package:provider/provider.dart';
import 'package:vocabify/data/httpget.dart';
import 'package:vocabify/data/vault.dart';
import '../providers/app_provider.dart';
import '../extensions/string_extensions.dart';

class WordView extends StatefulWidget {
  const WordView(
      {Key? key, required this.word, required this.isPeek, this.vaultIndex})
      : super(key: key);
  final DictItem word;
  final bool isPeek;
  final int? vaultIndex;

  @override
  State<WordView> createState() => _WordViewState();
}

class _WordViewState extends State<WordView> {
  @override
  Widget build(BuildContext context) {
    //this needs to be added at the top of the page, but not under appbar or floating action button
    final appProvider = Provider.of<AppProvider>(context);
    var allVaults = appProvider.vaults;
    List<String> vaultList = [];
    List<String> selectedVaults = [];
    bool isChecked = false;

    vaultList.add("All Words");

    for (Vault v in allVaults) {
      vaultList.add(v.name);
    }

    Widget buildItem(String item, int index) {
      return CheckboxListTile(
        title: Text(item),
        controlAffinity: ListTileControlAffinity.trailing,
        value: selectedVaults.contains(vaultList[index]),
        onChanged: (bool? value) {
          setState(() {
            if (value == true) {
              selectedVaults.add(vaultList[index]);
            } else {
              selectedVaults.remove(vaultList[index]);
            }
          });
          print(selectedVaults);
        },
      );
    }

    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back)),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0,
            actions: [
              PopupMenuButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.black),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const ListTile(
                            leading: Icon(Icons.add_circle_outline),
                            title: Text("Add To Vault"),
                          ),
                          value: 1,
                          onTap: () => {
                            Future.delayed(
                                const Duration(seconds: 0),
                                () => showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Select Vaults'),
                                        content: SingleChildScrollView(
                                          child: ListTileTheme(
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    14.0, 0.0, 24.0, 0.0),
                                            child: ListBody(
                                              children: [
                                                for (var i = 0;
                                                    i < vaultList.length;
                                                    i++)
                                                  buildItem(vaultList[i], i)
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text('ADD'),
                                            onPressed: () {
                                              for (var i = 0;
                                                  i < selectedVaults.length;
                                                  i++) {
                                                if (selectedVaults[i] !=
                                                    "All Words") {
                                                  int vaultIndex = allVaults
                                                      .indexWhere((element) =>
                                                          element.name ==
                                                          selectedVaults[i]);
                                                  appProvider.addVaultItem(
                                                      vaultIndex, widget.word);
                                                } else {
                                                  appProvider.addCoreVaultItem(
                                                      widget.word);
                                                }
                                              }
                                              Navigator.pop(
                                                  context, selectedVaults);
                                            },
                                          ),
                                        ],
                                      ),
                                    )),
                          },
                        ),
                        PopupMenuItem(
                          child: const ListTile(
                            leading: Icon(Icons.remove_circle_outline),
                            title: Text("Delete Word"),
                          ),
                          enabled: widget.isPeek,
                          value: 2,
                          onTap: () => {
                            appProvider.removeVaultItem(
                                widget.vaultIndex!, widget.word.word),
                            Navigator.pop(context),
                          },
                        )
                      ])
            ]),
        body: SingleChildScrollView(
            child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                    padding: EdgeInsets.fromLTRB(20, 40, 0, 0)),
                                Text(widget.word.word.toTitleCase(),
                                    style: const TextStyle(
                                        fontSize: 30,
                                        //fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w700)),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      ),
                                      // Icon(Icons.audio_file),
                                    ]),
                              ])),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Meanings:",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w500)),
                                const Padding(padding: EdgeInsets.all(4)),
                                for (var index = 0;
                                    index < widget.word.definitions.length;
                                    index++)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Text("${index + 1}.",
                                          //     style: const TextStyle(
                                          //         color: Colors.black,
                                          //         fontWeight: FontWeight.bold)),
                                          const Padding(
                                              padding: EdgeInsets.all(4.0)),
                                          Text(
                                              "${index + 1}. ${widget.word.definitions[index].toCapitalized()}",
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.visible,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400)),
                                        ]),
                                  )
                              ])),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.word.synonyms.isEmpty
                                    ? const Text(" ")
                                    : const Text("Synonyms:",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w500)),
                                const Padding(padding: EdgeInsets.all(4)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    for (var syn in widget.word.synonyms)
                                      Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: GestureDetector(
                                            onTap: () async {
                                              DictItem toPush =
                                                  await HttpGet(word: syn)
                                                      .loadDictItem();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          WordView(
                                                            word: toPush,
                                                            isPeek: false,
                                                          )));
                                            },
                                            child: Card(
                                                color: Colors.grey,
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Text(syn))),
                                          ))
                                  ],
                                ),
                                const Padding(padding: EdgeInsets.all(8.0))
                              ])),
                    ]))));
  }
}
