import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../data/vault.dart';
import '../data/dictapi.dart';

class VaultProvider extends ChangeNotifier {

  List<dynamic> _vaultItems = [];

  List<dynamic> get vaultItems => _vaultItems;

  void initVaultItems(List<dynamic> items) {
   _vaultItems = items;
   notifyListeners();
  }

  void addToVault(DictItem obj) {
    _vaultItems.add(obj);
    notifyListeners();
  }

}