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
    "UflUAT-3OXq8eDNkS7A8YJm-15QsoBKyk-k55pt9_3nR9TmC93spk-Wv3QWrbVd-MCH3uD7ChL0VfoszfRTeRylVkTqMuGYfEZ6SEMvQR24RxGrcavjp6Pv-8GeqB6tUEPAEz_ybCQcpLBwfISLwVojx6YilLiFuCovDnCDZIv1NDEG75VQj5_AYrFLlt7StRX5SIOHVYx2xwNKIHCpMzIeGJsHo6Qc8RfinYg8x6KKy4qEENrxsgVJGQRrzHASGoHKDnzGAvm7ct4PB43Ib8znrhpyK9XeffWGO73cwtMlYf2FUXCvdnijafJOCycmSbzDpcg464qaR1DIyl3_rhomBygJMsOZSSuNn6E-rbYt_IhL7macV4PUp9F__GZ31wE0p1oYRqxHxmrsy4EmyhmqeirtbzkqGBmrcSdiIUWeRBxVbzuLUkEBhVQYfatsiXfyVyMCHWTm5dnz6g1jcb7VoyyIuzatmJhfoGwW0Uzcn4ZK5gHeApCVEXWQ0dIhgbDUGul1UCwewgtRPGQPJ1CTyNBhYRgeV7Xp2LmmcS7U7q8iPPmS2psdB7jbDO4Ag_pnOFhkSUG62DEipC3rXew9Wp-uwWYNp1xubdMaZjLsoYc3mlZJtngFPzq74XhV32_TeQoLsa1DHLxamZL24YJdkH61TvoN2QJdM86dzV6RkX9_uXZFNaKjb2ytJh6Kg_pAc_AZxuOnBLIwqNAuOLARcSIgEZHBtP_BLosAim3R-fjNs";

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
