// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, avoid_print

import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/cart.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/order.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/provider/cart_provider.dart';
import 'package:davinshi_app/screens/cart/cart.dart';
import 'package:davinshi_app/screens/cart/orders.dart';
import 'package:flutter/material.dart';
import 'package:my_fatoorah/my_fatoorah.dart';
import 'package:provider/provider.dart';
import 'confirm_cart.dart';

String mAPIKey =
    "KkJrjsHj5CbCgmVhoLLu73L9pWXnaBzFZCRCXB85ESPtPLZZ9YKtWTWr6ffA4IhMRc6hh8QQWljrlEEAwGhQh7C5SV_ckHBQ7s5x6gdzHLh3tGifIXdWr9PZiw0xU7hXv4ifbYsGvvitt9y4h9JWhGIzpXrEz70wqDVqxkVv_D3RyZuEuPNbZtOBzHL7RyNc1UdLpf8Z667u4QU99nyA5RYIMjKg6GylORvB0JrxPknVMCIKhvv9EXZuvGCmaep9C7sNsYLUeAWsl6iERvRPstjMxn-UC7p3fOSwbDS8JXlchGbn-t5jzKo61gPuR6IAB6AShgKAQW8anrgTC5BAVbq3vUGK0MRAuvEW5cvEJn_wcMg4KnbByXVegZ0jLu4D4OGsK5xjUuaCVyMi0aalgaNQXt6k8IhTqzx_KtwRZS0H3yJ6NDvfa1G3YCvnl8-VEzSzoYLNoKZIP32KP5PIv7P4032_GzVZJ2jKfxsm_MutZEAMBHzkQyOcbg4J7QMwY0h_wQCruwCJ0dKcQorYs7pG40PK2ecECXmUJf6RVcjxwqqOXhqIlysOCaTy1x2pJuQ7FALOBrfnqUhNqg4EjRUbwqf4FJRvQonBaI4Vc4cyhQgS1BQS8FXz7Z5Kl-xEIAS00tNHLAbCFuLC0iBPGXMUjTC7gHwLy8tBCt9IukM_Fn4E";

class PaymentScreen extends StatefulWidget {
  final double totalprice;
  final num couponPrice;
  final String? couponName;
  final bool couponPercentage;
  const PaymentScreen(
      {Key? key,
      required this.totalprice,
      required this.couponPrice,
      required this.couponName,
      required this.couponPercentage})
      : super(key: key);
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            translate(context, 'check_out', 'title'),
            style: TextStyle(
                fontSize: w * 0.05,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          leading: BackButton(
            color: mainColor,
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ConfirmCart(
                      couponPrice: widget.couponPrice,
                      couponName: widget.couponName,
                      couponPercentage: widget.couponPercentage)),
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: MyFatoorah(
          afterPaymentBehaviour: AfterPaymentBehaviour.AfterCalbacksExecution,
          buildAppBar: (context) {
            return AppBar(
              backgroundColor: Colors.white,
              title: Text(
                translate(context, 'check_out', 'title'),
                style: TextStyle(
                    fontSize: w * 0.05,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              leading: BackButton(
                color: mainColor,
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConfirmCart(
                          couponPrice: widget.couponPrice,
                          couponName: widget.couponName,
                          couponPercentage: widget.couponPercentage)),
                ),
              ),
              centerTitle: true,
              elevation: 0,
            );
          },
          onResult: (res) async {
            if (res.isSuccess) {
              print("success url : ---------" + res.url.toString());
              if (login) {
                await getOrders().then((value) {
                  Provider.of<CartProvider>(context, listen: false).clearAll();
                  if (value) {
                    dbHelper.deleteAll();
                    navPR(context, const Orders());
                    return null;
                  } else {
                    navPR(context, Cart());
                    print('asdss1');
                    error(context);
                    return null;
                  }
                });
              }
            } else if (res.isError) {
              print("error url : ---------" + res.url.toString());
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ConfirmCart(
                        couponPrice: widget.couponPrice,
                        couponName: widget.couponName,
                        couponPercentage: widget.couponPercentage)),
              );
              customError(context, "there is an error");
            } else if (res.isNothing) {
              print("no thing url : ---------" + res.url.toString());
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ConfirmCart(
                        couponPrice: widget.couponPrice,
                        couponName: widget.couponName,
                        couponPercentage: widget.couponPercentage)),
              );
              customError(context, "there is an error");
            }
          },
          request: MyfatoorahRequest.live(
              token: mAPIKey,
              language: ApiLanguage.Arabic,
              invoiceAmount: widget.totalprice,
              successUrl:
                  "https://images-eu.ssl-images-amazon.com/images/G/31/img16/GiftCards/payurl1/440x300-2.jpg",
              errorUrl:
                  "https://st3.depositphotos.com/3000465/33237/v/380/depositphotos_332373348-stock-illustration-declined-payment-credit-card-vector.jpg?forcejpeg=true",
              currencyIso: Country.Kuwait),
        ),
      ),
    );
  }
}
