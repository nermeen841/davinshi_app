// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:davinshi_app/models/order.dart';
import 'package:davinshi_app/provider/best_item.dart';
import 'package:davinshi_app/provider/fav_pro.dart';
import 'package:davinshi_app/provider/new_item.dart';
import 'package:davinshi_app/provider/offer_item.dart';
import 'package:davinshi_app/provider/social.dart';
import 'package:davinshi_app/screens/auth/login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/country.dart';
import 'package:davinshi_app/models/fav.dart';
import 'package:davinshi_app/screens/auth/country.dart';
import 'package:davinshi_app/screens/lang.dart';
import 'models/home_item.dart';
import 'models/user.dart';
import 'screens/home_folder/home_page.dart';

class Splach extends StatefulWidget {
  @override
  _SplachState createState() => _SplachState();
}

class _SplachState extends State<Splach> {
  Future go() async {
    await Future.delayed(const Duration(seconds: 3), () async {
      String? lang = prefs.getString('language_code');
      bool countrySelected = prefs.getBool('country_selected') ?? false;
      if (lang != null) {
        if (login) {
          getLikes();
          getOrders();
          NewItemProvider();
          FavItemProvider();
          BestItemProvider();
          OfferItemProvider();
          await SocialIcons().getSocialIcons();
          getCountries();
          await getHomeItems();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              (route) => false);
        } else {
          if (countrySelected) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false);
          } else {
            await getCountries();
            await SocialIcons().getSocialIcons();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Country(1)),
                (route) => false);
          }
        }
      } else {
        getCountries();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LangPage()),
            (route) => false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      String? token = prefs.getString('token');
      if (token == null) {
        String? _token = await FirebaseMessaging.instance.getToken();
        if (_token != null) {
          prefs.setString('token', _token);
          setToken(_token);
        }
      } else {
        setToken(token);
      }
      int id = prefs.getInt('id') ?? 0;
      setUserId(id);
      bool login = prefs.getBool('login') ?? false;
      print("loooooooooooooooooogin: " + login.toString());
      setLogin(login);
      userName = prefs.getString('userName');
      String auth = prefs.getString('auth') ?? '';
      setAuth(auth);
      go();
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    setSize(w, h);
    print([1, Navigator.canPop(context)]);
    return PreferredSize(
      preferredSize: Size(w, h),
      child: Container(
        height: h,
        width: w,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.white.withOpacity(0.85),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logo_multi.png',
                    width: w * 0.9,
                    height: h * 0.3,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
