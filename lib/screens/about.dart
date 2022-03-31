// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/info.dart';

class AboutUs extends StatelessWidget {
  final title;
  AboutUs(this.title, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: getDirection(),
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          title: Text(
            title,
            style: TextStyle(
                fontSize: w * 0.05,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: (() => Navigator.pop(context)),
            child: Container(
              width: w * 0.05,
              height: h * 0.01,
              margin: EdgeInsets.symmetric(
                  horizontal: w * 0.02, vertical: h * 0.017),
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
        body: Container(
          height: h,
          width: w,
          padding:
              EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.02),
          margin: EdgeInsets.only(top: h * 0.02),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(w * 0.05),
              topRight: Radius.circular(w * 0.05),
            ),
          ),
          child: info.isEmpty
              ? Center(
                  child: Text(
                    translate(context, 'empty', 'empty'),
                    style: TextStyle(color: mainColor, fontSize: w * 0.05),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: w * .05, left: w * 0.05, top: h * 0.01),
                    child: SizedBox(
                      width: w * 0.9,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var e in info)
                            Column(
                              children: [
                                // Row(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     CircleAvatar(
                                //       backgroundColor: mainColor,
                                //       radius: w * 0.02,
                                //     ),
                                //     SizedBox(
                                //       width: w * .05,
                                //     ),
                                //     SizedBox(
                                //       width: w * 0.75,
                                //       child: Text(
                                //         e.name,
                                //         style: TextStyle(
                                //             color: mainColor,
                                //             fontSize: w * 0.05,
                                //             fontWeight: FontWeight.bold),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                SizedBox(
                                  height: h * 0.01,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: mainColor,
                                      radius: w * 0.02,
                                    ),
                                    SizedBox(
                                      width: w * .05,
                                    ),
                                    SizedBox(
                                      width: w * 0.75,
                                      child: Text(
                                        translateString(e.desEn, e.desAr),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: h * 0.03,
                                ),
                              ],
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
}
