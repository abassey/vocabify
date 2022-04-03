import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

DictAPI DictAPIFromJson(String str) => DictAPI.fromJson(json.decode(str).map((x) => DictAPI.fromJson(x)));
String DictAPItoJson(List<DictAPI> data) => json.encode(List<DictAPI>.from(data.map((x) => json.encode(x))));


class DictAPI {

  /*
  * Factory function for turning the retrieved json into a
  * DictAPI object
   */
  factory DictAPI.fromJson(Map<String, dynamic> json) => DictAPI(
    word: json["word"],
    phonetics: json["phonetics"],
    meanings: json["meanings"],
  );

  /*
  * Retrieves the actual DictItem from the current
  * instance of DictAPI
   */
  getDictItem(){
    List<Phonetics> phoneticslist = [];
    List<Definitions> definitionslist = [];
    List<Meanings> meaningslist = [];
    List<String> synonymslist = [];
    List<String> antonymslist = [];
    phonetics.forEach((element) {
      phoneticslist.add(Phonetics(text: element["text"], audio: element["audio"]));
    });
    meanings.forEach((element) {
      definitionslist = [];
      element["definitions"].forEach((item){
        item["synonyms"].forEach((thing){
          synonymslist.add(thing);
        });
        item["antonyms"].forEach((thing){
          antonymslist.add(thing);
        });

        definitionslist.add(Definitions(
            definition: item["definition"],
            synonyms: synonymslist,
            antonyms: antonymslist,
            example: item["example"] ?? "",
        ));
      });
      meaningslist.add(
        Meanings(
          partofspeech: element["partOfSpeech"],
          definitions: definitionslist
        ),
      );
    });
    return DictItem(word: word, phonetics: phoneticslist, meanings: meaningslist);
  }

}

class DictItem {
  DictItem({
    required this.word,
    required this.phonetics,
    required this.meanings,
  });
  late String word;
  late List<Phonetics> phonetics;
  late List<Meanings> meanings;

  @override
  String toString() {
    late String ret = "Word: " + word + "\n";
    ret = ret + "Phonetics:\n";
    phonetics.forEach((element) {
      ret = ret + "   Text: " + element.text + "    \n    Audio: " + element.audio;
      ret = ret + "\n\n";
    });
    meanings.forEach((element) {
      ret = ret + "Meanings:\n";
      ret = ret + "   PartOfSpeech: " + element.partofspeech +"\n";
      ret = ret + "   Definitions: \n";
      element.definitions.forEach((item) {
        ret = ret + "       Definition: " + item.definition + "\n";
        ret = ret + "       Synonyms: " + "\n";
        item.synonyms.forEach((thing) {
          ret = ret + "           Synonym: " + thing + "\n";
        });
        ret = ret + "       Antonyms: " + "\n";
        item.antonyms.forEach((thing) {
          ret = ret + "           Antonym: " + thing + "\n";
        });
        ret = ret + "       Example: " + item.example + "\n\n";
      });
    });
    return ret;
  }
}

class Definitions {
  Definitions({
    required this.definition,
    required this.synonyms,
    required this.antonyms,
    required this.example,
  });
  late String definition;
  late List<String> synonyms;
  late List<String> antonyms;
  late String example;
}

class Phonetics {
  Phonetics({
    required this.text,
    required this.audio,
  });
  late String text;
  late String audio;
}

class Meanings {
  Meanings({
    required this.partofspeech,
    required this.definitions,
  });
  late String partofspeech;
  late List<Definitions> definitions;
}

