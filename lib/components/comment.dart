import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String comment;
  final String user;
  final String time;
  const Comment(
      {super.key,
      required this.comment,
      required this.time,
      required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          //comment
          Text(comment),

          Row(
            children: [
              //user
              Text(user),

              //time
            ],
          )
        ],
      ),
    );
  }
}
