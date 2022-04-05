import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocabify/data/dictapi.dart';


class Vault {

  Vault({
    required this.name,
    required this.vaultitems,
    required this.fbusers,
  });

  late String name;
  late List<dynamic> vaultitems;
  
  late List<User> fbusers;

  //Add a user to the vault
  void addUser(user){
    fbusers.add(user);
  }

  //Remove user from the vault
  void removeUser(user){
    fbusers.remove(user);
  }
  
  //Add a dictionary item to the vault
  void addDictItem(DictItem item) {
    vaultitems.add(item);
  }

  //Remove a dictionary item using its index
  void removeDictItem(int index) {
    vaultitems.removeAt(index);
  }

  int findIndex(DictItem word){
    return vaultitems.indexOf(word);
  }

  DictItem? findWord(String word){
    word = word.toLowerCase();
    DictItem ret = DictItem(word: "", phonetics: [], meanings: []);
    vaultitems.forEach((element) {
      if (element.word == word) {
        ret = element;
      }
    });

    if(ret.word != "") {
      return ret;
    } else {
      return null;
    }
  }

}

