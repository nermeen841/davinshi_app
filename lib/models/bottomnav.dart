import 'package:flutter/material.dart';

class BottomNav {
  String titleEn;
  String titleAr;
  IconData iconSelect;
  IconData iconNotSelect;
  int id;
  BottomNav(
      this.iconSelect, this.iconNotSelect, this.id, this.titleEn, this.titleAr);
}

Color mainColor = const Color(0xffB58840);
Color mainColor2 = const Color(0xffB58840).withOpacity(0.2);
