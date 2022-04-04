import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vocabify/data/dictapi.dart';


class HttpGet {
  HttpGet({
    required this.word,
  });

  late String word;
  List<dynamic> dictapi = [];
  late DictItem dictItem;

  /*
  * This returns the json acquired from the dictionary
  * query
   */
  Future<List<dynamic>?> getDictJson() async {
    var client = http.Client();
    // word will always be searched in english
    // to change this, create a variable for en in the link
    // and auto set this to en
    var uri = Uri.parse("https://api.dictionaryapi.dev/api/v2/entries/en/" + word);
    var response = await client.get(uri);
    if(response.statusCode == 200){ // Response was a success
      var json = jsonDecode(response.body);
      return json;
    }
  }
  /*
  * Returns a dictionary api item
   */
  Future<DictItem> loadDictItem() async{
    dictapi = (await getDictJson())!; // Retrieve dictionary json
    // Retrieve dictionary api item
    dictItem = DictAPI(word: dictapi[0]["word"], meanings: dictapi[0]["meanings"], phonetics: dictapi[0]["phonetics"]).getDictItem();
    return dictItem;
  }

}