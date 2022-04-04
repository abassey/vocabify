import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/app_navigation.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import './screens/authentication.dart';

void main() {
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vocabify',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<AppProvider>(builder: (context, appState, _) => appState.loginState != ApplicationLoginState.loggedIn ? 
        Scaffold(
          appBar: AppBar(title: const Text("Vocabify")),
          body: Center(
          child: Authentication(
            email: appState.email,
            loginState: appState.loginState,
            startLoginFlow: appState.startLoginFlow,
            verifyEmail: appState.verifyEmail,
            signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
            cancelRegistration: appState.cancelRegistration,
            registerAccount: appState.registerAccount,
            signOut: appState.signOut),
        ))
        : const AppNavigation()
      ),
    ));
  }
}