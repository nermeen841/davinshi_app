// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors, avoid_print

import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/order.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/screens/cart/cart.dart';
import 'package:davinshi_app/screens/cart/orders.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_fatoorah/my_fatoorah.dart';
import 'confirm_cart.dart';

String mAPIKey =
    "DmnT-XUpIpN8FtbVl6AabNBc-jHxsOlAwrCA_ANkRX5V7D6tVS4nozWQBxrllgkQ3ZErGnfzrwxNqGV2TCgJ0rQGvfEpO8maxMhz0Dt92Buh68M54Ux33SF18QcnEedoFow0E4J49xpEUyplwDzHPoLPAI03XgSWhjDiaF09TP1o49_2ChY8DF_lWUSzPQvT7eRVCXzJWmmJCg-KgEg7AYdAhZ5sakky5exKBLyzucpmXvAELMsBAQE5O8wF6CvSSKOMI064oBFlpSwwkT2vUKdJiQf3AEsxqYpp_wrEsdzW4St7Kke2-8Hy1PRDKbh-iZC3q5Hpwdlk32ZSjazAzZpwsyGDsF1-LZhhYv1eH3BWOhxFjHxIo25tHl7jVa-b9p85ptTR5BcxkQnGPNWInkgHhx2lJFCD1yJBNB8Me_bf_8X9xnc1NkkD_xfw_siJxjx8IlVxL1DHoecEJLMtLTzlpeldc2LOBXb_YZgYiNpRJRWecm2-DgjN7B-ODqI5_poHr4N-E-60RlXfO_K6eAi0KaLeiE6jcmbAoCgdm5UQnFMpyEecM1gaqC3H-V0hwQn_oORaJsuLVFlP-yfDCt9Xcg6Yy9mTQuOnzP7ymjMKI1pccNTY8vWtkLwfdIK8XeJWCgqzK9Wmu5wq7LGIgzM-bSIinT5OfvF-NTbXRMVRMEgfkj_nlfwcpswJZfaLmvNuFQdRNGDSbLCvnTc5eUpJVhFTOD1w9XZu6gIUrlFamP_1";

class PaymentScreen extends StatefulWidget {
  final double totalprice;
  final int orderId;
  final num couponPrice;
  final num maxCopounLimit;
  final String? couponName;
  final bool couponPercentage;
  const PaymentScreen(
      {Key? key,
      required this.totalprice,
      required this.couponPrice,
      required this.couponName,
      required this.maxCopounLimit,
      required this.couponPercentage,
      required this.orderId})
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
                      maxCopounLimit: widget.maxCopounLimit,
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
                          maxCopounLimit: widget.maxCopounLimit,
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
              try {
                final String url = domain + "update-order";
                Response response = await Dio().post(
                  url,
                  data: {"order_id": widget.orderId},
                  options: Options(headers: {
                    "auth-token": (login) ? auth : null,
                    "Content-Language": prefs.getString('language_code') ?? 'en'
                  }),
                );

                print(response.data);
              } catch (e) {
                print(e.toString());
              }
              print("success url : ---------" + res.url.toString());
              if (login) {
                await getOrders().then((value) {
                  if (value) {
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
                        maxCopounLimit: widget.maxCopounLimit,
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
                        maxCopounLimit: widget.maxCopounLimit,
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
