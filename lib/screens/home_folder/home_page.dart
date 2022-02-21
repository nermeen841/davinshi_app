import 'package:flutter/material.dart';
import 'package:davinshi_app/provider/CatProvider.dart';
import 'package:davinshi_app/provider/home.dart';
import 'package:provider/provider.dart';
import 'package:davinshi_app/BottomNavWidget/profile.dart';
import 'package:davinshi_app/BottomNavWidget/first_page.dart';
import 'package:davinshi_app/BottomNavWidget/page_four.dart';
import 'package:davinshi_app/BottomNavWidget/secound_page.dart';
import 'package:davinshi_app/BottomNavWidget/third_page.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/provider/fav_pro.dart';
import 'package:davinshi_app/screens/auth/login.dart';

// ignore: use_key_in_widget_constructors
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final List<BottomNav> _items = [
    BottomNav(Icons.home_outlined, Icons.home_outlined, 0, 'Home', 'الرئيسية'),
    BottomNav(Icons.favorite, Icons.favorite_border, 1, 'Favorite', 'المفضلة'),
    BottomNav(Icons.menu, Icons.menu, 2, 'Categories', 'الاقسام'),
    BottomNav(Icons.search, Icons.search, 3, 'Search', 'البحث'),
    BottomNav(Icons.person, Icons.person_outline, 4, 'Profile', 'حسابي'),
  ];
  List<Widget> bottomWidget = [
    FirstPage(),
    SecPage(),
    ThirdPage(),
    PageFour(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    var bottom = Provider.of<BottomProvider>(context, listen: true);
    CatProvider catProvider = Provider.of<CatProvider>(context, listen: false);
    return Directionality(
      textDirection: getDirection(),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: (prefs.getString('language_code') == 'en')
              ? EdgeInsets.only(left: w * 0.07)
              : EdgeInsets.only(right: w * 0.07),
          child: FloatingActionButton(
            onPressed: () async {
              dialog(context);
              await catProvider.getParentCat().then((value) {
                Navigator.pop(context);
                bottom.setIndex(2);
              });
            },
            backgroundColor: mainColor,
            child: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            items: List.generate(_items.length, (index) {
              return BottomNavigationBarItem(
                activeIcon: Icon(
                  _items[index].iconSelect,
                  size: w * 0.07,
                  color: (index == 2) ? Colors.transparent : null,
                ),
                icon: Icon(
                  _items[index].iconNotSelect,
                  size: w * 0.07,
                  color: (index == 2) ? Colors.transparent : null,
                ),
                label: translateString(
                    _items[index].titleEn, _items[index].titleAr),
              );
            }),
            onTap: (val) async {
              if (val == 0) {
                tabBarHome!.animateTo(0, duration: const Duration(seconds: 1));
              }
              if (val != bottom.currentIndex) {
                if (val == 4) {
                  bottom.setIndex(val);
                }
                if (val == 0) {
                  bottom.setIndex(val);
                  tabBarHome!
                      .animateTo(0, duration: const Duration(seconds: 1));
                }
                if (val == 2 || val == 3) {
                  dialog(context);
                  await catProvider.getParentCat().then((value) {
                    Navigator.pop(context);
                    bottom.setIndex(val);
                  });
                }
                if (val == 1) {
                  if (userId != 0) {
                    dialog(context);
                    FavItemProvider fav =
                        Provider.of<FavItemProvider>(context, listen: false);
                    fav.clearList();
                    await fav.getItems().then((value) {
                      if (value) {
                        Navigator.pop(context);
                        bottom.setIndex(val);
                      } else {
                        Navigator.pop(context);
                        error(context);
                      }
                    });
                  } else {
                    final snackBar = SnackBar(
                      content: Text(
                        translate(context, 'snack_bar', 'login'),
                      ),
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
                  }
                }
              }
            },
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,
            currentIndex: bottom.currentIndex,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            selectedLabelStyle:
                TextStyle(color: Colors.black, fontSize: w * 0.03),
            unselectedLabelStyle:
                TextStyle(color: Colors.black, fontSize: w * 0.03),
          ),
        ),
        body: SafeArea(
          child: bottomWidget[bottom.currentIndex],
        ),
      ),
    );
  }
}
