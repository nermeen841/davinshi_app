import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/screens/notifications/componnent/body.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: mainColor),
        title: Text(
          translateString("Notifications", "الإشعارات"),
          style: TextStyle(
              fontFamily: "Tajawal",
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: MediaQuery.of(context).size.width * 0.04),
        ),
      ),
      body: const NotificationBody(),
    );
  }
}
