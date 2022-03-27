import 'package:davinshi_app/models/bottomnav.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

import '../../../models/constants.dart';

class AllRatesScreen extends StatefulWidget {
  const AllRatesScreen({Key? key}) : super(key: key);

  @override
  State<AllRatesScreen> createState() => _AllRatesScreenState();
}

class _AllRatesScreenState extends State<AllRatesScreen> {
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
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Text(
          (lang == 'en') ? "All Rates" : "التقييمات",
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
          padding:
              EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.02),
          margin: EdgeInsets.only(top: h * 0.04),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(w * 0.05),
              topRight: Radius.circular(w * 0.05),
            ),
          ),
          child: ListView.separated(
              primary: true,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "اسم صاحب التعليق",
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: w * 0.04,
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "جميل جدا ",
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: w * 0.04,
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.w500),
                    ),
                    SimpleStarRating(
                      isReadOnly: true,
                      starCount: 5,
                      rating: 3,
                      size: w * 0.05,
                      allowHalfRating: true,
                      filledIcon: Icon(
                        Icons.star,
                        color: mainColor,
                        size: w * 0.05,
                      ),
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: h * 0.02,
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                  ],
                );
              },
              itemCount: 10),
        ),
      ),
    );
  }
}
