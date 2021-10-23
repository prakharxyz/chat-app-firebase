import 'package:chat_firebase/Screens/authentication.dart';
import 'package:chat_firebase/Screens/chats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        //to listen to changes in token or authState.
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (c, snapshot) {
          if (snapshot.hasData) return ChatScreen();
          //if snapshot is not null or has data it means we have required token to get in or we r logged in, so we directly enter chatScreen
          //otherwise we r required to log in first
          return AuthScreen();
        },
      ),
    );
  }
}
