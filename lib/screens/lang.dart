import 'package:davinshi_app/models/bottomnav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/country.dart';
import 'package:davinshi_app/models/fav.dart';
import 'package:davinshi_app/models/home_item.dart';
import 'package:davinshi_app/models/user.dart';
import 'auth/country.dart';
import 'home_folder/home_page.dart';

class LangPage extends StatelessWidget {
  LangPage({Key? key}) : super(key: key);
  final String? lang = prefs.getString('language_code');
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(w, h),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Stack(
              children: [
                Container(
                  width: w,
                  height: h,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/icons/Mask Group 32.png"),
                          fit: BoxFit.fill)),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: h * 0.05, right: w * 0.02, left: w * 0.02),
                  child: InkWell(
                    onTap: () => navPop(context),
                    child: Align(
                      alignment: (lang == 'en')
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      child: Container(
                        width: w * 0.09,
                        height: h * 0.04,
                        color: mainColor,
                        child: const Center(
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: h * 0.5),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        width: w * 0.3,
                        child: Image.asset(
                          "assets/images/multi-app.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h * 0.015,
                    ),
                    Center(
                      child: Text(
                        translate(context, 'language', 'change_language'),
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color: const Color(0xff333333),
                            fontFamily: 'Tajawal',
                            fontSize: w * 0.05,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.09, vertical: h * 0.02),
                              child: Center(
                                child: Text(
                                  'English',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: w * 0.05,
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          onTap: () async {
                            dialog(context);
                            await Provider.of<AppLanguage>(context,
                                    listen: false)
                                .changeLanguage(const Locale('en'));
                            if (lang == null) {
                              if (login) {
                                getLikes();
                                getCountries();
                                await getHomeItems();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()),
                                    (route) => false);
                              } else {
                                getCountries();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Country(1)),
                                    (route) => false);
                              }
                            } else {
                              navPop(context);
                            }
                          },
                        ),
                        SizedBox(
                          width: w * 0.08,
                        ),
                        InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.09, vertical: h * 0.02),
                              child: Text(
                                'العربية',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Tajawal',
                                    fontSize: w * 0.05,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          onTap: () async {
                            dialog(context);
                            await Provider.of<AppLanguage>(context,
                                    listen: false)
                                .changeLanguage(const Locale('ar'));
                            // navPop(context);
                            if (lang == null) {
                              if (login) {
                                getLikes();
                                getCountries();
                                await getHomeItems();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()),
                                    (route) => false);
                              } else {
                                getCountries();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Country(1)),
                                    (route) => false);
                              }
                            } else {
                              navPop(context);
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
