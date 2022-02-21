// ignore_for_file: empty_catches, deprecated_member_use, avoid_print
import 'dart:io';

import 'package:davinshi_app/screens/auth/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:davinshi_app/screens/cart/orders.dart';
import 'package:davinshi_app/screens/lang.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/info.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/screens/about.dart';
import 'package:davinshi_app/screens/address/address.dart';
import 'package:davinshi_app/screens/auth/country.dart';
import 'package:davinshi_app/screens/contac_us.dart';
import 'package:davinshi_app/screens/profile_user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final RoundedLoadingButtonController controller =
      RoundedLoadingButtonController();
  double ratingValue = 0;
  final List<Tile> tile = login
      ? [
          Tile(
              nameAr: 'العناوين',
              nameEn: 'My address',
              image: 'assets/icons/FeatherIconSet-Feather_Maps-map-pin.png',
              className: Address()),
          Tile(
              nameAr: 'طلباتي',
              nameEn: 'My Orders',
              image:
                  'assets/icons/FeatherIconSet-Feather_Miscellaneous-box.png',
              className: const Orders()),
          Tile(
              nameAr: 'الدول',
              nameEn: 'Country',
              image:
                  'assets/icons/FeatherIconSet-Feather_Miscellaneous-globe.png',
              className: Country(2)),
          Tile(
              nameAr: 'اللغات',
              nameEn: 'Language',
              image:
                  'assets/icons/FeatherIconSet-Feather_Miscellaneous-book-open.png',
              className: LangPage()),
          Tile(
              nameAr: 'تواصل معنا',
              nameEn: 'Contact us',
              image: 'assets/icons/FeatherIconSet-Feather_Music-headphones.png',
              className: ContactUs()),
          Tile(
              nameAr: 'عن كنوز',
              nameEn: 'About Konoz',
              keyApi: 'about',
              image: 'assets/icons/FeatherIconSet-Feather_Layout-layers.png',
              className: AboutUs('About Us')),
          Tile(
              nameAr: 'معلومات التوصيل',
              nameEn: 'Delivery Info',
              keyApi: 'delivery',
              image:
                  'assets/icons/FeatherIconSet-Feather_Miscellaneous-truck.png',
              className: AboutUs('Delivery Info')),
          Tile(
              nameAr: 'مساعده',
              nameEn: 'Information',
              keyApi: 'information',
              image:
                  'assets/icons/FeatherIconSet-Feather_Miscellaneous-pen-tool.png',
              className: AboutUs('Information')),
          Tile(
            nameAr: 'تقييم التطبيق',
            nameEn: 'App rate',
            keyApi: 'question',
            image: 'assets/icons/Health-heart.png',
            className: const SizedBox(),
          ),
          Tile(
              nameAr: 'تسجيل خروج',
              nameEn: 'Sign up',
              image: 'assets/icons/FeatherIconSet-Feather_Controls-upload.png',
              className: const SizedBox()),
        ]
      : [
          Tile(
              nameAr: 'العناوين',
              nameEn: 'My address',
              image: 'assets/icons/FeatherIconSet-Feather_Maps-map-pin.png',
              className: Address()),
          Tile(
              nameAr: 'طلباتي',
              nameEn: 'My Orders',
              image:
                  'assets/icons/FeatherIconSet-Feather_Miscellaneous-box.png',
              className: const Orders()),
          Tile(
              nameAr: 'الدول',
              nameEn: 'Country',
              image:
                  'assets/icons/FeatherIconSet-Feather_Miscellaneous-globe.png',
              className: Country(2)),
          Tile(
              nameAr: 'اللغات',
              nameEn: 'Language',
              image:
                  'assets/icons/FeatherIconSet-Feather_Miscellaneous-book-open.png',
              className: LangPage()),
          Tile(
              nameAr: 'تواصل معنا',
              nameEn: 'Contact us',
              image: 'assets/icons/FeatherIconSet-Feather_Music-headphones.png',
              className: ContactUs()),
          Tile(
              nameAr: 'عن كنوز',
              nameEn: 'About Konoz',
              keyApi: 'about',
              image: 'assets/icons/FeatherIconSet-Feather_Layout-layers.png',
              className: AboutUs('About Us')),
          Tile(
              nameAr: 'معلومات التوصيل',
              nameEn: 'Delivery Info',
              keyApi: 'delivery',
              image:
                  'assets/icons/FeatherIconSet-Feather_Miscellaneous-truck.png',
              className: AboutUs('Delivery Info')),
          Tile(
              nameAr: 'مساعده',
              nameEn: 'Information',
              keyApi: 'information',
              image:
                  'assets/icons/FeatherIconSet-Feather_Miscellaneous-pen-tool.png',
              className: AboutUs('Information')),
          Tile(
            nameAr: 'تقييم التطبيق',
            nameEn: 'App rate',
            keyApi: 'question',
            image: 'assets/icons/Health-heart.png',
            className: const SizedBox(),
          ),
          Tile(
              nameAr: 'تسجيل الدخول',
              nameEn: 'Log In',
              image: 'assets/icons/FeatherIconSet-Feather_Controls-upload.png',
              className: const SizedBox()),
        ];

  Future<bool> getInfo(title) async {
    final String url = domain + 'infos?type=$title';
    try {
      Response response = await Dio().get(
        url,
      );
      if (response.statusCode == 200 && response.data['status'] == 1) {
        setInfo(response.data['data']);
        return true;
      }
      if (response.statusCode == 200 && response.data['status'] == 0) {
        setInfo([]);
        return true;
      }
    } catch (e) {}
    return false;
  }

  Future<bool> logOutUser() async {
    final String url = domain + 'logout';
    try {
      await Dio().post(
        url,
        options: Options(headers: {"auth-token": auth}),
      );
      return true;
    } catch (e) {}
    return false;
  }

  Future getProfile() async {
    final String url = domain + 'profile';
    try {
      Response response = await Dio().get(
        url,
        options: Options(headers: {"auth-token": auth}),
      );
      if (response.statusCode == 200 && response.data['name'] is String) {
        Map userData = response.data;
        user = UserClass(
            id: userData['id'],
            name: userData['name'],
            phone: userData['phone'],
            email: userData['email']);
        setUserId(userData['id']);
        navPR(context, ProfileUser());
      } else {
        Map userData = response.data;
        user = UserClass(
            id: userData['id'],
            name: userData['name'],
            phone: userData['phone'],
            email: userData['email']);
        setUserId(userData['id']);
      }
    } catch (e) {
      navPop(context);
      final snackBar = SnackBar(
        content: Text(
          translate(context, 'snack_bar', 'try'),
        ),
        action: SnackBarAction(
          label: translate(context, 'snack_bar', 'undo'),
          disabledTextColor: Colors.yellow,
          textColor: Colors.yellow,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  late File image;
  String image1 = "";

  Future getImage() async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image1 = pickedFile.path;
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size(w, h * 0.32),
          child: Container(
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(w * 0.1),
                bottomRight: Radius.circular(w * 0.1),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment:
                        (prefs.getString('language_code').toString() == 'en')
                            ? Alignment.topRight
                            : Alignment.topLeft,
                    child: InkWell(
                        // onTap: () => Navigator.pop(context),
                        child: (prefs.getString('language_code').toString() ==
                                'en')
                            ? const Icon(
                                Icons.keyboard_arrow_right,
                                size: 30,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.keyboard_arrow_left,
                                size: 30,
                                color: Colors.white,
                              )),
                  ),
                  (login)
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  (prefs.getString('language_code') == 'en')
                                      ? EdgeInsets.only(left: w * 0.1)
                                      : EdgeInsets.only(right: w * 0.09),
                              child: Stack(children: [
                                Container(
                                  width: w * 0.24,
                                  height: h * 0.24,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 4, color: Colors.white),
                                      shape: BoxShape.circle),
                                  child: Container(
                                      width: w * 0.2,
                                      height: h * 0.2,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/icons/Mask Group 1.png'),
                                              fit: BoxFit.cover),
                                          shape: BoxShape.circle,
                                          color: Colors.black)),
                                ),
                                InkWell(
                                  onTap: () async {
                                    getImage();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: h * 0.12,
                                        left: w * 0.13,
                                        right: w * 0.17),
                                    child: Container(
                                      width: w * 0.09,
                                      height: h * 0.09,
                                      child: Center(
                                        child: Image.asset(
                                          "assets/icons/FeatherIconSet-Feather_Controls-edit.png",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white54),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            Center(
                              child: Text(
                                translate(context, 'language', 'my_account'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: w * 0.05,
                                    fontWeight: FontWeight.w700),
                              ),
                            )
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  (prefs.getString('language_code') == 'en')
                                      ? EdgeInsets.only(left: w * 0.1)
                                      : EdgeInsets.only(right: w * 0.09),
                              child: Stack(children: [
                                Container(
                                  width: w * 0.24,
                                  height: h * 0.24,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 4, color: Colors.white),
                                      shape: BoxShape.circle),
                                  child: Container(
                                      width: w * 0.2,
                                      height: h * 0.2,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/icons/Mask Group 1.png'),
                                              fit: BoxFit.cover),
                                          shape: BoxShape.circle,
                                          color: Colors.black)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: h * 0.12,
                                      left: w * 0.13,
                                      right: w * 0.17),
                                  child: InkWell(
                                    onTap: () {
                                      getImage();
                                    },
                                    child: Container(
                                      width: w * 0.09,
                                      height: h * 0.09,
                                      child: Center(
                                        child: Image.asset(
                                          "assets/icons/FeatherIconSet-Feather_Controls-edit.png",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white54),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            Center(
                              child: Text(
                                translate(context, 'language', 'my_account'),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700),
                              ),
                            )
                          ],
                        ),
                ],
              ),
            ),
          ),

          // leading: IconButton(
          //   padding: EdgeInsets.zero,
          //   icon: Icon(
          //     Icons.share,
          //     size: w * 0.05,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {},
          // ),
          // actions: [
          //   Padding(
          //     padding: EdgeInsets.symmetric(vertical: w * 0.01),
          //     child: Badge(
          //       badgeColor: mainColor,
          //       child: IconButton(
          //         icon: const Icon(
          //           Icons.shopping_cart,
          //           color: Colors.white,
          //         ),
          //         padding: EdgeInsets.zero,
          //         focusColor: Colors.white,
          //         onPressed: () {
          //           Navigator.push(
          //               context, MaterialPageRoute(builder: (context) => Cart()));
          //         },
          //       ),
          //       animationDuration: const Duration(
          //         seconds: 1,
          //       ),
          //       badgeContent: Text(
          //         cart.items.length.toString(),
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: w * 0.03,
          //         ),
          //       ),
          //       position: BadgePosition.topStart(start: w * 0.007),
          //     ),
          //   ),
          //   SizedBox(
          //     width: w * 0.02,
          //   ),
          // ],
        ),
        body: Container(
          width: w,
          height: h,
          padding: EdgeInsets.only(top: h * 0.15),
          child: Padding(
            padding:
                EdgeInsets.only(right: w * 0.05, left: w * 0.05, top: h * 0.19),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (userName != null)
                    Text(
                      "" +
                          translate(context, 'language', 'welcom') +
                          "" +
                          userName!,
                      style: TextStyle(
                          color: mainColor,
                          fontSize: w * 0.05,
                          fontWeight: FontWeight.bold),
                    ),
                  if (userName == null)
                    Text(
                      isLeft() ? 'Guest' : 'زائر',
                      style: TextStyle(
                          color: mainColor,
                          fontSize: w * 0.06,
                          fontWeight: FontWeight.bold),
                    ),
                  SizedBox(
                    height: h * 0.01,
                  ),
                  Column(
                    children: List.generate(tile.length, (i) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: h * 0.02),
                        child: Column(
                          children: [
                            ListTile(
                              leading: SizedBox(
                                width: w * 0.05,
                                height: w * 0.05,
                                // decoration: BoxDecoration(
                                //   image: DecorationImage(
                                //     image: AssetImage(),
                                //     fit: BoxFit.contain,
                                //   ),
                                // ),
                                child: Image.asset(
                                  tile[i].image,
                                  fit: BoxFit.contain,
                                  color: mainColor,
                                ),
                              ),
                              trailing: (prefs
                                          .getString('language_code')
                                          .toString() ==
                                      'en')
                                  ? const Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.black,
                                    )
                                  : const Icon(
                                      Icons.keyboard_arrow_left,
                                      color: Colors.black,
                                    ),
                              title: Text(
                                isLeft() ? tile[i].nameEn : tile[i].nameAr,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: w * 0.05,
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () async {
                                if (tile[i].nameEn == 'Edit Profile') {
                                  dialog(context);
                                  getProfile();
                                } else if (tile[i].nameEn == 'Log In') {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Country(1)),
                                      (route) => false);
                                } else if (tile[i].nameEn == 'Sign up') {
                                  dialog(context);
                                  prefs.setBool('login', false);
                                  userName = null;
                                  await prefs.setString('userName', 'Guest');
                                  prefs.setInt('id', 0);
                                  prefs.setString('auth', '');
                                  setUserId(0);
                                  setAuth('');
                                  setLogin(false);
                                  await prefs.setBool('login', false);
                                  logOutUser();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Country(1)),
                                      (route) => false);
                                } else if (tile[i].nameEn == 'App rate') {
                                  showAppRatingDialog(context: context);
                                } else if (tile[i].nameEn == 'Share App') {
                                  // navPRRU(context, const Country(1));
                                } else {
                                  if (tile[i].keyApi != null) {
                                    dialog(context);
                                    bool _check = await getInfo(tile[i].keyApi);
                                    if (_check) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) => AboutUs(isLeft()
                                                  ? tile[i].nameEn
                                                  : tile[i].nameAr)));
                                    } else {
                                      Navigator.pop(context);
                                      error(context);
                                    }
                                  } else {
                                    navP(context, tile[i].className);
                                  }
                                }
                              },
                            ),
                            Divider(
                              color: Colors.grey.withOpacity(0.5),
                            )
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(translate(context, 'home', 'exit_app')),
            content: Text(translate(context, 'home', 'ok_mess')),
            actions: [
              RaisedButton(
                color: mainColor,
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(translate(context, 'home', 'no')),
              ),
              RaisedButton(
                color: mainColor,
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(translate(context, 'home', 'yes')),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> showAppRatingDialog({
    required BuildContext context,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.clear,
                      color: mainColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                Center(
                  child: Text(translate(context, 'alert', 'title')),
                ),
                SizedBox(
                  height: h * 0.03,
                ),
                SimpleStarRating(
                  starCount: 5,
                  rating: ratingValue,
                  allowHalfRating: true,
                  size: w * 0.08,
                  isReadOnly: false,
                  onRated: (rate) {
                    setState(() {
                      ratingValue = rate!;
                    });
                  },
                  spacing: 10,
                ),
                // if (login)
                SizedBox(
                  height: h * 0.03,
                ),
                // if (login)
                TextFormField(
                  cursorColor: Colors.black,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    focusedBorder: form2(),
                    enabledBorder: form2(),
                    errorBorder: form2(),
                    focusedErrorBorder: form2(),
                    hintText: translate(context, 'alert', 'app_rate'),
                    hintStyle: const TextStyle(color: Colors.grey),
                    errorMaxLines: 1,
                    errorStyle: TextStyle(fontSize: w * 0.03),
                  ),
                  onChanged: (val) {},
                ),
                // if (login)
                SizedBox(
                  height: h * 0.03,
                ),
                // if (login)
                RoundedLoadingButton(
                  borderRadius: 15,
                  child: Container(
                    height: h * 0.08,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: mainColor,
                    ),
                    child: Center(
                      child: Text(
                        translate(context, 'buttons', 'send'),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: w * 0.045,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  controller: controller,
                  successColor: mainColor,
                  color: mainColor,
                  disabledColor: mainColor,
                  onPressed: () async {
                    if (login) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      // saveRate();
                    } else {
                      final snackBar = SnackBar(
                        content: Text(translate(context, 'snack_bar', 'login')),
                        action: SnackBarAction(
                          label: translate(context, 'buttons', 'login'),
                          disabledTextColor: Colors.yellow,
                          textColor: Colors.yellow,
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()),
                                (route) => false);
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      controller.error();
                      Future.delayed(const Duration(seconds: 1));
                      controller.stop();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InputBorder form2() {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: (Colors.grey[350]!), width: 1),
      borderRadius: BorderRadius.circular(25),
    );
  }
}

class Tile {
  String nameAr;
  String nameEn;
  String image;
  String? keyApi;
  Widget className;
  Tile(
      {required this.nameAr,
      this.keyApi,
      required this.nameEn,
      required this.image,
      required this.className});
}
