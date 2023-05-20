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
  Future<void> editField(String field) async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text("Profile"),
      ),
      body: ListView(
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
            text: "khulekani",
            sectionName: "username",
            onPressed: () => editField('username'),
          ),

          //bio
          MyTextBox(
            text: "empty bio",
            sectionName: "bio",
            onPressed: () => editField('bio'),
          ),

          //user posts
        ],
      ),
    );
  }
}
