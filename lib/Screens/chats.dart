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
  final firestoreRef = FirebaseFirestore.instance
      .collection('chats')
      .doc('NLL3Hm8ilsdub8YMwVid');
  final Stream<QuerySnapshot> _firebaseStream =
      FirebaseFirestore.instance.collection('chats').snapshots();

  // final snaphots = FirebaseFirestore.instance.collection('chats').get()
  //     as Map<String, dynamic>;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // Firebase.initializeApp();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chats'),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => firestore
                .collection('chats')
                .add({'data': 'added through app'})),
        body: StreamBuilder<QuerySnapshot>(
          stream: _firebaseStream,
          builder: (c, ss) {
            if (!ss.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemBuilder: (_, i) {
                // ss.data!.docs.forEach((document) => Text(document.toString()));
                return Text(ss.data!.docs[i].toString());
              },
              itemCount: ss.data!.docs.length,
            );
            // return ListView(
            //   children: ss.data!.docs.map((document) {
            //     return Container(
            //       child: Center(child: Text(document['text1'])),
            //     );
            //   }).toList(),
            // );
          },
        ));
  }
}
