import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

class AddFriends extends StatefulWidget {
  const AddFriends({ Key? key }) : super(key: key);

  @override
  State<AddFriends> createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  /*
    - Query for all users
    - Check if email matches email
    - update thier friend list with that user
    - If they have eachother added they can share a vault
   */

  final addFriendController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friends'),
      ),
      body: Column(
        children: [
          const SizedBox(height:10),
          const Text(
            'Add your friends on Vocabify',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height:30),
          const Text('You will need to enter the email address associated with thier account. Keep in mind that emails are not case sensitive.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height:30),
          const Text(
            'ADD VIA EMAIL',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: formKey,
              child: TextFormField(
                controller: addFriendController,
                decoration: const InputDecoration(
                  hintText: 'username@email.com',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter an email address to continue';
                  }
                  return null;
                },
              )
            ),
          ),
          const SizedBox(height:10),
          ElevatedButton(
            child: const Text('Add to Friends List', style: TextStyle(fontSize: 18)),
            onPressed: () async{
              if (formKey.currentState!.validate()) {
                await appProvider.updateFriendList(addFriendController.text.toLowerCase().trim());
                if(appProvider.addFriend){
                  const snackbar = SnackBar(content: Text('Added Friend'));
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                }
              }
              addFriendController.clear();
            },
          ),
          const SizedBox(height: 10),
          if (appProvider.addFriend == false)
            const Text('Could not find user', style: TextStyle(fontSize: 18, color: Colors.red))
        ],
      )
    );
  }
}