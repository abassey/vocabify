import 'package:flutter/cupertino.dart';
import 'package:test/test.dart';
import 'package:vocabify/data/dictapi.dart';
import 'package:vocabify/data/httpget.dart';
import '../lib/data/vault.dart';

void main() {

  group('Vault', (){
    // TEST ONE - ADDING DICTIONARY ITEMS TO THE VAULT
    test('Adding three dictionary items to the vault', () async {
      /*
    The set up here is:
     - A Vault
     - Three Dictionary Items

     Here we test if dictionary items are being added accordingly
    */

      Vault vault = Vault(name: "MyWords",vaultitems: [], fbusers: []);
      DictItem testA = await HttpGet(word: "air").loadDictItem() as DictItem;
      vault.addDictItem(testA);

      DictItem testB = await HttpGet(word: "water").loadDictItem() as DictItem;
      vault.addDictItem(testB);

      DictItem testC = await HttpGet(word: "land").loadDictItem() as DictItem;
      vault.addDictItem(testC);

      if(vault.findWord("Air") != null){
        debugPrint(vault.findWord("Air")?.word);
      }

      expect(vault.findWord("Air")?.word.toLowerCase(), "air");
      expect(vault.findWord("Water")?.word.toLowerCase(), "water");
      expect(vault.findWord("Land")?.word.toLowerCase(), "land");

    });

    // TEST TWO - REMOVING DICTIONARY ITEMS FROM THE VAULT
    test('Removing a dictionary item from the vault', () async {
      /*
      The set up here is:
       - A Vault
       - Three Dictionary Items

       Testing if removing an item from the vault works.
      */

      Vault vault = Vault(name: "MyWords",vaultitems: [] , fbusers: []);
      DictItem testA = await HttpGet(word: "air").loadDictItem() as DictItem;
      vault.addDictItem(testA);

      DictItem testB = await HttpGet(word: "water").loadDictItem() as DictItem;
      vault.addDictItem(testB);

      DictItem testC = await HttpGet(word: "land").loadDictItem() as DictItem;
      vault.addDictItem(testC);

      vault.removeDictItem(vault.findIndex(testA));

      expect(vault.findWord("Air")?.word.toLowerCase(), null);
      expect(vault.findWord("Water")?.word.toLowerCase(), "water");
      expect(vault.findWord("Land")?.word.toLowerCase(), "land");

    });

  });


}