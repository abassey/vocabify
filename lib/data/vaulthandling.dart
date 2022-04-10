import 'package:vocabify/data/vault.dart';

import 'package:vocabify/data/dictapi.dart';

class VaultHandlerAPI {
  VaultHandlerAPI({
    required this.vault,
  });

  late Vault vault;

  //Handle the addition of a word to the vault in the database
  void addWordtoVault(DictItem word, int vaultIndex) {
    vault.addDictItem(word);
    // Add the word to the vault database
  }

  //Handle the removal of a word to the vault in the database
  void removeWordFromVault(Vault vault, String toRemove) {
    vault.vaultitems.removeWhere((element) => element.word == toRemove);
    // Remove word from the vault database
  }

  //Handle the deletion of a vault
  void deleteVault() {
    // Delete Object from database
    this.vault == null;
  }

  //Handle the creation of a vault
  void createVault(String vaultname) {
    this.vault.name = vaultname;
    // Add new empty vault to the database
  }
}
