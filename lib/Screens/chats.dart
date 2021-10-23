import 'package:chat_firebase/Widgets/messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

//firestore database basically ek notebook h jisme collection ke andar documents h,
// un documents ki khudki unique id h jisme maps ya fir json form me data stored hota h
//documents ke andar sub-collection bhi ho sakta h, just the sam eway jaise folders ke andar files ya subfolders hote h
//collection >> document1 >> sub-collection >> document-data >> {key : value}

class _ChatScreenState extends State<ChatScreen> {
  final firestore = FirebaseFirestore.instance;
  final firestoreRef = FirebaseFirestore.instance.collection('messages');
  final Stream<QuerySnapshot> _firebaseStream =
      FirebaseFirestore.instance.collection('chats').snapshots();

  // final snaphots = FirebaseFirestore.instance.collection('chats').get()
  //     as Map<String, dynamic>;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chats'),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  //we dont need to rebuild here as we already have stream builder in main file to listen to changes in token
                  //and as soon as we log out, token becomes null and we get directed to login page
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body:
            // StreamBuilder<QuerySnapshot>(
            //   stream: _firebaseStream,
            //   builder: (c, ss) {
            //     if (!ss.hasData) {
            //       return const Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     }
            //     return ListView.builder(
            //       itemBuilder: (_, i) {
            //         // ss.data!.docs.forEach((document) => Text(document.toString()));
            //         return Text(ss.data!.docs[i].toString());
            //       },
            //       itemCount: ss.data!.docs.length,
            //     );

            //   },
            // )
            Messages());
  }
}
