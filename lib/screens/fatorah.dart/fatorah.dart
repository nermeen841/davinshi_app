import 'package:davinci/core/davinci_capture.dart';
import 'package:davinci/core/davinci_core.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/provider/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../cart/confirm_cart.dart';
import '../home_folder/home_page.dart';

class FatorahScreen extends StatefulWidget {
  const FatorahScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FatorahScreen> createState() => _FatorahScreenState();
}

class _FatorahScreenState extends State<FatorahScreen> {
  var currency = (prefs.getString('language_code').toString() == 'en')
      ? prefs.getString('currencyEn').toString()
      : prefs.getString('currencyAr').toString();
  GlobalKey? imageKey;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: mainColor,
          onPressed: () {
            Provider.of<BottomProvider>(context, listen: false).setIndex(0);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
        ),
        elevation: 0,
      ),
      body: Container(
        width: w,
        height: h,
        color: Colors.white,
        child: SingleChildScrollView(
          padding:
              EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.02),
          child: Column(
            children: [
              Davinci(
                builder: (key) {
                  imageKey = key;
                  return Container(
                    color: Colors.white,
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
                          translateString("Thank you for shopping from Multi",
                              "شكرا لتسوقكم من مالتي"),
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
                                  "invoice number  ${ConfirmCart.saveOrderModel!.order!.id!}",
                                  "رقم الفاتورة  ${ConfirmCart.saveOrderModel!.order!.id!}"),
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
                                    text: translateString(
                                        "Payment method ", "طريقة الدفع "),
                                    style: TextStyle(
                                        fontFamily: 'Tajawal',
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87,
                                        fontSize: w * 0.035),
                                  ),
                                  TextSpan(
                                    text: getPaymentmathod(
                                        paymentMethod: ConfirmCart
                                            .saveOrderModel!
                                            .order!
                                            .paymentMethod!),
                                    style: TextStyle(
                                        fontFamily: 'Tajawal',
                                        fontWeight: FontWeight.w400,
                                        color: mainColor,
                                        fontSize: w * 0.035),
                                  ),
                                ],
                              ),
                            ),
                            (ConfirmCart.saveOrderModel!.order!.invoiceId !=
                                    null)
                                ? RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: translateString(
                                              "My fatoorah code ",
                                              "كود ماي فاتوره "),
                                          style: TextStyle(
                                              fontFamily: 'Tajawal',
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87,
                                              fontSize: w * 0.035),
                                        ),
                                        TextSpan(
                                          text:
                                              "${ConfirmCart.saveOrderModel!.order!.invoiceId!}",
                                          style: TextStyle(
                                              fontFamily: 'Tajawal',
                                              fontWeight: FontWeight.w400,
                                              color: mainColor,
                                              fontSize: w * 0.035),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
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
                                  text: translateString(
                                      "Order date :  ", "تاريخ الطلب : "),
                                  style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87,
                                      fontSize: w * 0.035),
                                ),
                                TextSpan(
                                  text: " " +
                                      ConfirmCart
                                          .saveOrderModel!.order!.createdAt!
                                          .substring(0, 10)
                                          .toString() +
                                      " ",
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
                                      "Quantity   ${ConfirmCart.saveOrderModel!.order!.productCount!}   pieces ",
                                      "الكمية  ${ConfirmCart.saveOrderModel!.order!.productCount!} قطعة "),
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
                                      "price  ${ConfirmCart.saveOrderModel!.order!.orderPrice!} $currency",
                                      "إجمالي الطلب  ${ConfirmCart.saveOrderModel!.order!.orderPrice!} $currency"),
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
                                  translateString(
                                      "shipping  ${ConfirmCart.saveOrderModel!.order!.shippingPrice!} $currency ",
                                      "سعر الشحن   ${ConfirmCart.saveOrderModel!.order!.shippingPrice!} $currency "),
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
                                      "discount  ${ConfirmCart.saveOrderModel!.order!.discount!} $currency",
                                      "الخصم  ${ConfirmCart.saveOrderModel!.order!.discount!}  $currency"),
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
                          height: h * 0.04,
                          width: w * 0.85,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: mainColor),
                          ),
                          child: Center(
                            child: Text(
                              translateString(
                                  "Total price  ${ConfirmCart.saveOrderModel!.order!.totalPrice!} $currency",
                                  " الإجمالي  ${ConfirmCart.saveOrderModel!.order!.totalPrice!} $currency"),
                              style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                  fontSize: w * 0.03),
                            ),
                          ),
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
                              ConfirmCart
                                  .saveOrderModel!.order!.productsData!.length,
                              (index) => Container(
                                width: w * 0.2,
                                height: h * 0.09,
                                margin: EdgeInsets.only(
                                    left: w * 0.02, right: w * 0.02),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: mainColor),
                                  borderRadius: BorderRadius.circular(w * 0.02),
                                  image: DecorationImage(
                                      image: NetworkImage(ConfirmCart
                                          .saveOrderModel!
                                          .order!
                                          .productsData![index]
                                          .image!),
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
                              translateString(
                                  "User details ", "معلومات  المستخدم "),
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
                              ConfirmCart.saveOrderModel!.order!
                                  .shippingAddress!.name!,
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
                                    text: translateString(
                                        "user type ", "نوع المستخدم "),
                                    style: TextStyle(
                                        fontFamily: 'Tajawal',
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87,
                                        fontSize: w * 0.035),
                                  ),
                                  (login)
                                      ? TextSpan(
                                          text: translateString(
                                              "app user", "مستخدم للتطبيق"),
                                          style: TextStyle(
                                              fontFamily: 'Tajawal',
                                              fontWeight: FontWeight.w400,
                                              color: mainColor,
                                              fontSize: w * 0.035),
                                        )
                                      : TextSpan(
                                          text: translateString(
                                              "visitor", "زائر"),
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
                                        "phone number  ", "الهاتف  "),
                                    style: TextStyle(
                                        fontFamily: 'Tajawal',
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87,
                                        fontSize: w * 0.035),
                                  ),
                                  TextSpan(
                                    text: ConfirmCart.saveOrderModel!.order!
                                        .shippingAddress!.phone!,
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
                        (ConfirmCart.saveOrderModel!.order!.shippingAddress!
                                    .email !=
                                null)
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    ConfirmCart.saveOrderModel!.order!
                                        .shippingAddress!.email
                                        .toString(),
                                    style: TextStyle(
                                        fontFamily: 'Tajawal',
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87,
                                        fontSize: w * 0.035),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        (ConfirmCart.saveOrderModel!.order!.shippingAddress!
                                    .email !=
                                null)
                            ? SizedBox(
                                height: h * 0.02,
                              )
                            : const SizedBox(),
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
                                  translateString(
                                      "Country   ${ConfirmCart.saveOrderModel!.order!.shippingAddress!.countryEn!} ",
                                      "الدولة   ${ConfirmCart.saveOrderModel!.order!.shippingAddress!.countryAr!} "),
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
                                  translateString(
                                      "city  ${ConfirmCart.saveOrderModel!.order!.shippingAddress!.araeEn}",
                                      "المدينة   ${ConfirmCart.saveOrderModel!.order!.shippingAddress!.araeAr!}"),
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
                                  translateString(
                                      "Area   ${ConfirmCart.saveOrderModel!.order!.shippingAddress!.araeEn!}",
                                      " المنطقة   ${ConfirmCart.saveOrderModel!.order!.shippingAddress!.araeAr!}"),
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
                        (ConfirmCart.saveOrderModel!.order!.shippingAddress!
                                    .addressD !=
                                null)
                            ? Center(
                                child: Text(
                                  ConfirmCart.saveOrderModel!.order!
                                          .shippingAddress!.address! +
                                      ConfirmCart.saveOrderModel!.order!
                                          .shippingAddress!.addressD!,
                                  style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      fontSize: w * 0.03),
                                ),
                              )
                            : Center(
                                child: Text(
                                  ConfirmCart.saveOrderModel!.order!
                                      .shippingAddress!.address!,
                                  style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      fontSize: w * 0.03),
                                ),
                              ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: h * 0.04,
              ),
              InkWell(
                onTap: () async {
                  await DavinciCapture.click(imageKey!,
                      openFilePreview: true, saveToDevice: true);
                },
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
      ),
    );
  }

  getPaymentmathod({required String paymentMethod}) {
    if (paymentMethod == "cash") {
      return translateString("cash", "الدفع عند الاستلام");
    } else if (paymentMethod == "knet") {
      return translateString("Knet", "كي نت ");
    }
  }
}
