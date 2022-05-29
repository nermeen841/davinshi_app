import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:flutter/material.dart';

class FatorahScreen extends StatefulWidget {
  const FatorahScreen({Key? key}) : super(key: key);

  @override
  State<FatorahScreen> createState() => _FatorahScreenState();
}

class _FatorahScreenState extends State<FatorahScreen> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.02),
        child: Column(
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
            Text(
              translateString(
                  "Thank you for shopping from Multi", "شكرا لتسوقكم من مالتي"),
              style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.w500,
                  fontSize: w * 0.05),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            Container(
              width: w * 0.6,
              height: h * 0.05,
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.circular(w * 0.03),
              ),
              child: Center(
                child: Text(
                  translateString(
                      "invoice number  342325446", "رقم الفاتورة  343354354"),
                  style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: w * 0.04),
                ),
              ),
            ),
            SizedBox(
              height: h * 0.03,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            translateString("Payment method ", "طريقة الدفع "),
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
                        text: translateString(
                            "My fatoorah code ", "كود ماي فاتوره "),
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
              height: h * 0.015,
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            SizedBox(
              height: h * 0.015,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: translateString("Order date :  ", "تاريخ الطلب : "),
                      style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                          fontSize: w * 0.035),
                    ),
                    TextSpan(
                      text: translateString("21 / 4 / 0323 ", "21 / 4 / 0323 "),
                      style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.w400,
                          color: mainColor,
                          fontSize: w * 0.035),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            Container(
              height: h * 0.05,
              color: mainColor,
              child: Center(
                child: Text(
                  translateString("Order detail ", "تفاصيل الطلب "),
                  style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: w * 0.04),
                ),
              ),
            ),
            SizedBox(
              height: h * 0.03,
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
                      translateString(
                          "Quantity  2  pieces ", "الكمية  2 قطعة "),
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
                      translateString(
                          "Piece price  23 kw", "سعر الوحدة  25 د.ك"),
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
                      translateString(
                          "Total price  23 kw", " الإجمالي  25 د.ك"),
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
            Container(
              height: h * 0.05,
              color: Colors.black,
              child: Center(
                child: Text(
                  translateString("Order Images ", "صور الطلب "),
                  style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: w * 0.04),
                ),
              ),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            SingleChildScrollView(
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
                          image: AssetImage("assets/images/143.png"),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            Container(
              height: h * 0.05,
              color: mainColor,
              child: Center(
                child: Text(
                  translateString("User details ", "معلومات  المستخدم "),
                  style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: w * 0.04),
                ),
              ),
            ),
            SizedBox(
              height: h * 0.02,
            ),
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
            SizedBox(
              height: h * 0.04,
            ),
            InkWell(
              onTap: () {},
              child: Container(
                width: w * 0.3,
                height: h * 0.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(w * 0.05),
                  color: mainColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.download_for_offline_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: w * 0.02,
                    ),
                    Text(
                      translateString("download", "حمل فاتورتك"),
                      style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: w * 0.03),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: h * 0.04,
            ),
          ],
        ),
      ),
    );
  }
}
