import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/app_navigation.dart';
import '../providers/app_provider.dart';
import './screens/authentication.dart';
import '../providers/vault_provider.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppProvider(),
        ),
        ChangeNotifierProvider(create: (context) => VaultProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vocabify',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<AppProvider>(builder: (context, appState, _) => appState.loginState != ApplicationLoginState.loggedIn ? 
        Scaffold(
          appBar: AppBar(title: const Text("Vocabify", style: TextStyle(fontSize: 25))),
          body: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Login or create an account to save and learn your favorite words',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Authentication(
                email: appState.email,
                loginState: appState.loginState,
                startLoginFlow: appState.startLoginFlow,
                verifyEmail: appState.verifyEmail,
                signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
                cancelRegistration: appState.cancelRegistration,
                registerAccount: appState.registerAccount,
                signOut: appState.signOut
              ),
            ],
          ),
        ))
        : const AppNavigation()
      ),
    ));
  }
}