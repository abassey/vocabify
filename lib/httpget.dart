import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vocabify/dictapi.dart';


class HttpGet {
  HttpGet({
    required this.word,
  });

  late String word;
  List<dynamic> dictapi = [];
  late DictAPI dictItem;


  Future<List<dynamic>?> getDictJson() async {
    var client = http.Client();
    var uri = Uri.parse("https://api.dictionaryapi.dev/api/v2/entries/en/" + word);
    var response = await client.get(uri);
    if(response.statusCode == 200){ // Response was a success
      var json = jsonDecode(response.body);
      return json;
    }
  }

  Future<DictAPI> loadDictItem() async{
    dictapi = (await getDictJson())!;
    dictItem = DictAPI(word: dictapi[0]["word"], meanings: dictapi[0]["meanings"], phonetics: dictapi[0]["phonetics"]);
    return dictItem;
  }

}