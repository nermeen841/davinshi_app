// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'dart:convert';
import 'package:davinshi_app/models/products_cla.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:davinshi_app/screens/cart/confirm_cart.dart';
import 'package:provider/provider.dart';
import 'package:davinshi_app/dbhelper.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/cart.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/country.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/provider/address.dart';
import 'package:davinshi_app/provider/cart_provider.dart';
import 'package:davinshi_app/screens/address/add_address.dart';
import 'package:davinshi_app/screens/address/choose_address.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<int> idProducts = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  late int checkCoupon;
  late String errorCoupon;
  String? couponName;
  num couponPrice = 0.0;
  num maxCopounLimit = 0.0;
  bool couponPercentage = false;
  final FocusNode _focusNode = FocusNode();
  DbHelper dbHelper = DbHelper();

  Future<int> setCoupon(context, coupon, price) async {
    final String url2 = domain +
        'check-coupon?coupon_code=$coupon&order_price=$price&brand_id=$cartId';
    try {
      Response response = await Dio().post(url2);
      if (response.data['status'] == 1) {
        print(response.data);
        couponName = coupon;
        setState(() {
          maxCopounLimit = response.data['data']['min_price'];
        });
        couponPercentage =
            response.data['data']['type_discount'] == 'percentage'
                ? true
                : false;
        checkCoupon = 1;
        couponPrice = num.parse(response.data['data']['discount'].toString());
        return 1; // success
      }
      if (response.data['status'] == 0) {
        errorCoupon = response.data['message'];
        checkCoupon = 2;
        return 2; // cant find
      }
    } catch (e) {
      print('error $e');
      checkCoupon = 4;
      return 4; // error
    }
    checkCoupon = 4;
    return 4;
  }

  @override
  void initState() {
    super.initState();
    idProducts = Provider.of<CartProvider>(context, listen: false).idp;
  }

  int deliveryDays = 0;
  getdeliveryDays() async {
    var productId = {};
    try {
      final String url = domain + "shipping_time";
      for (var element in idProducts) {
        productId['products'] = element;
      }

      Map<String, dynamic> body = {"products": productId};
      print(body);

      Response response = await Dio().post(
        url,
        data: body,
      );
      print(response.data);
      if (response.data['status'] == 1) {
        setState(() {
          deliveryDays = response.data['time'];
        });
      }
      print(deliveryDays);
    } catch (e) {
      print("error while get delivery days : " + e.toString());
    }
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  var currency = (prefs.getString('language_code').toString() == 'en')
      ? prefs.getString('currencyEn').toString()
      : prefs.getString('currencyAr').toString();
  @override
  Widget build(BuildContext context) {
    CartProvider cart = Provider.of<CartProvider>(context, listen: true);
    AddressClass? address =
        Provider.of<AddressProvider>(context, listen: false).addressCart;
    num maxDiscount({required num price}) {
      num finaldiscount = 0.0;
      if (maxCopounLimit < cart.subTotal) {
        finaldiscount = couponPercentage
            ? double.parse((getprice(currency: currency, productPrice: price) *
                    getprice(currency: currency, productPrice: couponPrice) /
                    100)
                .toStringAsFixed(2))
            : getprice(currency: currency, productPrice: couponPrice);
        if (finaldiscount > price) {
          finaldiscount = price - maxCopounLimit;
          return finaldiscount;
        } else {
          return finaldiscount;
        }
      }
      return finaldiscount;
    }

    getdeliveryDays();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            translate(context, 'cart', 'title'),
            style: TextStyle(color: Colors.white, fontSize: w * 0.04),
          ),
          centerTitle: false,
          backgroundColor: mainColor,
          leading: const BackButton(
            color: Colors.white,
          ),
        ),
        body: cart.cart.isNotEmpty
            ? Container(
                width: w,
                height: h,
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          InkWell(
                            child: SizedBox(
                              width: w,
                              child: Padding(
                                padding: EdgeInsets.all(w * 0.05),
                                child: Column(
                                  children: [
                                    if (login)
                                      InkWell(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              color: Colors.grey,
                                              size: w * 0.09,
                                            ),
                                            SizedBox(
                                              width: w * 0.02,
                                            ),
                                            if (address != null)
                                              SizedBox(
                                                width: w * 0.5,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      address.title,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: w * 0.04),
                                                    ),
                                                    Text(
                                                      address.address,
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: w * 0.035,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            if (address == null)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    translate(context, 'cart',
                                                        'address'),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: w * 0.04),
                                                  ),
                                                ],
                                              ),
                                            const Expanded(
                                                child: SizedBox(
                                              width: 1,
                                            )),
                                            InkWell(
                                              child: Text(
                                                translate(
                                                  context,
                                                  'buttons',
                                                  'change',
                                                ),
                                                style: TextStyle(
                                                    color: mainColor,
                                                    fontSize: w * 0.035),
                                              ),
                                              onTap: () {
                                                if (login) {
                                                  Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (ctx) =>
                                                                  ChooseAddress()))
                                                      .then((value) {
                                                    setState(() {});
                                                  });
                                                } else {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (ctx) =>
                                                              AddAddress(
                                                                false,
                                                                inCart: true,
                                                              ))).then((value) {
                                                    setState(() {});
                                                  });
                                                }
                                              },
                                            ),
                                            SizedBox(
                                              width: w * 0.02,
                                            ),
                                            Directionality(
                                              textDirection:
                                                  getDirection(normal: false),
                                              child: Row(
                                                children: [
                                                  BackButton(
                                                    color: Colors.grey,
                                                    onPressed: () {
                                                      if (login) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (ctx) =>
                                                                    ChooseAddress())).then(
                                                            (value) {
                                                          setState(() {});
                                                        });
                                                      } else {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (ctx) =>
                                                                    AddAddress(
                                                                        false))).then(
                                                            (value) {
                                                          setState(() {});
                                                        });
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          if (login) {
                                            Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (ctx) =>
                                                            ChooseAddress()))
                                                .then((value) {
                                              setState(() {});
                                            });
                                          } else {
                                            Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (ctx) =>
                                                            AddAddress(false)))
                                                .then((value) {
                                              setState(() {});
                                            });
                                          }
                                        },
                                      ),
                                    if (!login)
                                      InkWell(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              color: Colors.grey,
                                              size: w * 0.09,
                                            ),
                                            SizedBox(
                                              width: w * 0.02,
                                            ),
                                            if (addressGuest != null)
                                              SizedBox(
                                                width: w * 0.48,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      addressGuest!.title,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: w * 0.04),
                                                    ),
                                                    Text(
                                                      addressGuest!.address,
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: w * 0.035,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            if (addressGuest == null)
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    translate(context, 'cart',
                                                        'address'),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: w * 0.04),
                                                  ),
                                                ],
                                              ),
                                            const Expanded(
                                                child: SizedBox(
                                              width: 1,
                                            )),
                                            InkWell(
                                              child: Text(
                                                translate(
                                                  context,
                                                  'buttons',
                                                  'change',
                                                ),
                                                style: TextStyle(
                                                    color: mainColor,
                                                    fontSize: w * 0.04),
                                              ),
                                              onTap: () {
                                                if (login) {
                                                  Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (ctx) =>
                                                                  ChooseAddress()))
                                                      .then((value) {
                                                    setState(() {});
                                                  });
                                                } else {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (ctx) =>
                                                              AddAddress(
                                                                false,
                                                                inCart: true,
                                                              ))).then((value) {
                                                    setState(() {});
                                                  });
                                                }
                                              },
                                            ),
                                            SizedBox(
                                              width: w * 0.02,
                                            ),
                                            Directionality(
                                              textDirection:
                                                  getDirection(normal: false),
                                              child: BackButton(
                                                color: Colors.grey,
                                                onPressed: () {
                                                  if (login) {
                                                    Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (ctx) =>
                                                                    ChooseAddress()))
                                                        .then((value) {
                                                      setState(() {});
                                                    });
                                                  } else {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (ctx) =>
                                                                AddAddress(
                                                                  false,
                                                                  inCart: true,
                                                                ))).then(
                                                        (value) {
                                                      setState(() {});
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          if (login) {
                                            Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (ctx) =>
                                                            ChooseAddress()))
                                                .then((value) {
                                              setState(() {});
                                            });
                                          } else {
                                            Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (ctx) =>
                                                            AddAddress(false)))
                                                .then((value) {
                                              setState(() {});
                                            });
                                          }
                                        },
                                      ),
                                    SizedBox(
                                      height: h * 0.02,
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          child: CircleAvatar(
                                            radius: w * 0.037,
                                            backgroundColor: mainColor,
                                            child: CircleAvatar(
                                              radius: w * 0.035,
                                              backgroundColor:
                                                  idProducts.isNotEmpty
                                                      ? mainColor
                                                      : Colors.white,
                                              child: Center(
                                                child: Icon(
                                                  Icons.done,
                                                  color: Colors.white,
                                                  size: w * 0.04,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              idProducts.clear();
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: w * 0.02,
                                        ),
                                        Text(
                                          '${translate(context, 'cart', 'all')} (${idProducts.length}/${cart.items.length})',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: w * 0.04),
                                        ),
                                        const Expanded(
                                            child: SizedBox(
                                          width: 1,
                                        )),
                                        InkWell(
                                          child: Text(
                                            translate(
                                                context, 'cart', 'delete'),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: w * 0.04,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onTap: () async {
                                            if (idProducts.isNotEmpty) {
                                              for (var e in idProducts) {
                                                await dbHelper
                                                    .deleteProductByIdp(e);
                                              }
                                              await cart.setItems();
                                              setState(() {
                                                idProducts =
                                                    Provider.of<CartProvider>(
                                                            context,
                                                            listen: false)
                                                        .idp;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {},
                          ),
                          Container(
                            height: h * 0.02,
                            width: w,
                            color: Colors.grey[200],
                          ),
                          Column(
                            children: List.generate(cart.cart.length, (index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: isLeft()
                                        ? EdgeInsets.only(
                                            left: w * 0.05, top: w * 0.05)
                                        : EdgeInsets.only(
                                            right: w * 0.05, top: w * 0.05),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: w * 0.1,
                                          height: w * 0.1,
                                          // child: SvgPicture.network(cart.cart[index].svg),
                                          child: cart.cart[index].svg
                                                  .contains('.svg')
                                              ? SvgPicture.network(
                                                  cart.cart[index].svg)
                                              : Image.network(
                                                  cart.cart[index].svg,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        SizedBox(
                                          width: w * 0.03,
                                        ),
                                        Text(
                                          translateString(
                                              cart.cart[index].nameEn,
                                              cart.cart[index].nameAr),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: w * 0.04,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(w * 0.05),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                          cart.cart[index].cartPro.length, (i) {
                                        CartProducts _pro =
                                            cart.cart[index].cartPro[i];
                                        String des = '';
                                        for (var e in _pro.des) {
                                          if (e != '') {
                                            des += e + ',';
                                          }
                                        }
                                        if (des.endsWith(',')) {
                                          des =
                                              des.substring(0, des.length - 1);
                                        }
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: w * 0.00,
                                              vertical: h * 0.01),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  InkWell(
                                                    child: CircleAvatar(
                                                      radius: w * 0.037,
                                                      backgroundColor:
                                                          mainColor,
                                                      child: CircleAvatar(
                                                        radius: w * 0.035,
                                                        backgroundColor:
                                                            idProducts.contains(
                                                                    _pro.idp)
                                                                ? mainColor
                                                                : Colors.white,
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.done,
                                                            color: Colors.white,
                                                            size: w * 0.04,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      if (idProducts
                                                          .contains(_pro.idp)) {
                                                        setState(() {
                                                          idProducts
                                                              .remove(_pro.idp);
                                                        });
                                                      } else {
                                                        setState(() {
                                                          idProducts
                                                              .add(_pro.idp);
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: w * 0.018,
                                                  ),
                                                  InkWell(
                                                    onTap: () {},
                                                    child: SizedBox(
                                                        width: w * 0.65,
                                                        child: Text(
                                                          translateString(
                                                              _pro.titleEn,
                                                              _pro.titleAr),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  w * 0.04),
                                                        )),
                                                  ),
                                                  const Expanded(
                                                      child: SizedBox(
                                                    width: 1,
                                                  )),
                                                  IconButton(
                                                    padding: EdgeInsets.zero,
                                                    icon: Icon(
                                                      Icons.close,
                                                      color: Colors.grey,
                                                      size: w * 0.06,
                                                    ),
                                                    onPressed: () async {
                                                      await dbHelper
                                                          .deleteProduct(
                                                              _pro.id!);
                                                      cart.setItems();
                                                    },
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: h * 0.02,
                                              ),
                                              SizedBox(
                                                width: w,
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: w * 0.09,
                                                    ),
                                                    Container(
                                                      height: h * 0.12,
                                                      width: w * 0.18,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              _pro.image),
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: w * 0.03,
                                                    ),
                                                    SizedBox(
                                                      height: h * 0.13,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            getProductprice(
                                                                currency:
                                                                    currency,
                                                                productPrice:
                                                                    _pro.price),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    mainColor,
                                                                fontSize:
                                                                    w * 0.035),
                                                          ),
                                                          Text(
                                                            des,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    mainColor,
                                                                fontSize:
                                                                    w * 0.035),
                                                          ),
                                                          Container(
                                                            height: h * 0.07,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 0.5),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(w *
                                                                          0.03),
                                                              child: Row(
                                                                children: [
                                                                  IconButton(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    icon: Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color: Colors
                                                                              .grey[
                                                                          400],
                                                                      size: w *
                                                                          0.06,
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      if (_pro.quantity >
                                                                          1) {
                                                                        await dbHelper.updateProduct(
                                                                            _pro.quantity -
                                                                                1,
                                                                            _pro.idp,
                                                                            _pro.price.toDouble(),
                                                                            jsonEncode(_pro.att),
                                                                            jsonEncode(_pro.des),
                                                                            jsonEncode(_pro.productOptions),
                                                                            _pro.productquantity.toInt(),
                                                                            _pro.isOrder);
                                                                      } else {
                                                                        await dbHelper
                                                                            .deleteProduct(_pro.id!);
                                                                      }
                                                                      cart.setItems();
                                                                    },
                                                                  ),
                                                                  SizedBox(
                                                                    width: w *
                                                                        0.04,
                                                                  ),
                                                                  Text(
                                                                    _pro.quantity
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            w * .04),
                                                                  ),
                                                                  SizedBox(
                                                                    width: w *
                                                                        0.04,
                                                                  ),
                                                                  IconButton(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    icon: Icon(
                                                                      Icons.add,
                                                                      color: Colors
                                                                              .grey[
                                                                          400],
                                                                      size: w *
                                                                          0.06,
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      if (productCla!
                                                                          .isClothes!) {
                                                                        checkProductClothesQuantity(
                                                                            sizeId: _pro.att[
                                                                                0],
                                                                            colorId: _pro.att[
                                                                                1],
                                                                            productId: _pro
                                                                                .idp,
                                                                            quantity: _pro.quantity +
                                                                                1,
                                                                            scaffoldKey:
                                                                                scaffoldKey);
                                                                        if (itemCount >=
                                                                            _pro.quantity +
                                                                                1) {
                                                                          await dbHelper.updateProduct(
                                                                              _pro.quantity + 1,
                                                                              _pro.idp,
                                                                              _pro.price.toDouble(),
                                                                              jsonEncode(_pro.att),
                                                                              jsonEncode(_pro.des),
                                                                              jsonEncode(_pro.productOptions),
                                                                              _pro.productquantity.toInt(),
                                                                              _pro.isOrder);
                                                                          cart.setItems();
                                                                        }
                                                                      } else if (productCla!
                                                                          .attributes
                                                                          .isNotEmpty) {
                                                                        checkProductquantity(
                                                                            productId: _pro.idp
                                                                                .toString(),
                                                                            quantity: _pro.quantity +
                                                                                1,
                                                                            scaffoldKey:
                                                                                scaffoldKey,
                                                                            attributes: _pro
                                                                                .att,
                                                                            context:
                                                                                context,
                                                                            options:
                                                                                _pro.productOptions);
                                                                        if (itemsAvailable! >=
                                                                            _pro.quantity +
                                                                                1) {
                                                                          await dbHelper.updateProduct(
                                                                              _pro.quantity + 1,
                                                                              _pro.idp,
                                                                              _pro.price.toDouble(),
                                                                              jsonEncode(_pro.att),
                                                                              jsonEncode(_pro.des),
                                                                              jsonEncode(_pro.productOptions),
                                                                              _pro.productquantity.toInt(),
                                                                              _pro.isOrder);
                                                                          cart.setItems();
                                                                        }
                                                                      } else {
                                                                        if (_pro.productquantity >=
                                                                            _pro.quantity +
                                                                                1) {
                                                                          await dbHelper.updateProduct(
                                                                              _pro.quantity + 1,
                                                                              _pro.idp,
                                                                              _pro.price.toDouble(),
                                                                              jsonEncode(_pro.att),
                                                                              jsonEncode(_pro.des),
                                                                              jsonEncode(_pro.productOptions),
                                                                              _pro.productquantity.toInt(),
                                                                              _pro.isOrder);
                                                                          cart.setItems();
                                                                        } else if (_pro.productquantity <
                                                                            _pro.quantity +
                                                                                1) {
                                                                          final snackBar =
                                                                              SnackBar(
                                                                            content:
                                                                                Text(
                                                                              translateString('product available quantity is only ${_pro.productquantity}', 'هذا المنتج متاح منه فقط ${_pro.productquantity}'),
                                                                              style: TextStyle(fontFamily: 'Tajawal', fontSize: w * 0.04, fontWeight: FontWeight.w500),
                                                                            ),
                                                                            action:
                                                                                SnackBarAction(
                                                                              label: translateString("Undo", "تراجع"),
                                                                              disabledTextColor: Colors.yellow,
                                                                              textColor: Colors.yellow,
                                                                              onPressed: () {},
                                                                            ),
                                                                          );
                                                                          ScaffoldMessenger.of(scaffoldKey.currentContext!)
                                                                              .showSnackBar(snackBar);
                                                                        }
                                                                      }
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: h * 0.02,
                                              ),
                                              Divider(
                                                color: Colors.grey[300],
                                                thickness: h * 0.002,
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  Container(
                                    height: h * 0.02,
                                    width: w,
                                    color: Colors.grey[200],
                                  ),
                                ],
                              );
                            }),
                          ),
                          Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: w * 0.05, vertical: h * 0.02),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      translate(context, 'cart', 'coupon'),
                                      style: TextStyle(fontSize: w * 0.04),
                                    ),
                                    InkWell(
                                      child: Text(
                                        translate(context, 'cart', 'add'),
                                        style: TextStyle(
                                            fontSize: w * 0.045,
                                            color: mainColor),
                                      ),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            final TextEditingController
                                                _controller =
                                                TextEditingController();
                                            return Directionality(
                                              textDirection: getDirection(),
                                              child: AlertDialog(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15.0))),
                                                content: SizedBox(
                                                  height: h * 0.16,
                                                  width: w * 0.95,
                                                  child: StatefulBuilder(
                                                    builder: (BuildContext
                                                            context,
                                                        StateSetter setState) {
                                                      return Center(
                                                        child: Form(
                                                          key: _formKey,
                                                          child: TextFormField(
                                                            cursorColor:
                                                                Colors.black,
                                                            controller:
                                                                _controller,
                                                            focusNode:
                                                                _focusNode,
                                                            validator: (val) {
                                                              if (checkCoupon ==
                                                                  5) {
                                                                return errorCoupon;
                                                              }
                                                              if (checkCoupon ==
                                                                  4) {
                                                                return translate(
                                                                    context,
                                                                    'cart',
                                                                    'error');
                                                              }
                                                              if (checkCoupon ==
                                                                  3) {
                                                                return errorCoupon;
                                                              }
                                                              if (checkCoupon ==
                                                                  2) {
                                                                return errorCoupon;
                                                              }
                                                              if (val!
                                                                  .isEmpty) {
                                                                return translate(
                                                                    context,
                                                                    'validation',
                                                                    'field');
                                                              }
                                                              return null;
                                                            },
                                                            keyboardType:
                                                                TextInputType
                                                                    .text,
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  translate(
                                                                      context,
                                                                      'inputs',
                                                                      'coupon'),
                                                              hintStyle:
                                                                  TextStyle(
                                                                color:
                                                                    mainColor,
                                                              ),
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color:
                                                                      mainColor,
                                                                ),
                                                              ),
                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color:
                                                                      mainColor,
                                                                ),
                                                              ),
                                                              suffixIcon:
                                                                  InkWell(
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      w * 0.07,
                                                                  width:
                                                                      w * 0.07,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color:
                                                                        mainColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            150),
                                                                  ),
                                                                  child: Icon(
                                                                    Icons
                                                                        .arrow_forward,
                                                                    color: Colors
                                                                        .white,
                                                                    size: w *
                                                                        0.04,
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  _focusNode
                                                                      .unfocus();
                                                                  _focusNode
                                                                          .canRequestFocus =
                                                                      false;
                                                                  checkCoupon =
                                                                      1;
                                                                  if (_formKey
                                                                      .currentState!
                                                                      .validate()) {
                                                                    dialog(
                                                                        context);
                                                                    setCoupon(
                                                                            context,
                                                                            _controller
                                                                                .text,
                                                                            cart
                                                                                .subTotal)
                                                                        .then(
                                                                            (value) {
                                                                      Navigator.pop(
                                                                          context);
                                                                      if (value ==
                                                                          1) {
                                                                        Navigator.pop(
                                                                            context);
                                                                      } else {
                                                                        if (_formKey
                                                                            .currentState!
                                                                            .validate()) {}
                                                                      }
                                                                    });
                                                                  }
                                                                },
                                                              ),
                                                              suffixIconConstraints:
                                                                  BoxConstraints(
                                                                maxHeight:
                                                                    w * 0.1,
                                                                maxWidth:
                                                                    w * 0.1,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ).then((value) {
                                          setState(() {});
                                        });
                                      },
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        translate(context, 'cart', 'price'),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: w * 0.05),
                                      ),
                                      Text(
                                        getProductprice(
                                            currency: currency,
                                            productPrice: cart.subTotal),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: w * 0.05),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: h * 0.03,
                                  ),
                                  if (login)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          translate(
                                              context, 'cart', 'delivery'),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: w * 0.05),
                                        ),
                                        if (address != null)
                                          Text(
                                            getProductprice(
                                                currency: currency,
                                                productPrice: getAreaPrice(
                                                    address.areaId)),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: w * 0.05),
                                          ),
                                        if (address == null)
                                          Text(
                                            getProductprice(
                                                currency: currency,
                                                productPrice: cart.delivery),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: w * 0.05),
                                          ),
                                      ],
                                    ),
                                  if (!login)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          translate(
                                              context, 'cart', 'delivery'),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: w * 0.05),
                                        ),
                                        if (addressGuest != null)
                                          Text(
                                            getProductprice(
                                                currency: currency,
                                                productPrice: getAreaPrice(
                                                    addressGuest!.areaId)),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: w * 0.05),
                                          ),
                                        if (addressGuest == null)
                                          Text(
                                            getProductprice(
                                                currency: currency,
                                                productPrice: cart.delivery),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: w * 0.05),
                                          ),
                                      ],
                                    ),
                                  SizedBox(
                                    height: h * 0.03,
                                  ),
                                  (deliveryDays != 0)
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              translateString('Delivery Time',
                                                  'مدة التوصيل'),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: w * 0.05),
                                            ),
                                            Text(
                                              translateString(
                                                  "$deliveryDays Days",
                                                  "$deliveryDays يوم"),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: w * 0.05),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                  (deliveryDays != 0)
                                      ? SizedBox(
                                          height: h * 0.03,
                                        )
                                      : const SizedBox(),
                                  if (couponPrice != 0.0 &&
                                      maxCopounLimit < cart.subTotal)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          translate(
                                              context, 'cart', 'discount'),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: w * 0.05),
                                        ),
                                        Text(
                                          '${maxDiscount(price: cart.subTotal)} $currency',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: w * 0.05),
                                        ),
                                      ],
                                    ),
                                  if (couponPrice != 0.0)
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          translate(context, 'cart', 'total'),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: w * 0.05),
                                        ),
                                        if (address != null)
                                          Text(
                                            '${(getprice(currency: currency, productPrice: cart.total) + getprice(currency: currency, productPrice: getAreaPrice(address.areaId)) - maxDiscount(price: cart.total))} $currency',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: w * 0.055,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        if (address == null)
                                          Text(
                                            '${(getprice(currency: currency, productPrice: cart.total) - maxDiscount(price: cart.total))} $currency',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: w * 0.055,
                                                fontWeight: FontWeight.bold),
                                          ),
                                      ],
                                    ),
                                  if (!login)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          translate(context, 'cart', 'total'),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: w * 0.05),
                                        ),
                                        if (addressGuest != null)
                                          Text(
                                            '${(getprice(currency: currency, productPrice: cart.total) + getprice(currency: currency, productPrice: getAreaPrice(addressGuest!.areaId)) - (couponPercentage ? double.parse((getprice(currency: currency, productPrice: cart.subTotal) * getprice(currency: currency, productPrice: couponPrice) / 100).toStringAsFixed(2)) : getprice(currency: currency, productPrice: couponPrice)))} $currency',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: w * 0.055,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        if (addressGuest == null)
                                          Text(
                                            '${(getprice(currency: currency, productPrice: cart.total) - (couponPercentage ? double.parse((getprice(currency: currency, productPrice: cart.subTotal) * couponPrice / 100).toStringAsFixed(2)) : getprice(currency: currency, productPrice: couponPrice)))} $currency',
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
                        ],
                      ),
                    ),
                    if (login)
                      address == null
                          ? InkWell(
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
                                        translate(context, 'cart', 'address'),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w * 0.05),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => ChooseAddress()))
                                    .then((value) {
                                  setState(() {});
                                });
                              },
                            )
                          : InkWell(
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
                                        translate(context, 'buttons', 'cont'),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w * 0.05),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                getdeliveryDays();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => ConfirmCart(
                                          deliveryDays: deliveryDays,
                                          maxCopounLimit: maxCopounLimit,
                                          couponPrice:
                                              (maxCopounLimit < cart.subTotal)
                                                  ? couponPrice
                                                  : 0.0,
                                          couponName: couponName,
                                          couponPercentage: couponPercentage,
                                        )),
                                  ),
                                );
                              },
                            ),
                    if (!login)
                      addressGuest == null
                          ? InkWell(
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
                                        translate(context, 'cart', 'address'),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w * 0.05),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) =>
                                            AddAddress(false))).then((value) {
                                  setState(() {});
                                });
                              },
                            )
                          : InkWell(
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
                                        translate(context, 'buttons', 'cont'),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w * 0.05),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                getdeliveryDays();
                                navP(
                                    context,
                                    ConfirmCart(
                                        deliveryDays: deliveryDays,
                                        maxCopounLimit: maxCopounLimit,
                                        couponPrice: couponPrice,
                                        couponName: couponName,
                                        couponPercentage: couponPercentage));
                              },
                            ),
                  ],
                ))
            : SingleChildScrollView(
                child: Column(
                children: [
                  SizedBox(
                    height: h * 0.1,
                  ),
                  SizedBox(
                      width: w * 0.5,
                      height: h * 0.3,
                      child: Image.asset("assets/icons/3.png",
                          fit: BoxFit.contain, color: mainColor)),
                  Text(
                    translate(context, 'empty', 'empty_cart'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: w * 0.07,
                    ),
                  ),
                  Text(
                    translate(context, 'cart', 'visit'),
                    style: TextStyle(fontSize: w * 0.04, color: Colors.grey),
                  ),
                  SizedBox(
                    height: h * 0.15,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: w * 0.05,
                      right: w * 0.05,
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          child: Container(
                            height: h * 0.08,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: mainColor,
                            ),
                            child: Center(
                              child: Text(
                                translate(context, 'buttons', 'add_product'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: w * 0.045,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          height: h * 0.07,
                        ),
                      ],
                    ),
                  )
                ],
              )),
      ),
    );
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

InputBorder form() {
  return OutlineInputBorder(
    borderSide: BorderSide(color: mainColor, width: 1.5),
    borderRadius: BorderRadius.circular(5),
  );
}
