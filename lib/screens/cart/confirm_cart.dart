// ignore_for_file: avoid_print, deprecated_member_use

import 'package:davinshi_app/models/products_cla.dart';
import 'package:davinshi_app/screens/cart/payment_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/cart.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/country.dart';
import 'package:davinshi_app/models/order.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/provider/address.dart';
import 'package:davinshi_app/provider/cart_provider.dart';
import 'package:provider/provider.dart';

import 'orders.dart';

class ConfirmCart extends StatefulWidget {
  final num couponPrice;
  final num maxCopounLimit;
  final String? couponName;
  final bool couponPercentage;
  const ConfirmCart(
      {Key? key,
      required this.couponPrice,
      required this.maxCopounLimit,
      required this.couponName,
      required this.couponPercentage})
      : super(key: key);
  @override
  _ConfirmCartState createState() => _ConfirmCartState();
}

class _ConfirmCartState extends State<ConfirmCart> {
  int isCash = 0;
  late double finalPrice;
  Future checkOut(context) async {
    final String url2 = domain + 'save-order';
    CartProvider _cart = Provider.of<CartProvider>(context, listen: false);
    AddressClass? address =
        Provider.of<AddressProvider>(context, listen: false).addressCart;
    Map data = login
        ? {
            "name": address!.name,
            "phone": address.phone1,
            "email": address.email,
            "address_d": address.country,
            "note": address.note,
            "area_id": address.areaId,
            "address": address.address,
            "products_id": _cart.idProducts,
            "quantity_products": _cart.quan,
            "optionValue_products": _cart.op,
            "shipping_address_id": address.id,
            "student_id": _cart.st,
            "lat_and_long":
                address.lat.toString() + ',' + address.long.toString(),
            "coupon_code": widget.couponName,
            "payment_method": (isCash == 1) ? "cash" : "knet"
          }
        : {
            "name": addressGuest!.name,
            "phone": addressGuest!.phone1,
            "address_d": addressGuest!.country,
            "email": addressGuest!.email,
            "note": addressGuest!.note,
            "area_id": addressGuest!.areaId,
            "address": addressGuest!.address,
            "products_id": _cart.idProducts,
            "quantity_products": _cart.quan,
            "optionValue_products": _cart.op,
            "shipping_address_id": 0,
            "student_id": _cart.st,
            "lat_and_long": addressGuest!.lat.toString() +
                ',' +
                addressGuest!.long.toString(),
            "coupon_code": widget.couponName,
            "payment_method": (isCash == 1) ? "cash" : "knet"
          };
    print(data);
    if (widget.couponName == null) {
      data.remove('coupon_code');
    }
    if (!login) {
      data.remove('shipping_address_id');
    }
    try {
      Response response = await Dio().post(
        url2,
        data: data,
        options: Options(headers: {
          "auth-token": (login) ? auth : null,
          "Content-Language": prefs.getString('language_code') ?? 'en'
        }),
      );
      if (response.data['status'] == 1) {
        print(response.data);
        if (isCash == 0) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentScreen(
                        maxCopounLimit: widget.maxCopounLimit,
                        totalprice:
                            response.data['order']['total_price'].toDouble(),
                        couponName: widget.couponName,
                        couponPercentage: widget.couponPercentage,
                        couponPrice: widget.couponPrice,
                      )));
        } else if (isCash == 1) {
          if (login) {
            await getOrders().then((value) {
              if (value) {
                Provider.of<CartProvider>(context, listen: false).clearAll();
                dbHelper.deleteAll();
                navPR(context, const Orders());
                return null;
              } else {
                navPop(context);
                print('asdss1');
                error(context);
                return null;
              }
            });
          } else {
            navPop(context);
            dbHelper.deleteAll();
            Provider.of<CartProvider>(context, listen: false).clearAll();
            alertSuccessCart(context);
            return null;
          }
        }
      }
      if (response.data['status'] == 0) {
        navPop(context);
        String data = '';
        if (response.data['message'] is List) {
          if (language == 'en') {
            response.data['message'].forEach((e) {
              data += e + '\n';
            });
          } else {
            response.data['message'].forEach((e) {
              data += e + '\n';
            });
          }
        }
        print('hamza');
        print(response.data);
        print(response.data['message']);
        customError(context,
            response.data['message'] is List ? data : response.data['order']);
        return null;
      }
    } catch (e) {
      print('error $e');
      // navPop(context);
      error(context);
    }
  }

  var currency = (prefs.getString('language_code').toString() == 'en')
      ? prefs.getString('currencyEn').toString()
      : prefs.getString('currencyAr').toString();
  int _counter = 2;

  @override
  Widget build(BuildContext context) {
    CartProvider cart = Provider.of<CartProvider>(context, listen: false);
    AddressClass? address =
        Provider.of<AddressProvider>(context, listen: false).addressCart;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Directionality(
        textDirection: getDirection(),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: mainColor,
            title: Text(
              translate(context, 'check_out', 'title'),
              style: TextStyle(
                  fontSize: w * 0.05,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            leading: const BackButton(
              color: Colors.white,
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(
                height: h * 0.02,
              ),
              Align(
                alignment:
                    isLeft() ? Alignment.centerLeft : Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(left: w * 0.05, right: w * 0.05),
                  child: Text(
                    translate(context, 'check_out', 'payment'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: w * 0.05),
                  ),
                ),
              ),
              SizedBox(
                height: h * 0.02,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _counter = 1;
                    isCash = 1;
                  });
                },
                child: Container(
                  height: h * 0.08,
                  width: w * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey[200],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(right: w * 0.05, left: w * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          translate(context, 'check_out', 'cash'),
                          style: TextStyle(fontSize: w * 0.035),
                        ),
                        Container(
                          width: w * 0.06,
                          height: w * 0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border:
                                Border.all(color: mainColor, width: w * 0.005),
                            color: _counter == 1 ? mainColor : Colors.white,
                          ),
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.done),
                              onPressed: () {},
                              iconSize: w * 0.04,
                              color: Colors.white,
                              padding: const EdgeInsets.all(0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: h * 0.02,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _counter = 2;
                    isCash = 0;
                  });
                },
                child: Container(
                  height: h * 0.08,
                  width: w * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey[200],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(right: w * 0.05, left: w * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          translateString('Knet ( visa / Master card)',
                              'كي نت ( فيزا / ماستر كارد )'),
                          style: TextStyle(fontSize: w * 0.035),
                        ),
                        Container(
                          width: w * 0.06,
                          height: w * 0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border:
                                Border.all(color: mainColor, width: w * 0.005),
                            color: _counter == 2 ? mainColor : Colors.white,
                          ),
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.done),
                              onPressed: () {},
                              iconSize: w * 0.04,
                              color: Colors.white,
                              padding: const EdgeInsets.all(0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: h * 0.02,
              ),

              // InkWell(
              //   onTap: () {
              //     setState(() {
              //       _counter = 3;
              //       isCash = 0;
              //     });
              //   },
              //   child: Container(
              //     height: h * 0.08,
              //     width: w * 0.9,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(5),
              //       color: Colors.grey[200],
              //     ),
              //     child: Padding(
              //       padding: EdgeInsets.only(right: w * 0.05, left: w * 0.05),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             translate(context, 'check_out', 'master'),
              //             style: TextStyle(fontSize: w * 0.035),
              //           ),
              //           Container(
              //             width: w * 0.06,
              //             height: w * 0.06,
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(50),
              //               border:
              //                   Border.all(color: mainColor, width: w * 0.005),
              //               color: _counter == 3 ? mainColor : Colors.white,
              //             ),
              //             child: Center(
              //               child: IconButton(
              //                 icon: const Icon(Icons.done),
              //                 onPressed: () {},
              //                 iconSize: w * 0.04,
              //                 color: Colors.white,
              //                 padding: const EdgeInsets.all(0),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: h * 0.02,
              // ),

              Padding(
                padding: EdgeInsets.all(w * 0.05),
                child: SizedBox(
                  width: w,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            translate(context, 'cart', 'price'),
                            style: TextStyle(
                                color: Colors.black, fontSize: w * 0.05),
                          ),
                          Text(
                            getProductprice(
                                currency: currency,
                                productPrice: cart.subTotal),
                            style: TextStyle(
                                color: Colors.black, fontSize: w * 0.05),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: h * 0.03,
                      ),
                      if (login)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translate(context, 'cart', 'delivery'),
                              style: TextStyle(
                                  color: Colors.black, fontSize: w * 0.05),
                            ),
                            if (address != null)
                              Text(
                                getProductprice(
                                    currency: currency,
                                    productPrice: getAreaPrice(address.areaId)),
                                style: TextStyle(
                                    color: Colors.black, fontSize: w * 0.05),
                              ),
                            if (address == null)
                              Text(
                                getProductprice(
                                    currency: currency,
                                    productPrice: cart.delivery),
                                style: TextStyle(
                                    color: Colors.black, fontSize: w * 0.05),
                              ),
                          ],
                        ),
                      if (!login)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translate(context, 'cart', 'delivery'),
                              style: TextStyle(
                                  color: Colors.black, fontSize: w * 0.05),
                            ),
                            if (addressGuest != null)
                              Text(
                                getProductprice(
                                    currency: currency,
                                    productPrice:
                                        getAreaPrice(addressGuest!.areaId)),
                                style: TextStyle(
                                    color: Colors.black, fontSize: w * 0.05),
                              ),
                            if (addressGuest == null)
                              Text(
                                getProductprice(
                                    currency: currency,
                                    productPrice: cart.delivery),
                                style: TextStyle(
                                    color: Colors.black, fontSize: w * 0.05),
                              ),
                          ],
                        ),
                      SizedBox(
                        height: h * 0.03,
                      ),
                      if (widget.couponPrice != 0.0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translate(context, 'cart', 'discount'),
                              style: TextStyle(
                                  color: Colors.black, fontSize: w * 0.05),
                            ),
                            Text(
                              getProductprice(
                                  currency: currency,
                                  productPrice: widget.couponPrice),
                              style: TextStyle(
                                  color: Colors.black, fontSize: w * 0.05),
                            ),
                          ],
                        ),
                      if (widget.couponPrice != 0.0)
                        SizedBox(
                          height: h * 0.03,
                        ),
                      Divider(
                        color: Colors.grey[300],
                        thickness: h * 0.001,
                      ),
                      SizedBox(
                        height: h * 0.03,
                      ),
                      if (login)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translate(context, 'cart', 'total'),
                              style: TextStyle(
                                  color: Colors.black, fontSize: w * 0.05),
                            ),
                            if (address != null)
                              Text(
                                '${(getprice(
                                      currency: currency,
                                      productPrice: cart.total,
                                    ) + getprice(
                                      currency: currency,
                                      productPrice:
                                          getAreaPrice(address.areaId),
                                    ) - maxDiscount(price: cart.subTotal))} $currency',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: w * 0.055,
                                    fontWeight: FontWeight.bold),
                              ),
                            if (address == null)
                              Text(
                                '${(getprice(currency: currency, productPrice: cart.total) - maxDiscount(price: cart.subTotal))} $currency',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: w * 0.055,
                                    fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                      if (!login)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translate(context, 'cart', 'total'),
                              style: TextStyle(
                                  color: Colors.black, fontSize: w * 0.05),
                            ),
                            if (addressGuest != null)
                              Text(
                                '${(getprice(currency: currency, productPrice: cart.total) + getprice(currency: currency, productPrice: getAreaPrice(addressGuest!.areaId)) - maxDiscount(price: cart.subTotal))} $currency',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: w * 0.055,
                                    fontWeight: FontWeight.bold),
                              ),
                            if (addressGuest == null)
                              Text(
                                '${(getprice(currency: currency, productPrice: cart.total) - maxDiscount(price: cart.subTotal))} $currency',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: w * 0.055,
                                    fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                      SizedBox(
                        height: h * 0.06,
                      ),
                    ],
                  ),
                ),
              ),
              if (login)
                InkWell(
                  child: Container(
                    width: w,
                    height: h * 0.12,
                    color: Colors.white,
                    child: Center(
                      child: Container(
                        width: w * 0.95,
                        height: h * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: mainColor,
                        ),
                        child: Center(
                          child: Text(
                            translate(context, 'buttons', 'check_out'),
                            style: TextStyle(
                                color: Colors.white, fontSize: w * 0.05),
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    checkOut(context);
                  },
                ),
              if (!login)
                InkWell(
                  child: Container(
                    width: w,
                    height: h * 0.12,
                    color: Colors.white,
                    child: Center(
                      child: Container(
                        width: w * 0.95,
                        height: h * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: mainColor,
                        ),
                        child: Center(
                          child: Text(
                            translate(context, 'buttons', 'check_out'),
                            style: TextStyle(
                                color: Colors.white, fontSize: w * 0.05),
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    checkOut(context);
                  },
                ),
            ],
          )),
        ),
      ),
    );
  }

  num maxDiscount({required num price}) {
    num finaldiscount = (widget.couponPercentage)
        ? double.parse((getprice(currency: currency, productPrice: price) *
                getprice(currency: currency, productPrice: widget.couponPrice) /
                100)
            .toStringAsFixed(2))
        : getprice(currency: currency, productPrice: widget.couponPrice);
    if (finaldiscount > price) {
      finaldiscount = price - widget.maxCopounLimit;
      return finaldiscount;
    } else {
      return finaldiscount;
    }
  }

  num getprice({required String currency, required num productPrice}) {
    String ratio = prefs.getString("ratio").toString();
    num ratioPrice = num.parse(ratio);

    if (currency != 'KWD' || currency != 'د.ك') {
      num finalPrice = productPrice / ratioPrice;

      return finalPrice;
    } else {
      num finalPrice = productPrice;
      return finalPrice;
    }
  }
}
