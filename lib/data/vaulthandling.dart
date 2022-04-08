import 'package:vocabify/data/vault.dart';

import 'package:vocabify/data/dictapi.dart';


class VaultHandlerAPI {

  VaultHandlerAPI({
    required this.vault,
  });

  late Vault vault;

  //Handle the addition of a word to the vault in the database
  void addWordtoVault(DictItem word, int vaultIndex){
    if(this.vault != null){
      vault.addDictItem(word);
      // Add the word to the vault database
    }else{
      // Error Handling
    }
  }

  //Handle the removal of a word to the vault in the database
  void removeWordFromVault(int index){
    if(this.vault != null){
      vault.removeDictItem(index);
      // Remove word from the vault database
    }else{
      // Error Handling
    }
  }

  //Handle the deletion of a vault
  void deleteVault(){
    if(this.vault != null){
      // Delete Object from database
      this.vault == null;
    }else{
      // Error Handling
    }
  }

  //Handle the creation of a vault
  void createVault(String vaultname){
    if(this.vault == null){
      this.vault.name = vaultname;
      // Add new empty vault to the database
    } else {
      // Error Handling
    }
  }
}