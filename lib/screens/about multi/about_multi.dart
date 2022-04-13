// ignore_for_file: avoid_print

import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:flutter/material.dart';
import '../../BottomNavWidget/profile.dart';
import '../../models/bottomnav.dart';
import '../about.dart';

class AboutMultiScreen extends StatefulWidget {
  const AboutMultiScreen({Key? key}) : super(key: key);

  @override
  State<AboutMultiScreen> createState() => _AboutMultiScreenState();
}

class _AboutMultiScreenState extends State<AboutMultiScreen> {
  final List<Tile> about = [
    Tile(
        nameAr: 'الشروط و الأحكام',
        nameEn: 'Terms & Condition',
        keyApi: 'TermsAndConditions',
        image: 'assets/images/command.png',
        className: AboutUs('Terms & Condition')),
    Tile(
        nameAr: 'سياسة الخصوصية',
        nameEn: 'Privacy Policy',
        keyApi: 'PrivacyPolicy',
        image: 'assets/images/Group 1100.png',
        className: AboutUs('Privacy Policy')),
    Tile(
        nameAr: 'حول تطبيق مالتي',
        nameEn: 'About Multi',
        keyApi: 'about',
        image: 'assets/images/Group 1095.png',
        className: AboutUs('About Us')),
    Tile(
        nameAr: 'معلومات التوصيل',
        nameEn: 'Delivery Info',
        keyApi: 'delivery',
        image: 'assets/images/Group 1090.png',
        className: AboutUs('Delivery Info')),
  ];
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: getDirection(),
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          title: Text(
            translateString("About Multi", "حول مالتي"),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              about.length,
              (index) => Column(
                children: [
                  ListTile(
                      leading: SizedBox(
                        width: w * 0.07,
                        height: w * 0.07,
                        child: Image.asset(
                          about[index].image,
                          fit: BoxFit.contain,
                          color: Colors.black,
                        ),
                      ),
                      trailing:
                          (prefs.getString('language_code').toString() == 'en')
                              ? const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.black,
                                )
                              : const Icon(
                                  Icons.keyboard_arrow_left,
                                  color: Colors.black,
                                ),
                      title: Text(
                        isLeft() ? about[index].nameEn : about[index].nameAr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: w * 0.05,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () async {
                        if (about[index].keyApi != null) {
                          // dialog(context);
                          // bool _check = await getInfo(about[index].keyApi);
                          // if (_check) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => AboutUs(
                                        isLeft()
                                            ? about[index].nameEn
                                            : about[index].nameAr,
                                        apiKey: about[index].keyApi,
                                      )));
                          // } else {
                          //   Navigator.pop(context);
                          //   error(context);
                          // }
                          // } else {
                          //   navP(context, about[index].className);
                        }
                      }),
                  Divider(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
