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
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (c, snapshot) {
          if (snapshot.hasData) return ChatScreen();
          return AuthScreen();
        },
      ),
    );
  }
}
