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
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //comment
          Text(comment),

          SizedBox(
            height: 5,
          ),

          Row(
            children: [
              //user
              Text(
                user,
                style: TextStyle(color: Colors.grey[400]),
              ),

              //separator
              Text(
                " - ",
                style: TextStyle(color: Colors.grey[400]),
              ),

              //time
              Text(
                time,
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          )
        ],
      ),
    );
  }
}
