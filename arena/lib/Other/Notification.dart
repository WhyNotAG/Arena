import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Notification extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());

      _fcm.configure(
          onMessage: (Map<String, dynamic> message) async {
            print("onMessage $message");
            final snackbar = SnackBar(
              content: Text(message["notification"]["title"]),
              action: SnackBarAction(
                label: "Go",
                onPressed: () => null,
              ),
            );

            Scaffold.of(context).showSnackBar(snackbar);
          },

          onLaunch: (Map<String, dynamic> message) async {
            print("onMessage $message");
          },

          onResume: (Map<String, dynamic> message) async {
            print("onMessage $message");
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}