import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thecodechat/components/comment_button.dart';
import 'package:thecodechat/components/like_button.dart';

class ChatPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;
  // final String time;
  const ChatPost({
    super.key,
    required this.message,
    required this.user,
    required this.likes,
    required this.postId,
  });

  @override
  State<ChatPost> createState() => _ChatPostState();
}

class _ChatPostState extends State<ChatPost> {
  //get the user from firebase
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  final _commentTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    //Access the document in firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);
    if (isLiked) {
      //if the post is liked, add the user's email to the 'Likes' field
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email]),
      });
    } else {
      //if the user disliked the post, remove the email from the 'Likes' list
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email]),
      });
    }
  }

  // add a comment
  void addComment(String commentText) {
    //write a comment to firestore under the comments collection for this post
    FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postId)
        .collection('Comments')
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser!.email,
      "CommentTime": Timestamp.now(), //remember to format this when displaying
    });
  }

  // show a dialog box for adding a comment
  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: InputDecoration(
            hintText: "Write A Comment",
          ),
        ),
        actions: [
          //post button
          TextButton(
            onPressed: () => addComment(
              _commentTextController.text,
            ),
            child: const Text("Post"),
          ),

          //cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(widget.message),
            ],
          ),

          const SizedBox(
            width: 15,
          ),

          //buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //LIKE
              Column(
                children: [
                  //like button
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  //like count
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),

              SizedBox(
                width: 10,
              ),
              //COMMENT
              Column(
                children: [
                  //Comment Button
                  CommentButton(
                    onTap: showCommentDialog,
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  //comment count
                  Text(
                    '0',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
