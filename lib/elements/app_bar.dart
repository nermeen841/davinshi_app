// ignore_for_file: non_constant_identifier_names

import 'package:badges/badges.dart';
import 'package:davinshi_app/provider/home.dart';
import 'package:davinshi_app/screens/home_folder/home_page.dart';
import 'package:flutter/material.dart';
import 'package:davinshi_app/BottomNavWidget/first_page.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/provider/cart_provider.dart';
import 'package:davinshi_app/screens/cart/cart.dart';
import 'package:provider/provider.dart';

class AppBarHome {
  late int currentindex;
  static PreferredSizeWidget app_bar_home(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    CartProvider cart = Provider.of<CartProvider>(context, listen: false);
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: InkWell(
        onTap: () {
          Provider.of<BottomProvider>(context, listen: false).setIndex(3);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              (route) => false);
        },
        child: Container(
          width: w * 0.8,
          height: w * 0.1,
          padding: EdgeInsets.symmetric(horizontal: w * 0.02),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black38),
              color: Colors.white),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/icons/search-1.png"),
              SizedBox(
                width: w * 0.02,
              ),
              Center(
                child: Text(
                  translate(context, "home", "search"),
                  style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                      fontSize: w * 0.05),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: w * 0.01),
          child: Padding(
            padding: const EdgeInsets.all(5),
            // child: Icon(Icons.search,color: Colors.white,size: w*0.05,),
            child: Badge(
              badgeColor: mainColor,
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                ),
                padding: EdgeInsets.zero,
                focusColor: Colors.white,
                onPressed: () {
                  // Navigator.push(
                  //     context, MaterialPageRoute(builder: (context) => Cart()));
                },
              ),
              animationDuration: const Duration(
                seconds: 2,
              ),
              badgeContent: Text(
                "0",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.03,
                ),
              ),
              position: BadgePosition.topStart(start: w * 0.03, top: h * 0.001),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: w * 0.01),
          child: Padding(
            padding: const EdgeInsets.all(5),
            // child: Icon(Icons.search,color: Colors.white,size: w*0.05,),
            child: Badge(
              badgeColor: mainColor,
              child: InkWell(
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.black,
                ),
                focusColor: Colors.white,
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Cart()));
                },
              ),
              animationDuration: const Duration(
                seconds: 2,
              ),
              badgeContent: Text(
                cart.items.length.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w * 0.03,
                ),
              ),
              position: BadgePosition.topStart(start: w * 0.002),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size(w, h * 0.07),
        child: Container(
          width: w,
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: h * 0.01),
          child: TabBar(
            indicator: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  offset: const Offset(0, 3),
                  spreadRadius: 3,
                  blurRadius: 3)
            ], color: mainColor, borderRadius: BorderRadius.circular(20)),
            controller: tabBarHome,
            tabs: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.03, vertical: h * 0.01),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                ),
                child: Center(
                    child: Text(
                  translate(context, 'home', 'home'),
                  textAlign: TextAlign.center,
                )),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.03, vertical: h * 0.01),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    translate(context, 'home', 'new'),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: w * 0.03, vertical: h * 0.01),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                      child: Text(
                    translate(context, 'home', 'best'),
                    textAlign: TextAlign.center,
                  ))),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.03, vertical: h * 0.01),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                    child: Text(
                  translate(context, 'home', 'recommendation'),
                  textAlign: TextAlign.center,
                )),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.03, vertical: h * 0.01),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                    child: Text(
                  translate(context, 'home', 'offers'),
                  textAlign: TextAlign.center,
                )),
              ),
            ],
            overlayColor: MaterialStateProperty.all(Colors.white),
            unselectedLabelColor: Colors.black,
            labelStyle: TextStyle(
                fontSize: w * 0.04,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w700),
            unselectedLabelStyle: TextStyle(
                fontSize: w * 0.04,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w700),
            indicatorColor: mainColor,
            automaticIndicatorColorAdjustment: true,
            labelColor: Colors.white,
            isScrollable: true,
          ),
        ),
      ),
    );
  }
}
