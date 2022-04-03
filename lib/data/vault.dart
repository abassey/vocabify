

import 'dictapi.dart';

class Vault {

  Vault({
    required this.name,
    required this.vaultitems,
  });

  late String name;
  late List<DictItem> vaultitems;

  //Add a dictionary item to the vault
  void addDictItem(DictItem item) {
    vaultitems.add(item);
  }

  //Remove a dictionary item using its index
  void removeDictItem(int index) {
    vaultitems.removeAt(index);
  }

}

