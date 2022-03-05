import 'package:flutter/material.dart';

class AccountView extends StatelessWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account View"),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: InkWell(
                onTap: () {},
                child: const Icon(Icons.settings),
              )),
        ],
      ),
      body: Center(
          child: Column(
        children: const [
          Text("this is the account page"),
        ],
      )),
    );
  }
}
