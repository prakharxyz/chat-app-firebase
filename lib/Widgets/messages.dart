import 'package:chat_firebase/Widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/chats_provider.dart';

class Messages extends StatelessWidget {
  final _messageController = TextEditingController();

  Future<void> sendMessage(BuildContext context) async {
    if (_messageController.text.isNotEmpty) {
      //there must be a message typed
      final currentUserid = FirebaseAuth
          .instance.currentUser!.uid; //get userid of user currently logged in
      await FirebaseFirestore.instance.collection('messages').add({
        'text': _messageController.text, //store value of text from controller
        'time': DateTime.now().toString(),
        'uid': currentUserid
      }); //add message data in messages collection for each message

      FocusScope.of(context).unfocus(); //to hide keyboard
      _messageController.clear(); //to clear textfield after sending message
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
                  //to listen changes in messages collection and order by 'time' in descending
                  stream: FirebaseFirestore.instance
                      .collection('messages')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (ctx, snapshot) {
                    if (!snapshot.hasData) {
                      //if snapshot doesnt have data yet show loading spinner
                      return CircularProgressIndicator();
                    }
                    // Provider.of<ChatsData>(context, listen: false)
                    //     .storeMessages(snapshot.data!);
                    return SizedBox(
                      //sizedBox to confine height
                      height: 556,
                      child: ListView.builder(
                        reverse: true, //to show reverse messages as in chats
                        itemBuilder: (c, i) => messageBubble(
                            snapshot.data!.docs[i][
                                'text'], //pass value of 'text' & 'uid' for each document
                            snapshot.data!.docs[i][
                                'uid']), //pass text & userId in messageBubble widget
                        itemCount: snapshot.data!.docs
                            .length, //total no. documents(messages) in messages collection
                      ),
                    );
                  }),
            ),
          ),
          Container(
            //container for messageTextField and send button
            decoration: BoxDecoration(border: Border.all(width: 2)),
            height: 50,
            child: Row(
              children: [
                Expanded(
                    //so that textField takes all the remaining width in row left after send button
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: 'message'),
                  ),
                )),
                IconButton(
                    onPressed: () =>
                        sendMessage(context), //call sendMessage method
                    icon: const Icon(Icons.send))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
