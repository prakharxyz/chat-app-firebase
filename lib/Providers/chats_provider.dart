import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ChatsData with ChangeNotifier {
  List<Map<String, dynamic>> _messages = [];

  List<Map<String, dynamic>> get messages {
    return [..._messages];
  }

  void storeMessages(QuerySnapshot querySnapshot) {
    _messages = querySnapshot.docs
        .map((e) => {'text': e['text'], 'time': e['time'], 'uid': e['uid']})
        .toList();
    notifyListeners();
  }
}
