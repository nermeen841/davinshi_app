import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../lang/change_language.dart';
import '../../models/bottomnav.dart';
import '../../models/constants.dart';
import '../../provider/best_item.dart';
import '../../provider/fav_pro.dart';
import '../../provider/home.dart';
import '../../provider/new_item.dart';
import '../../provider/offer_item.dart';
import '../../provider/recommended_item.dart';
import '../home_folder/home_page.dart';

class UserLanguageScreen extends StatefulWidget {
  const UserLanguageScreen({Key? key}) : super(key: key);

  @override
  State<UserLanguageScreen> createState() => _UserLanguageScreenState();
}

class _UserLanguageScreenState extends State<UserLanguageScreen> {
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
                      alignment: (lang == 'en' || lang == null)
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
                          "assets/images/logo_multi.png",
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
                            Provider.of<NewItemProvider>(context, listen: false)
                                .getItems();
                            Provider.of<FavItemProvider>(context, listen: false)
                                .getItems();
                            Provider.of<BestItemProvider>(context,
                                    listen: false)
                                .getItems();
                            Provider.of<OfferItemProvider>(context,
                                    listen: false)
                                .getItems();
                            Provider.of<ReItemProvider>(context, listen: false)
                                .getItems();
                            Provider.of<BottomProvider>(context, listen: false)
                                .setIndex(3);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => Home())),
                                (route) => false);
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
                            Provider.of<NewItemProvider>(context, listen: false)
                                .getItems();
                            Provider.of<FavItemProvider>(context, listen: false)
                                .getItems();
                            Provider.of<BestItemProvider>(context,
                                    listen: false)
                                .getItems();
                            Provider.of<OfferItemProvider>(context,
                                    listen: false)
                                .getItems();
                            Provider.of<ReItemProvider>(context, listen: false)
                                .getItems();
                            Provider.of<BottomProvider>(context, listen: false)
                                .setIndex(3);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => Home())),
                                (route) => false);
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
