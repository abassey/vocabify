import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

DictAPI dictAPIFromJson(String str) =>
    DictAPI.fromJson(json.decode(str).map((x) => DictAPI.fromJson(x)));
String dictAPItoJson(List<DictAPI> data) =>
    json.encode(List<DictAPI>.from(data.map((x) => json.encode(x))));

class DictAPI {
  DictAPI({
    required this.word,
    /*
    * Phoenetics is broken up into:
    * text, audio, sourceUrl, license,
    * */
    required this.phonetics,
    /*
    * Meanings is broken up into:
    * partOfSpeech and definitions
    * */
    required this.meanings,
  });

  late String word;
  late List<dynamic> phonetics;
  late List<dynamic> meanings;

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
  getDictItem() {
    List<String> definitions = [];
    List<String> synonymslist = [];
    for (var element in meanings) {
      element["definitions"].forEach((item) {
        item["synonyms"].forEach((thing) {
          synonymslist.add(thing);
        });

        definitions.add(item["definition"]);
      });
    }
    return DictItem(
        word: word, definitions: definitions, synonyms: synonymslist);
  }
}

class DictItem {
  DictItem({
    required this.word,
    required this.definitions,
    required this.synonyms,
  });
  late String word;
  late List<String> definitions;
  late List<String> synonyms;
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
