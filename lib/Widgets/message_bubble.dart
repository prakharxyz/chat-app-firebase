import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class messageBubble extends StatelessWidget {
  //create constructor to accept text & user id
  String text;
  String uid;
  messageBubble(this.text, this.uid);

  @override
  Widget build(BuildContext context) {
    return Column(
      //to accomodate username & message
      crossAxisAlignment: FirebaseAuth.instance.currentUser!.uid == uid
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      //if current user's uid matches uid on message display message on right side otherwise on left side
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding:
              const EdgeInsets.only(top: 2, bottom: 8, left: 12, right: 12),
          constraints: const BoxConstraints(
              maxWidth: 200), //if it exceeds 200 width it goes to nextLine
          decoration: BoxDecoration(
              color: FirebaseAuth.instance.currentUser!.uid == uid
                  ? Colors.limeAccent[700]
                  : Colors.limeAccent,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(
                      FirebaseAuth.instance.currentUser!.uid == uid ? 0 : 8),
                  topLeft: Radius.circular(
                      FirebaseAuth.instance.currentUser!.uid == uid ? 8 : 0))),
          child: Column(
            children: [
              StreamBuilder<DocumentSnapshot>(
                  //to listen user Data for getting username from 'users' collection
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(
                          uid) //since each uid is unique so documentId of each user is their uid
                      .snapshots(),
                  builder: (context, snapshot) {
                    try {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); //show spinner
                      }
                      return Text(
                        snapshot.data!['username']
                            .toString()
                            .toUpperCase(), //show 'username' from data recieved from DocumentSnapshot
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      );
                    } catch (e) {
                      //prevents app from crashing if error occurs & displays - in place of username
                      print('Some error occured ${e.toString()}');
                      return const Text('-',
                          style: TextStyle(
                            fontSize: 12,
                          ));
                    }
                  }),
              Text(text) //message text
            ],
          ),
        ),
      ],
    );
  }
}
