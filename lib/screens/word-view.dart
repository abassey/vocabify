import 'package:flutter/material.dart';
import 'package:vocabify/data/dictapi.dart';
import 'package:provider/provider.dart';
import 'package:vocabify/data/httpget.dart';
import '../providers/app_provider.dart';
import '../extensions/string_extensions.dart';

class WordView extends StatelessWidget {
  const WordView(
      {Key? key, required this.word, required this.isPeek, this.vaultIndex})
      : super(key: key);
  final DictItem word;
  final bool isPeek;
  final int? vaultIndex;

  @override
  Widget build(BuildContext context) {
    //this needs to be added at the top of the page, but not under appbar or floating action button
    final appProvider = Provider.of<AppProvider>(context);

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
                        const PopupMenuItem(
                          child: ListTile(
                            leading: Icon(Icons.add_circle_outline),
                            title: Text("Add To Vault"),
                          ),
                          value: 1,
                        ),
                        PopupMenuItem(
                          child: const ListTile(
                            leading: Icon(Icons.remove_circle_outline),
                            title: Text("Delete Word"),
                          ),
                          enabled: isPeek,
                          value: 2,
                          onTap: () => {
                            appProvider.removeVaultItem(vaultIndex!, word.word),
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
                                Text(word.word.toTitleCase(),
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
                                    index < word.definitions.length;
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
                                              "${index + 1}. ${word.definitions[index].toCapitalized()}",
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
                                word.synonyms.isEmpty
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
                                    for (var syn in word.synonyms)
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
