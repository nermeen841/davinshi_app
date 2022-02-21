// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:davinshi_app/dbhelper.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/cart.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/home_item.dart';
import 'package:davinshi_app/models/products_cla.dart';
import 'package:davinshi_app/provider/CatProvider.dart';
import 'package:davinshi_app/provider/cart_provider.dart';
import 'package:davinshi_app/screens/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoreScreen extends StatefulWidget {
  final dynamic products;

  const MoreScreen({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen>
    with SingleTickerProviderStateMixin {
  DbHelper helper = DbHelper();
  // late AnimationController animationController;
  // late Animation<Color> buttonColor;
  List<int> att = [];
  List<String> des = [];
  // late Animation<double> animationIcon;
  // late Animation<double> translateButton;
  // late int selectedIndex;
  // Curve curve = Curves.easeOut;
  // int _counter = 1;
  // @override
  // void initState() {
  //   animationController = AnimationController(
  //       vsync: this, duration: const Duration(microseconds: 500))
  //     ..addListener(() {
  //       setState(() {});
  //     })
  //     ..addStatusListener((status) {
  //       if (status == AnimationStatus.completed) {
  //         setState(() {
  //           // TabOne.isOpened = true;
  //         });
  //       } else if (status == AnimationStatus.dismissed) {
  //         setState(() {
  //           // TabOne.isOpened = false;
  //         });
  //       }
  //     });
  //   animationIcon =
  //       Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
  //   translateButton = Tween<double>(begin: 0.0, end: 30.0).animate(
  //       CurvedAnimation(
  //           parent: animationController,
  //           curve: Interval(0.00, 0.75, curve: curve)));
  //   super.initState();
  // }

  // animate({required int productId}) {
  //   if (TabOne.isOpened[productId] == true) {
  //     animationController.forward();
  //   } else {
  //     animationController.reverse();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    var currency = (prefs.getString('language_code').toString() == 'en')
        ? prefs.getString('currencyEn').toString()
        : prefs.getString('currencyAr').toString();

    CatProvider catProvider = Provider.of<CatProvider>(context, listen: false);
    CartProvider cart = Provider.of<CartProvider>(context, listen: true);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Directionality(
        textDirection: getDirection(),
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Container(
                width: w * 0.1,
                height: h * 0.05,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/logo2.png'),
                      fit: BoxFit.fitHeight),
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.black,
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: w * 0.01),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    // child: Icon(Icons.search,color: Colors.white,size: w*0.05,),
                    child: Badge(
                      badgeColor: mainColor,
                      child: IconButton(
                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.zero,
                        focusColor: Colors.white,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Cart()));
                        },
                      ),
                      animationDuration: const Duration(
                        seconds: 2,
                      ),
                      badgeContent: Text(
                        cart.items.length.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.03,
                        ),
                      ),
                      position: BadgePosition.topStart(start: w * 0.007),
                    ),
                  ),
                ),
                SizedBox(
                  width: w * 0.01,
                ),
              ],
            ),
            body: SizedBox(
              child: ListView(
                primary: true,
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: h * 0.03,
                  ),
                  GridView.builder(
                    // scrollDirection: Axis.horizontal,
                    itemCount: widget.products.length,
                    itemBuilder: (ctx, i) {
                      return InkWell(
                          child: Padding(
                            padding: isLeft()
                                ? EdgeInsets.only(left: w * 0.025)
                                : EdgeInsets.only(right: w * 0.025),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: w * 0.5,
                                  height: h * 0.25,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          widget.products[i].image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(w * 0.015),
                                    child: Align(
                                      alignment: isLeft()
                                          ? Alignment.bottomLeft
                                          : Alignment.bottomRight,
                                      child: InkWell(
                                        onTap: () async {
                                          if (cartId == null ||
                                              cartId == studentId) {
                                            try {
                                              if (!cart.idp
                                                  .contains(bestDis[i].id)) {
                                                await helper.createCar(
                                                    CartProducts(
                                                        id: null,
                                                        studentId: studentId,
                                                        image: widget
                                                            .products[i].image,
                                                        titleAr: widget
                                                            .products[i].nameAr,
                                                        titleEn: widget
                                                            .products[i].nameEn,
                                                        price: widget
                                                            .products[i]
                                                            .finalPrice
                                                            .toDouble(),
                                                        quantity: 1,
                                                        att: att,
                                                        des: des,
                                                        idp: widget
                                                            .products[i].id,
                                                        idc: 0,
                                                        catNameEn: "",
                                                        catNameAr: "",
                                                        catSVG: ""));
                                              } else {
                                                int quantity = cart.items
                                                    .firstWhere((element) =>
                                                        element.idp ==
                                                        widget.products[i].id)
                                                    .quantity;
                                                await helper.updateProduct(
                                                    1 + quantity,
                                                    widget.products[i].id,
                                                    widget
                                                        .products[i].finalPrice
                                                        .toDouble(),
                                                    jsonEncode(att),
                                                    jsonEncode(des));
                                              }
                                              await cart.setItems();
                                            } catch (e) {
                                              print('e');
                                              print(e);
                                            }
                                          } else {
                                            if (cartId == null ||
                                                cartId == studentId) {
                                              try {
                                                if (!cart.idp
                                                    .contains(topRate[i].id)) {
                                                  await helper.createCar(
                                                      CartProducts(
                                                          id: null,
                                                          studentId: widget
                                                              .products[i]
                                                              .brands![i]
                                                              .id,
                                                          image: widget
                                                              .products[i]
                                                              .image,
                                                          titleAr: widget
                                                              .products[i]
                                                              .nameAr,
                                                          titleEn: widget
                                                              .products[i]
                                                              .nameEn,
                                                          price: widget
                                                              .products[i].price
                                                              .toDouble(),
                                                          quantity: 1,
                                                          att: att,
                                                          des: des,
                                                          idp: widget
                                                              .products[i].id,
                                                          idc: widget
                                                              .products[i].id,
                                                          catNameEn: "",
                                                          catNameAr: "",
                                                          catSVG: ""));
                                                } else {
                                                  int quantity = cart.items
                                                      .firstWhere((element) =>
                                                          element.idp ==
                                                          widget.products[i].id)
                                                      .quantity;
                                                  await helper.updateProduct(
                                                      1 + quantity,
                                                      widget.products[i].id,
                                                      widget.products[i]
                                                          .finalPrice
                                                          .toDouble(),
                                                      jsonEncode(att),
                                                      jsonEncode(des));
                                                }
                                                await cart.setItems();
                                              } catch (e) {
                                                print('e');
                                                print(e);
                                              }
                                            } else {}
                                          }
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: mainColor,
                                          radius: w * .05,
                                          child: Center(
                                            child: Icon(
                                              Icons.shopping_cart_outlined,
                                              color: Colors.white,
                                              size: w * 0.05,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: w * 0.4,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: h * 0.01,
                                      ),
                                      Container(
                                          constraints: BoxConstraints(
                                            maxHeight: h * 0.07,
                                          ),
                                          child: Text(
                                              translateString(
                                                  widget.products[i].nameEn,
                                                  widget.products[i].nameAr),
                                              style: TextStyle(
                                                  fontSize: w * 0.035),
                                              overflow: TextOverflow.fade)),
                                      SizedBox(
                                        height: h * 0.005,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                if (widget.products[i].isSale)
                                                  TextSpan(
                                                      text:
                                                          '${widget.products[i].salePrice} $currency ',
                                                      style: TextStyle(
                                                          fontFamily: 'Tajawal',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: mainColor)),
                                                if (!widget.products[i].isSale)
                                                  TextSpan(
                                                      text:
                                                          '${widget.products[i].price} $currency',
                                                      style: TextStyle(
                                                          fontFamily: 'Tajawal',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: mainColor)),
                                              ],
                                            ),
                                          ),
                                          // if (widget.products[i].isSale &&
                                          //     widget.products[i].disPer != null)
                                          //   Text(widget.products[i].disPer! + '%',
                                          //       style: const TextStyle(
                                          //           fontWeight:
                                          //               FontWeight.bold,
                                          //           color: Colors.red)),
                                          if (widget.products[i].isSale)
                                            Text(
                                              '${widget.products[i].price} $currency',
                                              style: TextStyle(
                                                fontSize: w * 0.035,
                                                decorationColor: mainColor,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.grey,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            dialog(context);
                            await getItem(widget.products[i].id);
                            Navigator.pushReplacementNamed(context, 'pro');
                          });
                    },
                    primary: false,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: h * 0.001,
                        mainAxisSpacing: w * 0.05,
                        crossAxisCount: 2,
                        childAspectRatio: 0.8),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
