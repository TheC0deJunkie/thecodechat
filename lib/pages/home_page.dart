import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thecodechat/components/chats_post.dart';
import 'package:thecodechat/components/drawer.dart';
import 'package:thecodechat/components/text_field.dart';
import 'package:thecodechat/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //get the user
  final currentUser = FirebaseAuth.instance.currentUser;

  final textController = TextEditingController();

  //signout method
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  //post message method
  void postMessage() {
    //only post if there is something in the textfield
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        "UserEmail": currentUser!.email!,
        "Message": textController.text,
        "TimeStamp": Timestamp.now(),
        "Likes": [],
      });
    }

    //clear textfield after posting
    setState(() {
      textController.clear();
    });
  }

  //navigate to profile page
  void goToProfile() {
    //pop the menu drawer
    Navigator.pop(context);

    //go to the profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: MyDrawer(
        onProfile: goToProfile,
        onSignOut: signOut,
      ),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text('The Code Chat'),
      ),
      body: Center(
        child: Column(
          children: [
            //The Chats
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy(
                      "TimeStamp",
                      descending: false,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        //get the message
                        final post = snapshot.data!.docs[index];
                        return ChatPost(
                          message: post["Message"],
                          user: post["UserEmail"],
                          postId: post.id,
                          likes: List<String>.from(post["Likes"] ?? []),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),

            //Post A Message
            Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                children: [
                  //Textfield
                  Expanded(
                    child: MyTextField(
                        controller: textController,
                        hintText: "Type a message",
                        obscureText: false),
                  ),

                  IconButton(
                      onPressed: postMessage,
                      icon: const Icon(Icons.arrow_circle_up_outlined))
                ],
              ),
            ),
            //Logged in As
            Text(
              "Logged in as: " + currentUser!.email!,
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
