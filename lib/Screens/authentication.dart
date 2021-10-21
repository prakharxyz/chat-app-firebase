import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

enum AuthMode { signup, login } //defined a enum var to switch between modes

class _AuthScreenState extends State<AuthScreen> {
  static const routeName = "/auth-screen";
  AuthMode _authMode = AuthMode
      .login; //instantiated AuthMode class and initialised its value as login
  final _key = GlobalKey<FormState>();
  Map<String, String> authDetails = {
    'email': '',
    'username': '',
    'password': ''
  };
  //defined an empty map to store form data in here temporarily when form is saved

  Future<void> _saveForm() async {
    try {
      //if form is validated correctly then save form
      if (_key.currentState!.validate()) {
        _key.currentState!.save();
        //for signUp mode create instance of firebaseAuth & create user from given email password(from temp authDetails map)
        //for login mode create instance of firebaseAuth & sign in user from given email password(from temp authDetails map)
        //Since it is future so we'll await and store its response in  variable
        final responseData = _authMode == AuthMode.signup
            ? await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: authDetails[
                    'email']!, //String? can be null but String cannot
                password: authDetails[
                    'password']!) //! here is basically a null check that password shouldnt be null
            : await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: authDetails['email']!,
                password: authDetails['password']!);

        //To store extra info like name, contact etc.., we can create a users collection in database
        //and store data of every user in form of maps, since each user has its unique user id
        //Therefore, after signing up every new user, we store its details in firestore database
        if (_authMode == AuthMode.signup) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(responseData.user!.uid)
              .set({
            'username': authDetails['username'],
            'email': responseData.user!.email
          });
        }
        print(responseData.user!.email);
        print(responseData.user?.displayName);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: 400,
          // width: 400,
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 100),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: const LinearGradient(
                  colors: [Colors.lime, Color(0xFFDCE775), Color(0xFFE6EE9C)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft)),
          child: SingleChildScrollView(
            child: Form(
                key: _key,
                child: Column(
                  children: [
                    if (_authMode == AuthMode.signup)
                      TextFormField(
                        key: ValueKey('username'),
                        decoration:
                            const InputDecoration(labelText: 'username'),
                        textInputAction: TextInputAction.next,
                        validator: (val) {
                          if (val == null) {
                            return 'please enter a username';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          authDetails['username'] = val!;
                        },
                      ),
                    TextFormField(
                      key: ValueKey('email'),
                      decoration: const InputDecoration(labelText: 'E-mail'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == null || !val.contains('@')) {
                          return 'please enter a valid email address';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        authDetails['email'] = val!;
                      },
                    ),
                    TextFormField(
                      key: ValueKey('password'),
                      decoration: const InputDecoration(labelText: 'Password'),
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      validator: (val) {
                        if (val == null || val.length < 8) {
                          return 'please enter a strong password';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        authDetails['password'] = val!;
                      },
                    ),
                    TextButton.icon(
                        onPressed: _saveForm,
                        icon: Icon(_authMode == AuthMode.login
                            ? Icons.login
                            : Icons.app_registration),
                        label: Text(
                            _authMode == AuthMode.login ? 'Login' : 'Sign-up')),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _authMode == AuthMode.login
                                ? _authMode = AuthMode.signup
                                : _authMode = AuthMode.login;
                          });
                        },
                        child: Text(
                            _authMode == AuthMode.login ? 'Sign-up' : 'Log-in'))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
