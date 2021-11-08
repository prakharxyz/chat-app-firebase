import 'dart:io';

import '../Providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AccountSettings extends StatefulWidget {
  static const routeName = '/account-settings';
  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  bool _isInit = true;
  bool _isLoading = true;
  File?
      _file; //Nullable type. file can be null as we aren't initialising any value
  String? _imageUrl;
  final _usernameController =
      TextEditingController(); //controller defined for username textField
  bool _isNotEdited = true; //currently we r not editing, we r only reading

  Future<String> _pickImage(String uid) async {
    //to select an image file from gallery & display it on screen
    final imagePicker = ImagePicker(); //create object
    final _pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera); //wait for user to pick image
    if (_pickedImage != null) {
      //if he picks an image, ie, it is not null
      _file = File(_pickedImage
          .path); //set _file equal to image we picked from gallery & rebuild widget tree to reflect the change
    }
    final ref =
        FirebaseStorage.instance.ref().child('user_images').child(uid + '.jpg');
    await ref
        .putFile(_file!); //store the file at firebase storagelocation specified
    final imageUrl = await ref.getDownloadURL();

    print(imageUrl);
    return imageUrl;
  }

  // FileImage? showImage(File? file) {
  //   //method showImage which returns a nullable FileImage(decodes file obj as image) & pass in the File in it
  //   try {
  //     return FileImage(
  //         _file!); // return image for given file if file is valid & is not null
  //   } catch (fileSystemException) {}
  // }

  NetworkImage? showImage(String? url) {
    try {
      if (url != '') {
        return NetworkImage(url!);
      }
      return null;
    } catch (e) {
      print('no image'); //return null if given file is null or invalid
      return null;
    }
  }

  @override
  void initState() {
    //initstate is only executed once when widget tree is created & we cant use context here directly
    super.initState();
  }

  @override
  void didChangeDependencies() {
    //it gets executed imediately after initstate, but it keeps on repeating & keeps rebuilding
    //so to execute it only once when widget is created, set _isInit to true during initstate & then set false once this chunk gets executed
    if (_isInit) {
      Provider.of<UserData>(context).fetchData().then((value) {
        _usernameController.text = value['username']!;
        _imageUrl = value['image']!;
      });
      //fetch data from server. When the future is completed, set the username to textFieldController from map
      _isLoading = false;
      _isInit =
          false; //invert it to false so that it doesn't keep rebuilding again & again
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //Since we want to rebuild almost entire widget tree we arent using Consumer here.
    //We've already fetched user data from server into provider in the didChangeDependencies, so we don't need to fetch again
    final userProvider = Provider.of<UserData>(context);
    final userData = userProvider.userData; //we can use data from provider
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(25),
            transformAlignment: Alignment.center,
            child: GestureDetector(
                child: _isLoading
                    ? CircularProgressIndicator()
                    : CircleAvatar(
                        backgroundImage: showImage(_imageUrl),
                        radius: 60,
                      ),
                onTap: () async {
                  final url = await _pickImage(userData['uid']);
                  await userProvider.updateImage(url);
                  setState(() {
                    _imageUrl = userData['image'];
                  });
                }),
          ),
          Card(
            margin: EdgeInsets.all(15),
            child: Row(
              children: [
                const Text('username : '),
                Expanded(
                  child: TextField(
                    key: ValueKey('usernameField'),
                    controller:
                        _usernameController, //set the controller, which is set initially to username from firebase server
                    readOnly: _isNotEdited,
                    //the field initially is not in editing mode(isNotEdited = true), so it would only allow to read & not edit
                    autofocus: !_isNotEdited,
                    //the field initially is not in editing mode(isNotEdited = true), so keyboard wont pop off & cursor won't focus on textfield
                  ),
                ),
                IconButton(
                    //when we click edit icon we we want to be able to edit & focus on username,
                    // & convert edit icon to done icon so that we can update changes
                    onPressed: () {
                      _isNotEdited
                          ? null
                          : userProvider
                              .updateUsername(_usernameController.text);
                      //if _isNotEdited is true that means we are showing edit icon to user, ie,
                      //do nothing, just go to setstate & make readOnly false & autoFocus true
                      //while if it is false that means we are showing done icon to user, so user wants to dispatch & save the changes in username.
                      //hence call update method from provider and go to setstate & make readOnly true & autoFocus false
                      print('controller text : ${_usernameController.text}');
                      setState(() {
                        _isNotEdited =
                            !_isNotEdited; //set edited mode = true if it was initially in read only mode & vice versa
                      });
                    },
                    icon: Icon(_isNotEdited ? Icons.edit : Icons.done))
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.all(15),
            child: Row(
              children: [Text('E-mail : '), Text(userData['email'])],
            ),
          )
        ],
      ),
    );
  }
}
