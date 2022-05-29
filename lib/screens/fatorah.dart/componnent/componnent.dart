import 'package:davinshi_app/models/constants.dart';
import 'package:flutter/material.dart';

import '../../../lang/change_language.dart';
import '../../../models/bottomnav.dart';

Widget fatoraahDetail() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: translateString("Payment method ", "طريقة الدفع "),
              style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                  fontSize: w * 0.035),
            ),
            TextSpan(
              text: translateString("Knet", " كي نت "),
              style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.w400,
                  color: mainColor,
                  fontSize: w * 0.035),
            ),
          ],
        ),
      ),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: translateString("My fatoorah code ", "كود ماي فاتوره "),
              style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                  fontSize: w * 0.035),
            ),
            TextSpan(
              text: translateString(" 342352654", " 324546456"),
              style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.w400,
                  color: mainColor,
                  fontSize: w * 0.035),
            ),
          ],
        ),
      ),
    ],
  );
}

//////////////////////////////////////////////////////////////////////////////////////

orderDetail() {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: h * 0.04,
            width: w * 0.4,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: mainColor),
            ),
            child: Center(
              child: Text(
                translateString("Quantity  2  pieces ", "الكمية  2 قطعة "),
                style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                    fontSize: w * 0.03),
              ),
            ),
          ),
          Container(
            height: h * 0.04,
            width: w * 0.4,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: mainColor),
            ),
            child: Center(
              child: Text(
                translateString("Piece price  23 kw", "سعر الوحدة  25 د.ك"),
                style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                    fontSize: w * 0.03),
              ),
            ),
          ),
        ],
      ),
      SizedBox(
        height: h * 0.02,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: h * 0.04,
            width: w * 0.4,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: mainColor),
            ),
            child: Center(
              child: Text(
                translateString("discount  10 kw", "الخصم  10 د.ك"),
                style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                    fontSize: w * 0.03),
              ),
            ),
          ),
          Container(
            height: h * 0.04,
            width: w * 0.4,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: mainColor),
            ),
            child: Center(
              child: Text(
                translateString("price  23 kw", "إجمالي الطلب  25 د.ك"),
                style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                    fontSize: w * 0.03),
              ),
            ),
          ),
        ],
      ),
      SizedBox(
        height: h * 0.02,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: h * 0.04,
            width: w * 0.4,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: mainColor),
            ),
            child: Center(
              child: Text(
                translateString("shipping  2 kw ", "سعر الشحن   2 د.ك "),
                style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                    fontSize: w * 0.03),
              ),
            ),
          ),
          Container(
            height: h * 0.04,
            width: w * 0.4,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: mainColor),
            ),
            child: Center(
              child: Text(
                translateString("Total price  23 kw", " الإجمالي  25 د.ك"),
                style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                    fontSize: w * 0.03),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

///////////////////////////////////////////////////////////////////////

orderImages() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        3,
        (index) => Container(
          width: w * 0.2,
          height: h * 0.09,
          margin: EdgeInsets.only(left: w * 0.02, right: w * 0.02),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: mainColor),
            borderRadius: BorderRadius.circular(w * 0.02),
            image: const DecorationImage(
                image: AssetImage("assets/images/143.png"), fit: BoxFit.cover),
          ),
        ),
      ),
    ),
  );
}

///////////////////////////////////////////////////////////////////////////

userDetail() {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            translateString("User name ", "اسم المستخدم "),
            style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w400,
                color: Colors.black87,
                fontSize: w * 0.035),
          ),
          Text(
            "Ahmed mohamed",
            style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w400,
                color: Colors.black87,
                fontSize: w * 0.035),
          ),
        ],
      ),
      SizedBox(
        height: h * 0.02,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: translateString("user type ", "نوع المستخدم "),
                  style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                      fontSize: w * 0.035),
                ),
                TextSpan(
                  text: translateString("visitor", "زائر"),
                  style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.w400,
                      color: mainColor,
                      fontSize: w * 0.035),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: translateString("phone number  ", "الهاتف  "),
                  style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                      fontSize: w * 0.035),
                ),
                TextSpan(
                  text: translateString(" 342352654", " 324546456"),
                  style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.w400,
                      color: mainColor,
                      fontSize: w * 0.035),
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(
        height: h * 0.02,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            translateString("Email ", " الإيميل "),
            style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w400,
                color: Colors.black87,
                fontSize: w * 0.035),
          ),
          Text(
            "Ahmed@gmail.com",
            style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w400,
                color: Colors.black87,
                fontSize: w * 0.035),
          ),
        ],
      ),
      SizedBox(
        height: h * 0.02,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: h * 0.04,
            width: w * 0.3,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
            ),
            child: Center(
              child: Text(
                translateString("Country   kuwait ", "الدولة   الكويت "),
                style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                    fontSize: w * 0.03),
              ),
            ),
          ),
          Container(
            height: h * 0.04,
            width: w * 0.3,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
            ),
            child: Center(
              child: Text(
                translateString("city  hwalli", "المدينة   حولي"),
                style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                    fontSize: w * 0.03),
              ),
            ),
          ),
          Container(
            height: h * 0.04,
            width: w * 0.3,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
            ),
            child: Center(
              child: Text(
                translateString("Area   meshref", " المنطقة   مشرف"),
                style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                    fontSize: w * 0.03),
              ),
            ),
          ),
        ],
      ),
      SizedBox(
        height: h * 0.02,
      ),
      Center(
        child: Text(
          "شارع قنيبه - مبني 415 - الدور 3 - شقه 3",
          style: TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.w400,
              color: Colors.black54,
              fontSize: w * 0.03),
        ),
      ),
    ],
  );
}
