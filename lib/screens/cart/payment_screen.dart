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
    "cLX1hxyg_n2zEb2VwVFYeoK5Yuz6ALwWX-0EGxTOZ4gl7ua_dYkEwFcsGdftJKlD9WQ9VoRb33blq1Zt4ChZooRTHIG16j6H3sYvM-9OB1yLJFjjvQEm77WFqlRCEa1_Kbvu09o_Me0WoCpEVEqVtXenpW1ojF4QDRjcFlADMuxW6CQfUWAnKdoPFoY27PEf03yejOY_iWpLUt-N-PHOays6B23e8F93ZATzdtD4kkvF-zS1OyQoe4y7OFli0nD_qV8iZ5wb8x8nUClE6UjhPwlME4tGR2glJfuZ1Oro9Bd3OTi37vumRI6E3uSQ8N69znUdyadyNN00LhtZwJo2dT2DxybZgIcU_mO6HjMjpBcUpg3WduMLIzbSZ-fWVwx1n0UROEMrADW00s66psMaJ1NLbPYSafaDDTptMXop2e81oA7QC01o9lmhjQiF_huS5w-o_n1mRo_quKuFwAyQkzomyvQrUBwl7O3dW1qj2KM923Gz0cImwbyQ56KZe00XIDjQrgtRnA5oir6ZGieYrKxO5MPpCyF2SW2OkmA761Huct3UJUObjSClAW7yzdij91Sm01KmUDtePQkPG94BwYI2Q5ACw5E8Utm_JzqmSrLnpDDBhyw1dDn_yCiWEDNV4E6EjudWNHNKaP7E95Bibn3s6Uciezls_D0Q5eX42OmvEWtTH7wLU0HVmAhEWOOZ9n9eVxgEzaXJkPt75cYXKTNBQtdZLRDMYoqisL5biQg6qspO";

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
          backgroundColor: mainColor,
          title: Text(
            translate(context, 'check_out', 'title'),
            style: TextStyle(
                fontSize: w * 0.05,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          leading: BackButton(
            color: Colors.white,
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
              backgroundColor: mainColor,
              title: Text(
                translate(context, 'check_out', 'title'),
                style: TextStyle(
                    fontSize: w * 0.05,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              leading: BackButton(
                color: Colors.white,
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
