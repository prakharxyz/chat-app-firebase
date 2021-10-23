import 'package:chat_firebase/Widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  final _messageController = TextEditingController();

  Future<void> sendMessage(BuildContext context) async {
    if (_messageController.text.isNotEmpty) {
      final currentUserid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('messages').add({
        'text': _messageController.text,
        'time': DateTime.now().toString(),
        'uid': currentUserid
      });

      FocusScope.of(context).unfocus();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('messages')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (ctx, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    return SizedBox(
                      height: 556,
                      child: ListView.builder(
                        reverse: true,
                        itemBuilder: (c, i) => messageBubble(
                            snapshot.data!.docs[i]['text'],
                            snapshot.data!.docs[i]['uid'])
                        // Text(),
                        ,
                        itemCount: snapshot.data!.docs.length,
                      ),
                    );
                  }),
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all(width: 2)),
            height: 50,
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: 'message'),
                  ),
                )),
                IconButton(
                    onPressed: () => sendMessage(context),
                    icon: Icon(Icons.send))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
