import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserData with ChangeNotifier {
  final _userData = {
    'uid': '',
    'username': '',
    'email': '',
    'image': ''
  }; //create an empty map for storing user data
  Map get userData {
    return _userData;
  } //getter to get map from outside

  //Future method which will fetch userdata from uid from the firebase firestore server into this provider and then return the user data
  Future<Map<String, String>> fetchData() async {
    _userData['uid'] = FirebaseAuth.instance.currentUser!
        .uid; //get the userid of current user & store it in user data
    final userInfo = await FirebaseFirestore.instance
        .collection('users')
        .doc(_userData['uid'])
        .get(); //fetch user data from 'uid' document from the server
    _userData['username'] = userInfo.data()!['username'];
    _userData['email'] = userInfo.data()!['email'];
    _userData['image'] = userInfo.data()!['image'];
    //finally set the fetched data in user data map in provider
    notifyListeners();

    return _userData;
  }

  //future method to update username in firebase firestore server by passing name as argument
  Future<void> updateUsername(String updatedName) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_userData['uid'])
        .update({'username': updatedName});
    userData['username'] = updatedName;
    //update the existing document with updatedName(old value of key will get overwritten & rest of fields will remain same)
    print('updated successfully ');
    notifyListeners();
  }

  Future<void> updateImage(String url) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_userData['uid'])
        .update({'image': url});
    _userData['image'] = url;
    notifyListeners();
  }
}
