import 'package:flutter/material.dart';

class SharedVault extends StatelessWidget {
  const SharedVault({ Key? key, required this.name }) : super(key: key);

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
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.people_alt, color: Colors.white),
              ),
            ),
            const SizedBox(height: 35),
            Text(name,style: const TextStyle(fontSize: 25, color: Colors.white))
          ],
        ),
      ),
    );
  }
}