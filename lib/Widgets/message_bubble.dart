import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class messageBubble extends StatelessWidget {
  String text;
  String uid;
  messageBubble(this.text, this.uid);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: FirebaseAuth.instance.currentUser!.uid == uid
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding:
              const EdgeInsets.only(top: 2, bottom: 8, left: 12, right: 12),
          constraints: const BoxConstraints(maxWidth: 200),
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
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    try {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      return Text(
                        snapshot.data!['username'].toString().toUpperCase(),
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      );
                    } catch (e) {
                      print('Some error occured ${e.toString()}');
                      return const Text('-',
                          style: TextStyle(
                            fontSize: 12,
                          ));
                    }
                  }),
              Text(text)
            ],
          ),
        ),
      ],
    );
  }
}
