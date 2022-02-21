// ignore_for_file: avoid_print, deprecated_member_use

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
  final String? couponName;
  final bool couponPercentage;
  const ConfirmCart(
      {Key? key,
      required this.couponPrice,
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
                        totalprice:
                            response.data['order']['total_price'].toDouble(),
                        couponName: widget.couponName,
                        couponPercentage: widget.couponPercentage,
                        couponPrice: widget.couponPrice,
                      )));
        } else if (isCash == 1) {
          if (login) {
            await getOrders().then((value) {
              Provider.of<CartProvider>(context, listen: false).clearAll();
              if (value) {
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
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: SingleChildScrollView(
              child: Column(
            children: [
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
                          translate(context, 'check_out', 'visa'),
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
              InkWell(
                onTap: () {
                  setState(() {
                    _counter = 3;
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
                          translate(context, 'check_out', 'master'),
                          style: TextStyle(fontSize: w * 0.035),
                        ),
                        Container(
                          width: w * 0.06,
                          height: w * 0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border:
                                Border.all(color: mainColor, width: w * 0.005),
                            color: _counter == 3 ? mainColor : Colors.white,
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
                            '${cart.subTotal} $currency',
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
                                '${getAreaPrice(address.areaId)} $currency',
                                style: TextStyle(
                                    color: Colors.black, fontSize: w * 0.05),
                              ),
                            if (address == null)
                              Text(
                                '${cart.delivery} $currency',
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
                                '${getAreaPrice(addressGuest!.areaId)} $currency',
                                style: TextStyle(
                                    color: Colors.black, fontSize: w * 0.05),
                              ),
                            if (addressGuest == null)
                              Text(
                                '${cart.delivery} $currency',
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
                              '${widget.couponPrice} $currency',
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
                                '${(cart.total + getAreaPrice(address.areaId) - (widget.couponPercentage ? double.parse((cart.subTotal * widget.couponPrice / 100).toStringAsFixed(2)) : widget.couponPrice))} $currency',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: w * 0.055,
                                    fontWeight: FontWeight.bold),
                              ),
                            if (address == null)
                              Text(
                                '${(cart.total - (widget.couponPercentage ? double.parse((cart.subTotal * widget.couponPrice / 100).toStringAsFixed(2)) : widget.couponPrice))} $currency',
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
                                '${(cart.total + getAreaPrice(addressGuest!.areaId) - (widget.couponPercentage ? double.parse((cart.subTotal * widget.couponPrice / 100).toStringAsFixed(2)) : widget.couponPrice))} $currency',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: w * 0.055,
                                    fontWeight: FontWeight.bold),
                              ),
                            if (addressGuest == null)
                              Text(
                                '${(cart.total - (widget.couponPercentage ? double.parse((cart.subTotal * widget.couponPrice / 100).toStringAsFixed(2)) : widget.couponPrice))} $currency',
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
                    dialog(context);
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
                    dialog(context);
                    checkOut(context);
                  },
                ),
            ],
          )),
        ),
      ),
    );
  }
}
