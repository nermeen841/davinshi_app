// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../BottomNavWidget/change_pass.dart';
import '../../models/bottomnav.dart';
import '../profile_user.dart';

class ProfileSettingScreen extends StatefulWidget {
  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  String lang = '';

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language_code').toString();
    });
  }

  @override
  void initState() {
    getLang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Text(
          (lang == 'en') ? "Personal Information" : "تحديث الحساب",
          style: TextStyle(
              fontSize: w * 0.05,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: w * 0.05,
            height: h * 0.01,
            margin:
                EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.017),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(w * 0.01)),
            child: Icon(
              Icons.arrow_back,
              color: mainColor,
            ),
          ),
        ),
      ),
      body: Directionality(
        textDirection: getDirection(),
        child: Container(
          height: h,
          width: w,
          margin: EdgeInsets.only(top: h * 0.04),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(w * 0.05),
              topRight: Radius.circular(w * 0.05),
            ),
          ),
          child: ListView(
            primary: true,
            shrinkWrap: true,
            padding:
                EdgeInsets.symmetric(vertical: h * 0.04, horizontal: w * 0.05),
            children: [
              Text(
                (lang == 'en') ? "Personal Information" : "معلومات شخصية",
                style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w600,
                    fontSize: w * 0.05,
                    color: Colors.black),
              ),
              SizedBox(
                height: h * 0.015,
              ),
              Text(
                userName ?? "",
                style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w400,
                    fontSize: w * 0.05,
                    color: Colors.black),
              ),
              SizedBox(
                height: h * 0.01,
              ),
              Text(
                userEmail ?? '',
                style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w400,
                    fontSize: w * 0.05,
                    color: Colors.black),
              ),
              SizedBox(
                height: h * 0.07,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => ProfileUser())));
                },
                child: Container(
                  width: double.infinity,
                  height: h * 0.07,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w * 0.03),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(
                    child: Text(
                      (lang == 'en') ? "Update Information" : "تعديل المعلومات",
                      style: TextStyle(
                          color: mainColor,
                          fontSize: w * 0.04,
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: h * 0.05,
              ),
              Text(
                (lang == 'en') ? "Password" : "كلمة المرور",
                style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w600,
                    fontSize: w * 0.05,
                    color: Colors.black),
              ),
              SizedBox(
                height: h * 0.05,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => ChangePass())));
                },
                child: Container(
                  width: double.infinity,
                  height: h * 0.07,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w * 0.03),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(
                    child: Text(
                      (lang == 'en') ? "change password" : "تغيير كلمة المرور",
                      style: TextStyle(
                          color: mainColor,
                          fontSize: w * 0.04,
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
