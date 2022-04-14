// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dio/dio.dart' as dio;
import '../../lang/change_language.dart';
import '../../models/bottomnav.dart';
import '../../models/constants.dart';
import '../../models/products_cla.dart';
import '../../models/rate.dart';
import '../../models/user.dart';
import '../auth/login.dart';
import '../product rating/addRate.dart';

class ProductRates extends StatefulWidget {
  const ProductRates({Key? key}) : super(key: key);

  @override
  State<ProductRates> createState() => _ProductRatesState();
}

class _ProductRatesState extends State<ProductRates> {
  List<Rate> rate = [];

  Future getRates() async {
    final String url = domain + 'product/get-ratings';
    try {
      dio.Response response = await dio.Dio()
          .get(url, queryParameters: {'product_id': productCla?.id.toString()});
      print(productCla?.id.toString());
      rate = [];
      if (response.statusCode == 200 && response.data['status'] == 1) {
        setState(() {
          response.data['data'].forEach((e) {
            rate.add(Rate(rate: e['rating'], comment: e['comment']));
          });
        });
      } else {
        print(response.data);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getRates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          SizedBox(
            height: h,
            child: rate.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: h * 0.02,
                        ),
                        ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: rate.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: h * 0.05),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: const AssetImage(
                                      'assets/images/logo_multi.png'),
                                  radius: w * 0.07,
                                  backgroundColor: Colors.transparent,
                                ),
                                title: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: w * 0.25,
                                      height: h * 0.02,
                                      child: RatingBarIndicator(
                                        rating: double.parse(
                                            rate[i].rate.toString()),
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star,
                                          size: w * 0.045,
                                          color: const Color(0xffEE5A30),
                                        ),
                                        itemCount: 5,
                                        itemSize: w * 0.045,
                                        direction: Axis.horizontal,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: SizedBox(
                                    width: w * 0.37,
                                    child: Text(
                                      rate[i].comment ?? "",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: w * 0.04),
                                    )),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          translate(context, 'empty', 'no_rate'),
                          style:
                              TextStyle(color: mainColor, fontSize: w * 0.05),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.03,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            if (login) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddRateScreen(
                                          productId: productCla!.id.toString(),
                                        )),
                              );
                            } else {
                              final snackBar = SnackBar(
                                content: Text(
                                    translate(context, 'snack_bar', 'login')),
                                action: SnackBarAction(
                                  label: translate(context, 'buttons', 'login'),
                                  disabledTextColor: Colors.yellow,
                                  textColor: Colors.yellow,
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Login()),
                                        (route) => false);
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          child: Container(
                            height: h * 0.08,
                            margin: EdgeInsets.symmetric(horizontal: h * 0.04),
                            decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.circular(w * 0.05)),
                            child: Center(
                              child: Text(
                                translate(context, "check_out", "rate"),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: w * 0.05,
                                    fontFamily: 'Tajawal',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          (rate.isNotEmpty)
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: w * 0.03, vertical: h * 0.02),
                  child: Align(
                    alignment: (language == 'ar')
                        ? Alignment.bottomLeft
                        : Alignment.bottomRight,
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddRateScreen(
                            productId: productCla!.id.toString(),
                          ),
                        ),
                      ),
                      child: CircleAvatar(
                        radius: w * 0.08,
                        backgroundColor: mainColor,
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: w * 0.1,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
