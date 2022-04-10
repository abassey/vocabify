import 'package:flutter/material.dart';

class UserVault extends StatelessWidget {
  const UserVault({ Key? key, required this.name }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 30.0,
        height: 50.0,
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 20, 74, 118),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Center(
            child: Text(name,
                style: const TextStyle(
                    fontSize: 25, color: Colors.white))),
      ),
    );
  }
}