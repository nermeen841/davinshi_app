// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool switch1 = true;
  bool switch2 = false;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: getDirection(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              'Send Request',
              style: TextStyle(
                  fontSize: w * 0.05,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            leading: const BackButton(
              color: Colors.black,
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  right: w * .05, left: w * 0.05, top: h * 0.01),
              child: SizedBox(
                width: w * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Receive Notifications',
                          style: TextStyle(fontSize: w * 0.04),
                        ),
                        Switch(
                          value: switch1,
                          onChanged: (onChanged) {
                            setState(() {
                              switch1 = onChanged;
                            });
                          },
                          activeColor: mainColor,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Divider(
                      color: Colors.grey[300],
                      thickness: h * 0.001,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Receive over 24 h',
                          style: TextStyle(fontSize: w * 0.04),
                        ),
                        Switch(
                          value: switch2,
                          onChanged: (onChanged) {
                            setState(() {
                              switch2 = onChanged;
                            });
                          },
                          activeColor: mainColor,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Divider(
                      color: Colors.grey[300],
                      thickness: h * 0.001,
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    SizedBox(
                      width: w * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text('Some Informations'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: h * 0.04,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputBorder form() {
    return OutlineInputBorder(
        borderSide: BorderSide(color: (Colors.grey[200]!), width: 1),
        borderRadius: BorderRadius.circular(5));
  }
}
