import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:vocabify/data/dictapi.dart';
import 'package:vocabify/firebase_options.dart';
import '../screens/authentication.dart';
import '../data/vault.dart';
import '../screens/vault-view.dart';

class AppProvider extends ChangeNotifier {

  ApplicationLoginState _loginState = ApplicationLoginState.emailAddress;
  ApplicationLoginState get loginState => _loginState;
  String? _email;
  String? get email => _email;
  String? _displayName;
  String? get name => _displayName;

  StreamSubscription<QuerySnapshot>? _vaultItemSubscription;
  List<Widget> _vaultItems = [
    Stack(
      children: [
        Positioned.fill(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            width: 30.0,
            height: 50.0,
            decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
        ),
        const Positioned.fill(
          child: Icon(
            Icons.add_box,
            size: 100,
            color: Colors.white,
          ),
        ),
      ],
    )
  ];
  List<Widget> get vaultItems => _vaultItems;
  List<Vault> _vaults = [];
  List<Vault> get vaults => _vaults;
  User? currentUser;
  List<String> currentFriends = [];

  //constructor
  AppProvider() {
    init();
    getFriendsList();
  }

  void initVaultItems() {
    _vaultItems = [];
    _vaultItems.add(Stack(
      children: [
        Positioned.fill(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            width: 30.0,
            height: 50.0,
            decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
        ),
        const Positioned.fill(
          child: Icon(
            Icons.add_box,
            size: 100,
            color: Colors.white,
          ),
        ),
      ],
    ));
  }

  Future<void> init() async {

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        currentUser = user;
        _loginState = ApplicationLoginState.loggedIn;
        _displayName = currentUser?.displayName;
        _vaultItemSubscription = FirebaseFirestore.instance
            .collection('vaults')
            .where('uid', isEqualTo: user.uid)
            .snapshots()
            .listen((snapshot) {
          _vaults = [];
          initVaultItems();
          for (final document in snapshot.docs) {
            _vaults.add(Vault(
                name: document['name'] as String, vaultitems: [], fbusers: []));
            _vaultItems.add(
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 30.0,
                  height: 50.0,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 20, 74, 118),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Center(
                      child: Text(document['name'] as String,
                          style: const TextStyle(
                              fontSize: 25, color: Colors.white))),
                ),
              ),
            );
          }
          notifyListeners();
        });
        notifyListeners();
      } else {
        _loginState = ApplicationLoginState.emailAddress;
        _vaults = [];
        _vaultItems = [];
        _vaultItemSubscription?.cancel();

        notifyListeners();
      }
      notifyListeners();
    });
    notifyListeners();
  }

  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  void addGridChild(String vaultName, BuildContext context) {
    _vaults.add(Vault(name: vaultName, vaultitems: [], fbusers: []));
    _vaultItems.add(Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Vault vault = Vault(name: vaultName, vaultitems: [], fbusers: []);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => VaultView(vault: vault)));
        },
        child: Container(
          width: 30.0,
          height: 50.0,
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 20, 74, 118),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Center(
              child: Text(vaultName,
                  style: const TextStyle(fontSize: 25, color: Colors.white))),
        ),
      ),
    ));
    notifyListeners();
  }

  Future<void> verifyEmail(String email,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        _loginState = ApplicationLoginState.password;
      } else {
        _loginState = ApplicationLoginState.register;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      getFriendsList();
      _displayName = currentUser?.displayName;
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancelRegistration() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  Future<void> registerAccount(
      String email,
      String displayName,
      String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
      await currentUser?.reload();
      addUserToFireStore();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    _loginState = ApplicationLoginState.emailAddress;
    currentUser = null;
    currentFriends = [];
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  // Interacting with the FireStore vaults
  Future<DocumentReference> addVaultToFireStore(Vault item, BuildContext context) {
    addGridChild(item.name, context);
    return FirebaseFirestore.instance
        .collection('vaults')
        .add(<String, dynamic>{
      'name': item.name,
      'uid': currentUser!.uid,
      'items': []
    });
  }

  // FUNCTIONS FOR ADDING FRIENDS -------------------------------------------

  //Creating user collection if this fails change back to DocumentReference
  Future<void> addUserToFireStore() {
    return FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser!.uid)
      .set(<String, dynamic>{
        'name': currentUser!.displayName,
        'email':currentUser!.email,
        'uid': currentUser!.uid,
        'friends': [],
      });
  }

  //get a user from thr user collection
  Future<void> updateFriendList(String friendEmail){
    return FirebaseFirestore.instance
    .collection('users')
    .get()
    .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (friendEmail == doc["email"] && friendEmail != currentUser!.email){
          listUpdater(doc["name"]);
        }
      }
    });
  }

  //update user collection with new friends
  Future<void> listUpdater (String friend) async{
    List<String> friendList = [friend];
    await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser!.uid)
      .update({'friends': FieldValue.arrayUnion(friendList)});
    currentFriends.add(friend);
    notifyListeners();
  }

  //get the users friends
  //NOTE THESE PROB DONT HAVE TO BE AWAIT
  Future<void> getFriendsList () async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if(currentUser == null) return;

    await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser!.uid)
      .get()
      .then((DocumentSnapshot doc){
        if(doc.exists) {
          currentFriends = [];
          for(var i in doc['friends']){
            currentFriends.add(i as String);
          }
        }
      });
    notifyListeners();
  }
}
