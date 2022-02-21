import 'package:flutter/material.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/provider/student_provider.dart';
import 'package:davinshi_app/screens/student/student.dart';

Widget floatingActionButton(BuildContext context) {
  return FloatingActionButton(
    onPressed: () async {
      dialog(context);
      await getStudentsHome();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Student()));
    },
    backgroundColor: mainColor,
    child: Center(
      child: Icon(
        Icons.home,
        color: Colors.white,
        size: w * 0.08,
      ),
    ),
  );
}
