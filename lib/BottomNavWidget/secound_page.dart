// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:davinshi_app/dbhelper.dart';
import 'package:davinshi_app/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:davinshi_app/screens/product_info/products.dart';
import 'package:provider/provider.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/products_cla.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/provider/cart_provider.dart';
import 'package:davinshi_app/provider/fav_pro.dart';
import 'package:davinshi_app/screens/cart/cart.dart';

// ignore: use_key_in_widget_constructors
class SecPage extends StatefulWidget {
  @override
  _SecPageState createState() => _SecPageState();
}

class _SecPageState extends State<SecPage> {
  ScrollController controller = ScrollController();
  bool mask = false;
  bool f1 = true;
  bool fi1 = true, finish = false;
  void start(context) async {
    var of1 = Provider.of<FavItemProvider>(context, listen: true);
    controller.addListener(() {
      if (controller.position.atEdge) {
        if (controller.position.pixels != 0) {
          if (f1) {
            if (!of1.finish) {
              f1 = false;
              dialog(context);
              of1.getItems().then((value) {
                Navigator.pop(context);
                f1 = true;
              });
            }
          }
        }
      }
      if (controller.position.pixels > 400.0 && mask == false) {
        setState(() {
          mask = true;
        });
        // scroll.changeShow(1, true);
      }
      if (controller.position.pixels < 400.0 && mask == true) {
        setState(() {
          mask = false;
        });
        // scroll.changeShow(1, false);
      }
    });
  }

  DbHelper helper = DbHelper();

  List<int> att = [];
  List<String> des = [];
  int quantity = 0;

  var currency = (prefs.getString('language_code').toString() == 'en')
      ? prefs.getString('currencyEn').toString()
      : prefs.getString('currencyAr').toString();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    CartProvider cart = Provider.of<CartProvider>(context, listen: true);
    if (!finish) {
      start(context);
      finish = true;
    }
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Directionality(
        textDirection: getDirection(),
        child: DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                translate(context, 'page_two', 'title'),
                style: TextStyle(color: Colors.white, fontSize: w * 0.04),
              ),
              centerTitle: true,
              backgroundColor: Colors.black,
              automaticallyImplyLeading: false,
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: w * 0.01),
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(10),
                    //   color: mainColor2,
                    // ),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Cart()));
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
                ),
                if (login)
                  SizedBox(
                    width: w * 0.05,
                  ),
                // if (login)
                //   IconButton(
                //     icon: const Icon(Icons.location_on_outlined),
                //     iconSize: w * 0.06,
                //     color: Colors.white,
                //     padding: EdgeInsets.zero,
                //     onPressed: () {
                //       Navigator.push(context,
                //           MaterialPageRoute(builder: (ctx) => Address()));
                //     },
                //   ),
              ],
            ),
            body: SizedBox(
              width: w,
              height: h,
              child: Stack(
                children: [
                  SizedBox(
                    width: w,
                    height: h,
                    child: Padding(
                      padding: EdgeInsets.all(w * 0.025),
                      child: SingleChildScrollView(
                        controller: controller,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: h * 0.01,
                            ),
                            Consumer<FavItemProvider>(
                              builder: (context, item, _) {
                                return DropdownButton<String>(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  iconEnabledColor: mainColor,
                                  iconDisabledColor: mainColor,
                                  iconSize: w * 0.08,
                                  hint: Text(
                                      translate(context, 'page_two', 'sort')),
                                  items:
                                      List.generate(item.sorts.length, (index) {
                                    return DropdownMenuItem(
                                      value: item.sorts[index],
                                      child: Column(
                                        children: [
                                          Text(
                                            (prefs.getString('language_code') ==
                                                    'en')
                                                ? item.sorts[index]
                                                : item.sortsAr[index],
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          Divider(
                                            color: mainColor,
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        item.sortList(index);
                                      },
                                    );
                                  }),
                                  onChanged: (val) {},
                                  value: item.sort,
                                );
                              },
                            ),
                            SizedBox(
                              height: h * 0.01,
                            ),
                            SizedBox(
                              width: w,
                              child: Consumer<FavItemProvider>(
                                  builder: (context, item, _) {
                                if (item.items.isEmpty) {
                                  return SizedBox(
                                    width: w,
                                    height: h * 0.5,
                                    child: Center(
                                      child: Text(
                                        translate(
                                            context, 'empty', 'no_favorite'),
                                        style: TextStyle(
                                            color: mainColor,
                                            fontSize: w * 0.05),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Wrap(
                                    children:
                                        List.generate(item.items.length, (i) {
                                      return InkWell(
                                        child: Padding(
                                          padding: isLeft()
                                              ? EdgeInsets.only(
                                                  right: w * 0.025,
                                                  bottom: h * 0.02)
                                              : EdgeInsets.only(
                                                  left: w * 0.025,
                                                  bottom: h * 0.02),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: w * 0.45,
                                                height: h * 0.28,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  image: DecorationImage(
                                                    image: NetworkImage(item
                                                        .items[i].image
                                                        .toString()),
                                                    // image: AssetImage('assets/food${i+1}.png'),
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.all(w * 0.015),
                                                  child: Align(
                                                    alignment: isLeft()
                                                        ? Alignment.bottomLeft
                                                        : Alignment.bottomRight,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        if (cartId == null ||
                                                            cartId ==
                                                                studentId) {
                                                          try {
                                                            if (!cart.idp
                                                                .contains(item
                                                                    .items[i]
                                                                    .id)) {
                                                              await helper.createCar(CartProducts(
                                                                  id: null,
                                                                  studentId:
                                                                      studentId,
                                                                  image: item
                                                                      .items[i]
                                                                      .image,
                                                                  titleAr: item
                                                                      .items[i]
                                                                      .nameAr,
                                                                  titleEn: item
                                                                      .items[i]
                                                                      .nameEn,
                                                                  price: item
                                                                      .items[i]
                                                                      .finalPrice
                                                                      .toDouble(),
                                                                  quantity: 1,
                                                                  att: att,
                                                                  des: des,
                                                                  idp: item
                                                                      .items[i]
                                                                      .id,
                                                                  idc: 0,
                                                                  catNameEn: "",
                                                                  catNameAr: "",
                                                                  catSVG: ""));
                                                            } else {
                                                              int quantity = cart
                                                                  .items
                                                                  .firstWhere((element) =>
                                                                      element
                                                                          .idp ==
                                                                      item
                                                                          .items[
                                                                              i]
                                                                          .id)
                                                                  .quantity;
                                                              await helper.updateProduct(
                                                                  1 + quantity,
                                                                  item.items[i]
                                                                      .id,
                                                                  item.items[i]
                                                                      .finalPrice
                                                                      .toDouble(),
                                                                  jsonEncode(
                                                                      att),
                                                                  jsonEncode(
                                                                      des));
                                                            }
                                                            await cart
                                                                .setItems();
                                                          } catch (e) {
                                                            // error(context);
                                                            print('e');
                                                            print(e);
                                                          }
                                                        } else {
                                                          if (cartId == null ||
                                                              cartId ==
                                                                  studentId) {
                                                            try {
                                                              if (!cart.idp
                                                                  .contains(item
                                                                      .items[i]
                                                                      .id)) {
                                                                await helper.createCar(CartProducts(
                                                                    id: null,
                                                                    studentId: item
                                                                        .items[
                                                                            i]
                                                                        .brands![
                                                                            i]
                                                                        .id,
                                                                    image: item
                                                                        .items[
                                                                            i]
                                                                        .image,
                                                                    titleAr: item
                                                                        .items[
                                                                            i]
                                                                        .nameAr,
                                                                    titleEn: item
                                                                        .items[
                                                                            i]
                                                                        .nameEn,
                                                                    price: item
                                                                        .items[
                                                                            i]
                                                                        .price
                                                                        .toDouble(),
                                                                    quantity: 1,
                                                                    att: att,
                                                                    des: des,
                                                                    idp: item
                                                                        .items[
                                                                            i]
                                                                        .id,
                                                                    idc: item
                                                                        .items[
                                                                            i]
                                                                        .id,
                                                                    catNameEn:
                                                                        "",
                                                                    catNameAr:
                                                                        "",
                                                                    catSVG:
                                                                        ""));
                                                              } else {
                                                                int quantity = cart
                                                                    .items
                                                                    .firstWhere((element) =>
                                                                        element
                                                                            .idp ==
                                                                        item.items[i]
                                                                            .id)
                                                                    .quantity;
                                                                await helper.updateProduct(
                                                                    1 +
                                                                        quantity,
                                                                    item
                                                                        .items[
                                                                            i]
                                                                        .id,
                                                                    item
                                                                        .items[
                                                                            i]
                                                                        .finalPrice
                                                                        .toDouble(),
                                                                    jsonEncode(
                                                                        att),
                                                                    jsonEncode(
                                                                        des));
                                                              }
                                                              await cart
                                                                  .setItems();
                                                            } catch (e) {
                                                              print('e');
                                                              print(e);
                                                            }
                                                          } else {}
                                                        }
                                                      },
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            mainColor,
                                                        radius: w * .05,
                                                        child: Center(
                                                          child: Icon(
                                                            Icons
                                                                .shopping_cart_outlined,
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
                                                width: w * 0.45,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: h * 0.01,
                                                    ),
                                                    Container(
                                                        constraints:
                                                            BoxConstraints(
                                                          maxHeight: h * 0.07,
                                                        ),
                                                        child: Text(
                                                            translateString(
                                                                item.items[i]
                                                                    .nameEn
                                                                    .toString(),
                                                                item.items[i]
                                                                    .nameAr
                                                                    .toString()),
                                                            style: TextStyle(
                                                                fontSize:
                                                                    w * 0.035),
                                                            overflow:
                                                                TextOverflow
                                                                    .fade)),
                                                    SizedBox(
                                                      height: h * 0.005,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              if (item.items[i]
                                                                  .isSale)
                                                                TextSpan(
                                                                    text:
                                                                        '${item.items[i].salePrice} $currency ',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Tajawal',
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color:
                                                                            mainColor)),
                                                              if (!item.items[i]
                                                                  .isSale)
                                                                TextSpan(
                                                                    text:
                                                                        '${item.items[i].price} $currency ',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Tajawal',
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color:
                                                                            mainColor)),
                                                            ],
                                                          ),
                                                        ),
                                                        if (item
                                                            .items[i].isSale)
                                                          Text(
                                                            '${item.items[i].price} $currency',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  w * 0.035,
                                                              decorationThickness:
                                                                  w * 0.1,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              decorationColor:
                                                                  mainColor,
                                                              color:
                                                                  Colors.grey,
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
                                          await getItem(item.items[i].id);
                                          Navigator.pushReplacementNamed(
                                              context, 'pro');
                                          navPR(
                                              context,
                                              Products(
                                                fromFav: true,
                                                brandId:
                                                    item.items[i].brands![i].id,
                                              ));
                                        },
                                      );
                                    }),
                                  );
                                }
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  mask
                      ? Positioned(
                          bottom: h * 0.03,
                          right: w * 0.08,
                          child: CircleAvatar(
                            radius: w * 0.06,
                            backgroundColor: mainColor.withOpacity(0.7),
                            child: InkWell(
                              child: const Center(
                                  child: Icon(
                                Icons.arrow_upward_outlined,
                                color: Colors.white,
                              )),
                              onTap: () {
                                controller.animateTo(0,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease);
                              },
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(translate(context, 'home', 'exit_app')),
            content: Text(translate(context, 'home', 'ok_mess')),
            actions: [
              // ignore: deprecated_member_use
              RaisedButton(
                color: mainColor,
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  translate(context, 'home', 'no'),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              // ignore: deprecated_member_use
              RaisedButton(
                color: mainColor,
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  translate(context, 'home', 'yes'),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
