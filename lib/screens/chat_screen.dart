import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {

  static String id = 'Chat Screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User loggedInUser;
  String message;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if(user != null){
        loggedInUser = user;
        print(user.email);
      }
    }catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _auth.signOut();
        Navigator.pop(context);
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _auth.signOut();
                  Navigator.pop(context);
                }),
          ],
          title: Text('⚡️Chat'),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection('messages').snapshots(),
                  builder: (context, snapshot){
                    if(!snapshot.hasData){
                      return Center(
                        child: CircularProgressIndicator(backgroundColor: kSecondaryColor,),
                      );
                    }else{
                      final messages = snapshot.data.docs;
                      List<Text> messageWidgets = [];
                      for (var message in messages){
                        final text = message.get('text');
                        final sender = message.get('sender');
                        final messageWidget = Text('$text from $sender');
                        messageWidgets.add(messageWidget);
                      }
                      return Column(
                        children: messageWidgets,
                      );
                    }
                }),
                Container(
                  decoration: kMessageContainerDecoration,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            message = value;
                          },
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          firestore.collection('messages').add({
                            'text': message,
                            'sender': loggedInUser.email,
                          });
                        },
                        child: Text(
                          'Send',
                          style: kSendButtonTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
