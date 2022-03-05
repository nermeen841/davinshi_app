// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'dart:convert';
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
  bool couponPercentage = false;
  final FocusNode _focusNode = FocusNode();
  DbHelper dbHelper = DbHelper();
  Future<int> setCoupon(context, coupon, price) async {
    final String url2 = domain +
        'check-coupon?coupon_code=$coupon&order_price=$price&brand_id=$cartId';
    try {
      Response response = await Dio().post(url2);
      if (response.data['status'] == 1) {
        couponName = coupon;
        couponPercentage =
            response.data['data']['type_discount'] == 'percentage'
                ? true
                : false;
        checkCoupon = 1;
        couponPrice = num.parse(response.data['data']['discount'].toString());
        return 1; // success
      }
      // if(response.data['status']==0&&response.data['message']=='The total price of the order must be at least 100  $currency'){
      //   errorCoupon = response.data['message'];
      //   checkCoupon = 5;
      //   return 5; // min price
      // }
      // if(response.data['status']==0&&response.data['message']=='coupon not found'){
      //   errorCoupon = response.data['message'];
      //   checkCoupon = 2;
      //   return 2; // cant find
      // }
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

  // Future checkOut(context)async{
  //   final String url2 = domain+'save-order';
  //   CartProvider _cart = Provider.of<CartProvider>(context,listen: false);
  //   AddressClass? address = Provider.of<AddressProvider>(context,listen: false).addressCart;
  //   Map data = login?{
  //     "name" :address!.name,
  //     "phone" :address.phone1,
  //     "email" :address.email,
  //     "address_d" :address.country,
  //     "note" :address.note,
  //     "area_id" : address.areaId,
  //     "address" : address.address,
  //     "products_id" : _cart.idProducts,
  //     "quantity_products" : _cart.quan,
  //     "optionValue_products" : _cart.op,
  //     "shipping_address_id" : address.id,
  //     "student_id" : _cart.st,
  //     "lat_and_long" : address.lat.toString()+','+address.long.toString(),
  //     "coupon_code" : couponName,
  //   }:{
  //     "name" :addressGuest!.name,
  //     "phone" :addressGuest!.phone1,
  //     "address_d" :addressGuest!.country,
  //     "email" :addressGuest!.email,
  //     "note" :addressGuest!.note,
  //     "area_id" : addressGuest!.areaId,
  //     "address" : addressGuest!.address,
  //     "products_id" : _cart.idProducts,
  //     "quantity_products" : _cart.quan,
  //     "optionValue_products" : _cart.op,
  //     "shipping_address_id" : 0,
  //     "student_id" : _cart.st,
  //     "lat_and_long" : addressGuest!.lat.toString()+','+addressGuest!.long.toString(),
  //     "coupon_code" : couponName,
  //   };
  //   print(data);
  //   if(couponName==null){
  //     data.remove('coupon_code');
  //   }
  //   if(!login){
  //     data.remove('shipping_address_id');
  //   }
  //   try {
  //     Response response = await Dio().post(url2,data: data,
  //       options: Options(
  //           headers: login?{
  //             "auth-token" : auth
  //           }:null
  //       ),
  //     );
  //     if(response.data['status']==1){
  //       if(login){
  //         await getOrders().then((value) {
  //           Provider.of<CartProvider>(context,listen: false).clearAll();
  //           if(value){
  //             dbHelper.deleteAll();
  //             navPR(context, Orders());
  //             return null;
  //           }else{
  //             navPop(context);
  //             print('asdss1');
  //             error(context);
  //             return null;
  //           }
  //         });
  //       }else{
  //         navPop(context);
  //         dbHelper.deleteAll();
  //         Provider.of<CartProvider>(context,listen: false).clearAll();
  //         alertSuccessCart(context);
  //         return null;
  //       }
  //     }
  //     if(response.data['status']==0){
  //       navPop(context);
  //       String data ='';
  //       if(response.data['message'] is List){
  //         if(language=='en'){
  //           response.data['message'].forEach((e){
  //             data += e + '\n';
  //           });
  //         }else{
  //           response.data['message'].forEach((e){
  //             data += e + '\n';
  //           });
  //         }
  //       }
  //       print('hamza');
  //       print(response.data);
  //       print(response.data['message']);
  //       customError(context,response.data['message'] is List ?data:response.data['order']);
  //       return null;
  //     }
  //   } catch (e) {
  //     print('error $e');
  //     // navPop(context);
  //     error(context);
  //   }
  //
  // }
  @override
  void initState() {
    super.initState();
    idProducts = Provider.of<CartProvider>(context, listen: false).idp;
  }

  var currency = (prefs.getString('language_code').toString() == 'en')
      ? prefs.getString('currencyEn').toString()
      : prefs.getString('currencyAr').toString();
  @override
  Widget build(BuildContext context) {
    CartProvider cart = Provider.of<CartProvider>(context, listen: true);
    AddressClass? address =
        Provider.of<AddressProvider>(context, listen: false).addressCart;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                                                            '${_pro.price} $currency',
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
                                                                            jsonEncode(_pro.des));
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
                                                                      await dbHelper.updateProduct(
                                                                          _pro.quantity +
                                                                              1,
                                                                          _pro
                                                                              .idp,
                                                                          _pro.price
                                                                              .toDouble(),
                                                                          jsonEncode(_pro
                                                                              .att),
                                                                          jsonEncode(
                                                                              _pro.des));
                                                                      cart.setItems();
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
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: w*0.05),
                          //   child: SizedBox(
                          //     width: w*0.9,
                          //     child: TextFormField(
                          //       controller: controller,
                          //       cursorColor: Colors.black,
                          //       maxLines: 5,
                          //       minLines: 1,
                          //       decoration: InputDecoration(
                          //         focusedBorder: form(),
                          //         enabledBorder: form(),
                          //         errorBorder: form(),
                          //         focusedErrorBorder: form(),
                          //         hintText: ' Note (optional)',
                          //         hintStyle: const TextStyle(color: Colors.grey),
                          //         floatingLabelBehavior:FloatingLabelBehavior.never,
                          //         errorMaxLines: 1,
                          //         errorStyle: TextStyle(fontSize: w*0.03),
                          //         contentPadding: EdgeInsets.symmetric(horizontal: w*0.01),
                          //       ),
                          //       keyboardType: TextInputType.multiline,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(height: h*0.02,),
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
                                        '${cart.subTotal} $currency',
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
                                            '${getAreaPrice(address.areaId)} $currency',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: w * 0.05),
                                          ),
                                        if (address == null)
                                          Text(
                                            '${cart.delivery} $currency',
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
                                            '${getAreaPrice(addressGuest!.areaId)} $currency',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: w * 0.05),
                                          ),
                                        if (addressGuest == null)
                                          Text(
                                            '${cart.delivery} $currency',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: w * 0.05),
                                          ),
                                      ],
                                    ),
                                  SizedBox(
                                    height: h * 0.03,
                                  ),
                                  if (couponPrice != 0.0)
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
                                          '${couponPercentage ? double.parse((cart.subTotal * couponPrice / 100).toStringAsFixed(2)) : couponPrice} $currency',
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
                                            '${(cart.total + getAreaPrice(address.areaId) - (couponPercentage ? double.parse((cart.subTotal * couponPrice / 100).toStringAsFixed(2)) : couponPrice))} $currency',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: w * 0.055,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        if (address == null)
                                          Text(
                                            '${(cart.total - (couponPercentage ? double.parse((cart.subTotal * couponPrice / 100).toStringAsFixed(2)) : couponPrice))} $currency',
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
                                            '${(cart.total + getAreaPrice(addressGuest!.areaId) - (couponPercentage ? double.parse((cart.subTotal * couponPrice / 100).toStringAsFixed(2)) : couponPrice))} $currency',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: w * 0.055,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        if (addressGuest == null)
                                          Text(
                                            '${(cart.total - (couponPercentage ? double.parse((cart.subTotal * couponPrice / 100).toStringAsFixed(2)) : couponPrice))} $currency',
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
                                // dialog(context);
                                // checkOut(context);
                                navP(
                                    context,
                                    ConfirmCart(
                                      couponPrice: couponPrice,
                                      couponName: couponName,
                                      couponPercentage: couponPercentage,
                                    ));
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
                                // dialog(context);
                                // checkOut(context);
                                navP(
                                    context,
                                    ConfirmCart(
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
    // return GestureDetector(
    //   onTap: () {
    //     FocusScope.of(context).requestFocus(new FocusNode());
    //   },
    //   child: cart.items.isNotEmpty?Directionality(
    //     textDirection: getDirection(),
    //     child: Scaffold(
    //       backgroundColor: Colors.white,
    //       appBar: AppBar(
    //         backgroundColor: Colors.white,
    //         title: SizedBox(child: Text('Cart',style: TextStyle(color:mainColor,fontSize: w*0.05,),),),
    //         leading: BackButton(color: mainColor,),
    //         centerTitle: true,
    //         actions: [
    //           IconButton(
    //             icon: Icon(Icons.delete,),
    //             padding: EdgeInsets.zero,
    //             focusColor: Colors.transparent,
    //             color: Colors.red,
    //             onPressed: ()async{
    //               await dbHelper.deleteAll();
    //               cart.setItems();
    //             },
    //           ),
    //           SizedBox(width: w*0.04,),
    //         ],
    //         elevation: 0,
    //       ),
    //       body: SingleChildScrollView(
    //           child: Column(
    //             children: [
    //               Column(
    //                 children: List.generate(cart.items.length, (index) {
    //                   String _add = '';
    //                   cart.items[index].des.forEach((e) {
    //                     _add = _add + e + ' ';
    //                   });
    //                   return Column(
    //                     crossAxisAlignment: CrossAxisAlignment.center,
    //                     children: [
    //                       SizedBox(height: h*0.01,),
    //                       Container(
    //                         width: w*0.9,
    //                         child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                           children: [
    //                             Container(
    //                               width: w*0.5,
    //                               child: Column(
    //                                 crossAxisAlignment: CrossAxisAlignment.start,
    //                                 mainAxisSize: MainAxisSize.min,
    //                                 mainAxisAlignment: MainAxisAlignment.center,
    //                                 children: [
    //                                   Text(cart.items[index].titleEn,style: TextStyle(fontWeight: FontWeight.bold,fontSize: w*0.04),),
    //                                   Text(cart.items[index].price.toString() + 'KWD',style: TextStyle(fontSize: w*0.035,color: Colors.grey),),
    //                                   Text(_add,style: TextStyle(fontSize: w*0.035,color: Colors.grey),),
    //                                   SizedBox(height: h*0.01,),
    //                                   Container(
    //                                     child: Row(
    //                                       mainAxisAlignment: MainAxisAlignment.start,
    //                                       children: [
    //                                         Container(
    //                                           width: w*0.15,
    //                                           height: h*0.05,
    //                                           decoration: BoxDecoration(
    //                                             borderRadius: BorderRadius.circular(50),
    //                                             color: mainColor,
    //                                           ),
    //                                           // child: Icon(Icons.add,size: w*0.03,color: Colors.white,),
    //                                           child: IconButton(
    //                                             icon: Icon(Icons.add),
    //                                             padding: EdgeInsets.zero,
    //                                             iconSize: w*0.03,
    //                                             color: Colors.white,
    //                                             onPressed: ()async{
    //                                               await dbHelper.updateProduct(cart.items[index].quantity+1, cart.items[index].idp);
    //                                               cart.setItems();
    //                                             },
    //                                           ),
    //                                         ),
    //                                         SizedBox(width: w*0.02,),
    //                                         Container(
    //                                             width: w*0.15,
    //                                             height: h*0.05,
    //                                             decoration: BoxDecoration(
    //                                               borderRadius: BorderRadius.circular(50),
    //                                               border: Border.all(color: mainColor,width: 1),
    //                                               color: Colors.white,
    //                                             ),
    //                                             child: Center(child: Text(cart.items[index].quantity.toString(),style: TextStyle(color: mainColor,fontSize: w*0.04,fontFamily: DefaultTextStyle.of(context).style.fontFamily,),))
    //                                         ),
    //                                         SizedBox(width: w*0.02,),
    //                                         Container(
    //                                           width: w*0.15,
    //                                           height: h*0.05,
    //                                           decoration: BoxDecoration(
    //                                             borderRadius: BorderRadius.circular(50),
    //                                             color: mainColor,
    //                                           ),
    //                                           child: IconButton(
    //                                             icon: Icon(Icons.remove),
    //                                             padding: EdgeInsets.zero,
    //                                             iconSize: w*0.03,
    //                                             color: Colors.white,
    //                                             onPressed: ()async{
    //                                               if(cart.items[index].quantity>1){
    //                                                 await dbHelper.updateProduct(cart.items[index].quantity-1, cart.items[index].idp);
    //                                               }else{
    //                                                 await dbHelper.deleteProduct(cart.items[index].id!);
    //                                               }
    //                                               cart.setItems();
    //                                             },
    //                                           ),
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ),
    //                             Container(
    //                               width: w*0.2,
    //                               height: h*0.12,
    //                               decoration: BoxDecoration(
    //                                 color: Colors.grey[200],
    //                                 borderRadius: BorderRadius.circular(15),
    //                                 image: DecorationImage(
    //                                   // image: AssetImage('assets/ice2.png'),
    //                                   image: NetworkImage(cart.items[index].image),
    //                                   fit: BoxFit.cover,
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                       SizedBox(height: h*0.02,),
    //                       index!=cart.items.length-1?Padding(
    //                         padding:  EdgeInsets.only(right: w*0.05,left: w*0.05),
    //                         child: Divider(thickness: h*0.001,color: Colors.grey[400],),
    //                       ):SizedBox(),
    //                     ],
    //                   );
    //                 }),
    //               ),
    //               // if(userId!=0)Container(
    //               //   height: h*0.1,
    //               //   color: Colors.grey[200],
    //               //   child: Center(
    //               //     child: Padding(
    //               //       padding:  EdgeInsets.only(right: w*0.05,left: w*0.05),
    //               //       child: Row(
    //               //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               //         children: [
    //               //           Text('Add Coupon',style: TextStyle(fontSize: w*0.03),),
    //               //           InkWell(
    //               //             child: Text('Coupon',style: TextStyle(fontSize: w*0.03,color: Colors.grey),),
    //               //             onTap: (){
    //               //               showDialog(
    //               //                 context: context,
    //               //                 builder: (BuildContext context) {
    //               //                   final TextEditingController _controller = TextEditingController();
    //               //                   bool valid = true;
    //               //                   return Directionality(
    //               //                     textDirection: getDirection(),
    //               //                     child: AlertDialog(
    //               //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
    //               //                       content: Container(
    //               //                         height: h*0.16,
    //               //                         width: w*0.95,
    //               //                         child: StatefulBuilder(
    //               //                           builder: (BuildContext context, StateSetter setState) {
    //               //                             return Center(
    //               //                               child: Form(
    //               //                                 key: _formKey,
    //               //                                 child: Container(
    //               //                                   child: TextFormField(
    //               //                                     cursorColor: Colors.black,
    //               //                                     focusNode: _focusNode,
    //               //                                     controller: _controller,
    //               //                                     keyboardType: TextInputType.number,
    //               //                                     validator: (val){
    //               //                                       if(valid!=true){
    //               //                                         return 'Invalid Coupon';
    //               //                                       }
    //               //                                       if(val!.isEmpty){
    //               //                                         return 'Enter Coupon';
    //               //                                       }
    //               //                                       return null;
    //               //                                     },
    //               //                                     decoration: InputDecoration(
    //               //                                       hintText: 'Coupon',
    //               //                                       hintStyle: TextStyle(color:mainColor,),
    //               //                                       enabledBorder: UnderlineInputBorder(
    //               //                                         borderSide: BorderSide(color: mainColor,),
    //               //                                       ),
    //               //                                       focusedBorder: UnderlineInputBorder(
    //               //                                         borderSide: BorderSide(color: mainColor,),
    //               //                                       ),
    //               //                                       suffixIcon: InkWell(
    //               //                                         child: Container(
    //               //                                           height: w*0.07,
    //               //                                           width: w*0.07,
    //               //                                           decoration: BoxDecoration(
    //               //                                             color: mainColor,
    //               //                                             borderRadius: BorderRadius.circular(150),
    //               //                                           ),
    //               //                                           child: Icon(Icons.arrow_forward,color: Colors.white,size: w*0.04,),
    //               //                                         ),
    //               //                                         onTap: (){
    //               //                                           _focusNode.unfocus();
    //               //                                           _focusNode.canRequestFocus = false;
    //               //                                           valid = true;
    //               //                                           if (_formKey.currentState!.validate()) {
    //               //                                             dialog(context);
    //               //                                             checkCoupon(context, _controller.text).then((value) {
    //               //                                               Navigator.pop(context);
    //               //                                               if(value){
    //               //                                                 Navigator.pop(context);
    //               //                                               }else{
    //               //                                                 valid = false;
    //               //                                                 if(_formKey.currentState!.validate()){
    //               //                                                 }
    //               //                                               }
    //               //                                             });
    //               //                                           }
    //               //                                         },
    //               //                                       ),
    //               //                                       suffixIconConstraints: BoxConstraints(
    //               //                                         maxHeight: w*0.1,
    //               //                                         maxWidth: w*0.1,
    //               //                                       ),
    //               //                                     ),
    //               //                                   ),
    //               //                                 ),
    //               //                               ),
    //               //                             );
    //               //                           },
    //               //                         ),
    //               //                       ),
    //               //                     ),
    //               //                   );
    //               //                 },
    //               //               );
    //               //             },
    //               //           ),
    //               //         ],
    //               //       ),
    //               //     ),
    //               //   ),
    //               // ),
    //               // if(userId!=0)SizedBox(height: h*0.02,),
    //               Align(
    //                 alignment: Alignment.centerLeft,
    //                 child: Padding(
    //                   padding: EdgeInsets.only(left: w*0.05),
    //                   child: Text('Payment',style: TextStyle(fontWeight: FontWeight.bold,fontSize: w*0.05),),
    //                 ),
    //               ),
    //               SizedBox(height: h*0.01,),
    //               Padding(
    //                 padding:  EdgeInsets.only(left: w*0.05,right: w*0.05,),
    //                 child: Column(
    //                   children: [
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: [
    //                         Text('SubTotal',style: TextStyle(fontSize: w*0.04),),
    //                         Text('KWD'+' '+cart.subTotal.toString(),style: TextStyle(fontSize: w*0.04,color: mainColor,),),
    //                       ],
    //                     ),
    //                     // SizedBox(height: h*0.01,),
    //                     // Row(
    //                     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     //   children: [
    //                     //     Text('Delivery',style: TextStyle(fontSize: w*0.04),),
    //                     //     Text('KWD'+' '+ca.cart[0].deliveryCharge.toString(),style: TextStyle(fontSize: w*0.04,color: mainColor,),),
    //                     //   ],
    //                     // ),
    //                     // if(disPrice!=0)SizedBox(height: h*0.01,),
    //                     // if(disPrice!=0)Row(
    //                     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     //   children: [
    //                     //     Text('Discount',style: TextStyle(fontSize: w*0.04),),
    //                     //     Text('KWD'+' '+disPrice.toString(),style: TextStyle(fontSize: w*0.04,color: Colors.red,),),
    //                     //   ],
    //                     // ),
    //                     Divider(thickness: h*0.001,color: Colors.grey[400],),
    //                     SizedBox(height: h*0.02,),
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: [
    //                         Text('Total',style: TextStyle(fontSize: w*0.045,fontWeight: FontWeight.bold),),
    //                         Text('KWD'+' '+(cart.subTotal).toString(),style: TextStyle(fontSize: w*0.045,color: mainColor,fontWeight: FontWeight.bold),),
    //                       ],
    //                     ),
    //                     SizedBox(height: h*0.07,),
    //                     InkWell(
    //                       child: Container(
    //                         height: h*0.08,
    //                         decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(25),
    //                           color: mainColor,
    //                         ),
    //                         child: Center(
    //                           child: Text('CheckOut',style: TextStyle(color: Colors.white,fontSize: w*0.045,fontWeight: FontWeight.bold),),
    //                         ),
    //                       ),
    //                       onTap: (){
    //                         // if(Provider.of<AddressProvider>(context,listen: false).addressName!=null){
    //                         //   Navigator.pushNamed(context, 'ConfirmCart');
    //                         // }else{
    //                         //   Navigator.push(context, MaterialPageRoute(builder: (context)=>AddAddress(false,false)));
    //                         // }
    //                       },
    //                     ),
    //                     SizedBox(height: h*0.02,),
    //                     InkWell(
    //                       child: Container(
    //                         height: h*0.08,
    //                         decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(25),
    //                           color: Colors.white,
    //                           border: Border.all(color: mainColor,),
    //                         ),
    //                         child: Center(
    //                           child: Text('Add More',style: TextStyle(color: mainColor,fontSize: w*0.045,fontWeight: FontWeight.bold),),
    //                         ),
    //                       ),
    //                       onTap: (){
    //                         //Navigator.push(context, MaterialPageRoute(builder: (context)=>ResInfo(_vendor, _item)));
    //                         Navigator.pop(context);
    //                       },
    //                     ),
    //                     SizedBox(height: h*0.07,),
    //                   ],
    //                 ),
    //               )
    //             ],
    //           )
    //       ),
    //     ),
    //   ):
    //   Directionality(
    //     textDirection: TextDirection.rtl,
    //     child: Scaffold(
    //       backgroundColor: Colors.white,
    //       appBar: AppBar(
    //         backgroundColor: Colors.white,
    //         title: Text('Cart', style: TextStyle(fontSize: w * 0.05, color: Colors.black,fontWeight: FontWeight.bold),),
    //         leading: BackButton(color: mainColor,),
    //         centerTitle: true,
    //         elevation: 0,
    //       ),
    //       body: SingleChildScrollView(
    //           child: Column(
    //             children: [
    //               SizedBox(height: h*0.1,),
    //               Container(
    //                 width: w*0.5,
    //                 height: h*0.3,
    //                 decoration: BoxDecoration(
    //                   image: DecorationImage(
    //                     image: AssetImage('assets/nocart.png'),
    //                     fit: BoxFit.contain,
    //                   ),
    //                 ),
    //               ),
    //               Text('Empty Cart!',style: TextStyle(fontWeight: FontWeight.bold,fontSize: w*0.07,),),
    //               Text('Visite stores',style: TextStyle(fontSize: w*0.04,color: Colors.grey),),
    //               SizedBox(height: h*0.15,),
    //               Padding(
    //                 padding:  EdgeInsets.only(left: w*0.05,right: w*0.05,),
    //                 child: Column(
    //                   children: [
    //                     InkWell(
    //                       child: Container(
    //                         height: h*0.08,
    //                         decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(25),
    //                           color: mainColor,
    //                         ),
    //                         child: Center(
    //                           child: Text('Add Items',style: TextStyle(color: Colors.white,fontSize: w*0.045,fontWeight: FontWeight.bold),),
    //                         ),
    //                       ),
    //                       onTap: (){
    //                         Navigator.pop(context);
    //                       },
    //                     ),
    //                     SizedBox(height: h*0.07,),
    //                   ],
    //                 ),
    //               )
    //             ],
    //           )
    //       ),
    //     ),
    //   )
    // );
  }
}

// InputBorder form(){
//   return UnderlineInputBorder(
//     borderSide:  BorderSide(color: (Colors.grey[350]!),width: 1),
//     borderRadius: BorderRadius.circular(25),
//   );
// }
InputBorder form() {
  return OutlineInputBorder(
    borderSide: BorderSide(color: mainColor, width: 1.5),
    borderRadius: BorderRadius.circular(5),
  );
}
