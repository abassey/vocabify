import 'package:flutter/material.dart';

class WordView extends StatelessWidget {
  WordView({ Key? key}) : super(key: key);
  final List<String> syns = ["Pepsi", "Coke", "Another Word"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () => Navigator.pop(context),
      child: const Icon(Icons.arrow_back)),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: Align(
      alignment: Alignment.topLeft,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(padding: const EdgeInsets.fromLTRB(20, 0, 0, 20), child: 
          Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(padding: EdgeInsets.fromLTRB(20, 80, 0, 0)),
            const Text("Some Word", style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: const [ Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0), child: Text("/wərd/")), Icon(Icons.audio_file)]),
          ])),

        Padding(padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Text("Description: ", style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)),
          Padding(padding: EdgeInsets.all(4)),
          Text("This is a descrition that will go here. This description will define the word...", textAlign: TextAlign.start, overflow: TextOverflow.visible, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          ])),

        Padding(padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Synonyms: ", style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500)),
          const Padding(padding: EdgeInsets.all(4)),
          Row(children: [for (var syn in syns) Padding(padding: const EdgeInsets.all(4), child: Card(color: Colors.lightBlue, child: Padding(padding: const EdgeInsets.all(4), child:Text(syn))))]),
          ])),
        ])
    ));

  }
}