import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thecodechat/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  //edit field
  Future<void> editField(String field) async {
    final usersCollection = FirebaseFirestore.instance.collection('Users');
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit " + field,
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          //cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
          ),

          //save button
          TextButton(
              onPressed: () => Navigator.of(context).pop(newValue),
              child: Text("Save"))
        ],
      ),
    );

    //updating the info in the firestore database
    if (newValue.trim().length > 0) {
      //only update if there is something in the textfield
      await usersCollection.doc(currentUser!.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text("Profile"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser!.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //get user data
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              children: [
                SizedBox(
                  height: 50,
                ),
                //profile pic
                Icon(Icons.person, size: 76),

                SizedBox(
                  height: 10,
                ),

                //email
                Text(
                  currentUser!.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),

                //user details
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text("My Details"),
                ),

                //username
                MyTextBox(
                  text: userData['username'],
                  sectionName: "username",
                  onPressed: () => editField('username'),
                ),

                //bio
                MyTextBox(
                  text: userData['bio'],
                  sectionName: "bio",
                  onPressed: () => editField('bio'),
                ),

                SizedBox(
                  height: 10,
                ),
                //user posts
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text("My Posts"),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error ${snapshot.error}'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
