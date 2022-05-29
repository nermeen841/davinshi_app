import 'package:davinshi_app/BottomNavWidget/fabbuttom.dart';
import 'package:davinshi_app/screens/student/view_all.dart';
import 'package:flutter/material.dart';
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
import 'package:davinshi_app/screens/auth/login.dart';

import '../../models/home_item.dart';

// ignore: use_key_in_widget_constructors
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController? tabController;

  final List<String> _itemsEn = [
    'Home',
    'Favorite',
    'Search',
    'Profile',
  ];

  final List<String> _itemsAr = [
    'الرئيسية',
    'المفضلة',
    'البحث',
    'حسابي',
  ];

  final List<String> icons = [
    'assets/images/card-list.png',
    'assets/images/suit-heart.png',
    'assets/images/search.png',
    'assets/images/android-contact.png',
  ];

  @override
  void initState() {
    tabController = TabController(length: 5, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bottomWidget = [
      FirstPage(
        tabBarHome: tabController!,
      ),
      SecPage(),
      PageFour(),
      const Profile(),
    ];
    var bottom = Provider.of<BottomProvider>(context, listen: true);
    Provider.of<HomeProvider>(context, listen: false);
    return Directionality(
      textDirection: getDirection(),
      child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ThirdPage(),
                    ));
              },
              backgroundColor: mainColor,
              child: Image.asset("assets/images/Group 1186.png")),
          bottomNavigationBar: FABBottomAppBar(
            backgroundColor: mainColor,
            items: List.generate(_itemsEn.length, (index) {
              return FABBottomAppBarItem(
                iconData: icons[index],
                text: translateString(_itemsEn[index], _itemsAr[index]),
              );
            }),
            centerItemText: translateString('Category', 'الأقسام'),
            color: Colors.white,
            notchedShape: const CircularNotchedRectangle(),
            onTabSelected: (int val) async {
              ViewAll.brandsSearch = false;
              if (val == 0) {
                tabController!
                    .animateTo(0, duration: const Duration(seconds: 1));
              }
              if (val != bottom.currentIndex) {
                if (val == 4) {
                  bottom.setIndex(val);
                }
                if (val == 0) {
                  bottom.setIndex(val);
                  tabController!
                      .animateTo(0, duration: const Duration(seconds: 1));
                }
                if (val == 2 || val == 3) {
                  bottom.setIndex(val);
                }
                if (val == 1) {
                  if (userId != 0) {
                    bottom.setIndex(val);
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
            selectedColor: Colors.white,
          ),
          body: Consumer<HomeProvider>(
            builder: (context, value, child) => SafeArea(
              child: bottomWidget[bottom.currentIndex],
            ),
          )),
    );
  }
}
