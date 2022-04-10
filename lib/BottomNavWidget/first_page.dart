// ignore_for_file: use_key_in_widget_constructors, unused_local_variable, avoid_print, unnecessary_this

import 'dart:convert';
import 'package:davinshi_app/dbhelper.dart';
import 'package:davinshi_app/models/cart.dart';
import 'package:davinshi_app/screens/designes/designe.dart';
import 'package:flutter/material.dart';
import 'package:davinshi_app/elements/app_bar.dart';
import 'package:davinshi_app/provider/CatProvider.dart';
import 'package:davinshi_app/provider/recommended_item.dart';
import 'package:davinshi_app/screens/home_folder/tab_one.dart';
import 'package:provider/provider.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/products_cla.dart';
import 'package:davinshi_app/provider/address.dart';
import 'package:davinshi_app/provider/best_item.dart';
import 'package:davinshi_app/provider/cart_provider.dart';
import 'package:davinshi_app/provider/map.dart';
import 'package:davinshi_app/provider/new_item.dart';
import 'package:davinshi_app/provider/offer_item.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

TabController? tabBarHome;
ScrollController controller = ScrollController();
ScrollController _controller2 = ScrollController();
ScrollController _controller3 = ScrollController();
ScrollController _controller4 = ScrollController();
ScrollController _controller5 = ScrollController();
bool mask = false, mask2 = false, mask3 = false, mask4 = false, mask5 = false;
bool f1 = true, f2 = true, f3 = true, f4 = true, f5 = true;
bool fi1 = true, fi2 = true, fi3 = true, fi4 = true, fi5 = true, finish = false;

class _FirstPageState extends State<FirstPage> with TickerProviderStateMixin {
  var currency = (prefs.getString('language_code').toString() == 'en')
      ? prefs.getString('currencyEn').toString()
      : prefs.getString('currencyAr').toString();
  void start(context) {
    Provider.of<MapProvider>(context, listen: false).start();
    Provider.of<AddressProvider>(context, listen: false).getAddress();
    Provider.of<CartProvider>(context, listen: false).setItems();
    tabBarHome = TabController(length: 5, vsync: this);
    var of1 = Provider.of<NewItemProvider>(context, listen: true);
    var of2 = Provider.of<BestItemProvider>(context, listen: true);
    var of3 = Provider.of<ReItemProvider>(context, listen: true);
    var of4 = Provider.of<OfferItemProvider>(context, listen: true);

    tabBarHome?.addListener(() async {
      if (tabBarHome?.index == 1) {
        if (fi1) {
          fi1 = false;
          NewItemProvider newItem =
              Provider.of<NewItemProvider>(context, listen: false);
          if (newItem.items.isEmpty) {
            dialog(context);
            await newItem.getItems();
            Navigator.pop(context);
          }
          fi1 = true;
        }
      }
      if (tabBarHome?.index == 2) {
        if (fi2) {
          fi2 = false;
          BestItemProvider bestItem =
              Provider.of<BestItemProvider>(context, listen: false);
          if (bestItem.items.isEmpty) {
            dialog(context);
            await bestItem.getItems();
            Navigator.pop(context);
          }
          fi2 = true;
        }
      }
      if (tabBarHome?.index == 3) {
        if (fi3) {
          fi3 = false;
          ReItemProvider reItem =
              Provider.of<ReItemProvider>(context, listen: false);
          if (reItem.items.isEmpty) {
            dialog(context);
            await reItem.getItems();
            Navigator.pop(context);
          }
          fi3 = true;
        }
      }
      if (tabBarHome?.index == 4) {
        if (fi4) {
          fi4 = false;
          OfferItemProvider offerItem =
              Provider.of<OfferItemProvider>(context, listen: false);
          if (offerItem.items.isEmpty) {
            dialog(context);
            await offerItem.getItems();
            Navigator.pop(context);
          }
          fi4 = true;
        }
      }
    });
    // _tabBar2 = TabController(length: 5,vsync: this);
    controller.addListener(() {
      if (controller.position.pixels > 400.0 && mask == false) {
        setState(() {
          mask = true;
        });
        // scroll.changeShow(0, true);
      }
      if (controller.position.pixels < 400.0 && mask == true) {
        setState(() {
          mask = false;
        });
        // scroll.changeShow(0, false);
      }
    });
    _controller2.addListener(() {
      if (_controller2.position.atEdge) {
        if (_controller2.position.pixels != 0) {
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
      if (_controller2.position.pixels > 400.0 && mask2 == false) {
        setState(() {
          mask2 = true;
        });
        // scroll.changeShow(1, true);
      }
      if (_controller2.position.pixels < 400.0 && mask2 == true) {
        setState(() {
          mask2 = false;
        });
        // scroll.changeShow(1, false);
      }
    });
    _controller3.addListener(() {
      if (_controller3.position.atEdge) {
        if (_controller3.position.pixels != 0) {
          if (f2) {
            if (!of2.finish) {
              f2 = false;
              dialog(context);
              of2.getItems().then((value) {
                Navigator.pop(context);
                f2 = true;
              });
            }
          }
        }
      }
      if (_controller3.position.pixels > 400.0 && mask3 == false) {
        setState(() {
          mask3 = true;
        });
        // scroll.changeShow(2, true);
      }
      if (_controller3.position.pixels < 400.0 && mask3 == true) {
        setState(() {
          mask3 = false;
        });
        // scroll.changeShow(2, false);
      }
    });
    _controller4.addListener(() {
      if (_controller4.position.atEdge) {
        if (_controller4.position.pixels != 0) {
          if (f4) {
            if (!of3.finish) {
              f4 = false;
              dialog(context);
              of3.getItems().then((value) {
                Navigator.pop(context);
                f4 = true;
              });
            }
          }
        }
      }
      if (_controller4.position.pixels > 400.0 && mask4 == false) {
        setState(() {
          mask4 = true;
        });
        // scroll.changeShow(2, true);
      }
      if (_controller4.position.pixels < 400.0 && mask4 == true) {
        setState(() {
          mask4 = false;
        });
        // scroll.changeShow(2, false);
      }
    });
    _controller5.addListener(() {
      if (_controller5.position.atEdge) {
        if (_controller5.position.pixels != 0) {
          if (f5) {
            if (!of4.finish) {
              f5 = false;
              dialog(context);
              of4.getItems().then((value) {
                Navigator.pop(context);
                f5 = true;
              });
            }
          }
        }
      }
      if (_controller5.position.pixels > 400.0 && mask5 == false) {
        setState(() {
          mask5 = true;
        });
        // scroll.changeShow(3, true);
      }
      if (_controller5.position.pixels < 400.0 && mask5 == true) {
        setState(() {
          mask5 = false;
        });
        // scroll.changeShow(3, false);
      }
    });
  }

  List<int> att = [];
  List<String> des = [];
  DbHelper helper = DbHelper();

  @override
  Widget build(BuildContext context) {
    // timeDilation = 1.5;
    CatProvider catProvider = Provider.of<CatProvider>(context, listen: false);
    if (!finish) {
      start(context);
      finish = true;
    }
    CartProvider cart = Provider.of<CartProvider>(context, listen: true);
    return Directionality(
      textDirection: getDirection(),
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBarHome.app_bar_home(context),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            child: Column(
              children: [
                Image.asset(
                  "assets/images/Group 1204.png",
                  fit: BoxFit.cover,
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DesigneScreen()));
            },
          ),
          body: TabBarView(
            controller: tabBarHome,
            children: [
              TabOne(),
              SizedBox(
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
                          controller: _controller2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: h * 0.01,
                              ),
                              Consumer<NewItemProvider>(
                                builder: (context, newItem, _) {
                                  return DropdownButton<String>(
                                    isDense: true,
                                    underline: const SizedBox(),
                                    iconEnabledColor: mainColor,
                                    iconDisabledColor: mainColor,
                                    iconSize: w * 0.08,
                                    hint: Text(
                                        translate(context, 'home', 'sort')),
                                    items: List.generate(newItem.sorts.length,
                                        (index) {
                                      return DropdownMenuItem(
                                        value: newItem.sorts[index],
                                        child: Column(
                                          children: [
                                            (prefs.getString('language_code') ==
                                                    'en')
                                                ? Text(
                                                    newItem.sorts[index],
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontFamily: 'Tajawal',
                                                    ),
                                                  )
                                                : Text(
                                                    newItem.sortsAr[index],
                                                    style: TextStyle(
                                                      fontFamily: 'Tajawal',
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                            Divider(
                                              color: mainColor,
                                            )
                                          ],
                                        ),
                                        onTap: () async {
                                          setState(() {
                                            newItem.sort =
                                                newItem.apiSort[index];
                                            newItem.sortList(index);
                                          });
                                        },
                                      );
                                    }),
                                    onChanged: (val) {},
                                    // value: newItem.sort,
                                  );
                                },
                              ),
                              SizedBox(
                                height: h * 0.01,
                              ),
                              SizedBox(
                                width: w,
                                child: Consumer<NewItemProvider>(
                                    builder: (context, newItem, _) {
                                  return (newItem.items.isNotEmpty)
                                      ? Wrap(
                                          children: List.generate(
                                              newItem.items.length, (i) {
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: w * 0.45,
                                                      height: h * 0.28,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              newItem.items[i]
                                                                  .image),
                                                          // image: AssetImage('assets/food${i+1}.png'),
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: w * 0.45,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: h * 0.01,
                                                          ),
                                                          Container(
                                                              width: w * 0.45,
                                                              constraints:
                                                                  BoxConstraints(
                                                                maxHeight:
                                                                    h * 0.07,
                                                              ),
                                                              child: Text(
                                                                  translateString(
                                                                      newItem
                                                                          .items[
                                                                              i]
                                                                          .nameEn,
                                                                      newItem
                                                                          .items[
                                                                              i]
                                                                          .nameAr),
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                      fontSize: w *
                                                                          0.035),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis)),
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
                                                                    if (newItem
                                                                        .items[
                                                                            i]
                                                                        .isSale)
                                                                      TextSpan(
                                                                          text: getProductprice(
                                                                              currency: currency,
                                                                              productPrice: newItem.items[i].salePrice!),
                                                                          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: mainColor)),
                                                                    if (!newItem
                                                                        .items[
                                                                            i]
                                                                        .isSale)
                                                                      TextSpan(
                                                                          text: getProductprice(
                                                                              currency: currency,
                                                                              productPrice: newItem.items[i].price),
                                                                          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: mainColor)),
                                                                  ],
                                                                ),
                                                              ),
                                                              // if (newItem.items[i]
                                                              //         .isSale &&
                                                              //     newItem.items[i]
                                                              //             .disPer !=
                                                              //         null)
                                                              //   Text(
                                                              //       newItem.items[i].disPer! +
                                                              //           '%',
                                                              //       style: const TextStyle(
                                                              //           fontWeight:
                                                              //               FontWeight
                                                              //                   .bold,
                                                              //           color: Colors
                                                              //               .red)),

                                                              if (newItem
                                                                  .items[i]
                                                                  .isSale)
                                                                Text(
                                                                  getProductprice(
                                                                      currency:
                                                                          currency,
                                                                      productPrice: newItem
                                                                          .items[
                                                                              i]
                                                                          .price),
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Tajawal',
                                                                    fontSize: w *
                                                                        0.035,
                                                                    decorationThickness:
                                                                        w * 0.1,
                                                                    decorationColor:
                                                                        mainColor,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                    color: Colors
                                                                        .grey,
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
                                                await getItem(
                                                    newItem.items[i].id);
                                                Navigator.pushReplacementNamed(
                                                    context, 'pro');
                                              },
                                            );
                                          }),
                                        )
                                      : Padding(
                                          padding:
                                              EdgeInsets.only(top: h * 0.3),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                                color: mainColor),
                                          ),
                                        );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    mask2
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
                                  _controller2.animateTo(0,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.ease);
                                },
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              SizedBox(
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
                          controller: _controller3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: h * 0.01,
                              ),
                              Consumer<BestItemProvider>(
                                builder: (context, item, _) {
                                  return DropdownButton<String>(
                                    isDense: true,
                                    underline: const SizedBox(),
                                    iconEnabledColor: mainColor,
                                    iconDisabledColor: mainColor,
                                    iconSize: w * 0.08,
                                    hint: Text(
                                        translate(context, 'home', 'sort')),
                                    items: List.generate(item.sorts.length,
                                        (index) {
                                      return DropdownMenuItem(
                                        value: item.sorts[index],
                                        child: Column(
                                          children: [
                                            (prefs.getString('language_code') ==
                                                    'en')
                                                ? Text(
                                                    item.sorts[index],
                                                    style: TextStyle(
                                                      fontFamily: 'Tajawal',
                                                      color: Colors.grey[600],
                                                    ),
                                                  )
                                                : Text(
                                                    item.sortsAr[index],
                                                    style: TextStyle(
                                                      fontFamily: 'Tajawal',
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                            Divider(
                                              color: mainColor,
                                            )
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() {
                                            item.sort = item.apiSort[index];
                                            item.sortList(index);
                                          });
                                        },
                                      );
                                    }),
                                    onChanged: (val) {},
                                    // value: item.sort,
                                  );
                                },
                              ),
                              SizedBox(
                                height: h * 0.01,
                              ),
                              SizedBox(
                                width: w,
                                child: Consumer<BestItemProvider>(
                                    builder: (context, bestItem, _) {
                                  return (bestItem.items.isNotEmpty)
                                      ? Wrap(
                                          children: List.generate(
                                              bestItem.items.length, (i) {
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: w * 0.45,
                                                      height: h * 0.28,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              bestItem.items[i]
                                                                  .image),
                                                          // image: AssetImage('assets/food${i+1}.png'),
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                      ),

                                                      // child: Padding(
                                                      //   padding:
                                                      //       EdgeInsets.all(w * 0.015),
                                                      //   child: Align(
                                                      //     alignment: isLeft()
                                                      //         ? Alignment.bottomLeft
                                                      //         : Alignment.bottomRight,
                                                      //     child: InkWell(
                                                      //       onTap: () async {
                                                      //         if (cartId == null ||
                                                      //             cartId ==
                                                      //                 studentId) {
                                                      //           try {
                                                      //             if (!cart.idp
                                                      //                 .contains(
                                                      //                     bestItem
                                                      //                         .items[
                                                      //                             i]
                                                      //                         .id)) {
                                                      //               await helper.createCar(CartProducts(
                                                      //                   id: null,
                                                      //                   studentId:
                                                      //                       studentId,
                                                      //                   image: bestItem
                                                      //                       .items[i]
                                                      //                       .image,
                                                      //                   titleAr: bestItem
                                                      //                       .items[i]
                                                      //                       .nameAr,
                                                      //                   titleEn: bestItem
                                                      //                       .items[i]
                                                      //                       .nameEn,
                                                      //                   price: bestItem
                                                      //                       .items[i]
                                                      //                       .finalPrice
                                                      //                       .toDouble(),
                                                      //                   quantity: 1,
                                                      //                   att: att,
                                                      //                   des: des,
                                                      //                   idp: bestItem
                                                      //                       .items[i]
                                                      //                       .id,
                                                      //                   idc: 0,
                                                      //                   catNameEn: "",
                                                      //                   catNameAr: "",
                                                      //                   catSVG: ""));
                                                      //             } else {
                                                      //               int quantity = cart
                                                      //                   .items
                                                      //                   .firstWhere((element) =>
                                                      //                       element
                                                      //                           .idp ==
                                                      //                       bestItem
                                                      //                           .items[
                                                      //                               i]
                                                      //                           .id)
                                                      //                   .quantity;
                                                      //               await helper.updateProduct(
                                                      //                   1 + quantity,
                                                      //                   bestItem
                                                      //                       .items[i]
                                                      //                       .id,
                                                      //                   bestItem
                                                      //                       .items[i]
                                                      //                       .finalPrice
                                                      //                       .toDouble(),
                                                      //                   jsonEncode(
                                                      //                       att),
                                                      //                   jsonEncode(
                                                      //                       des));
                                                      //             }
                                                      //             await cart
                                                      //                 .setItems();
                                                      //           } catch (e) {
                                                      //             error(context);
                                                      //             print('e');
                                                      //             print(e);
                                                      //           }
                                                      //         } else {
                                                      //           if (cartId == null ||
                                                      //               cartId ==
                                                      //                   studentId) {
                                                      //             try {
                                                      //               if (!cart.idp
                                                      //                   .contains(
                                                      //                       bestItem
                                                      //                           .items[
                                                      //                               i]
                                                      //                           .id)) {
                                                      //                 await helper.createCar(CartProducts(
                                                      //                     id: null,
                                                      //                     studentId: bestItem
                                                      //                         .items[
                                                      //                             i]
                                                      //                         .brands![
                                                      //                             i]
                                                      //                         .id,
                                                      //                     image: bestItem
                                                      //                         .items[
                                                      //                             i]
                                                      //                         .image,
                                                      //                     titleAr: bestItem
                                                      //                         .items[
                                                      //                             i]
                                                      //                         .nameAr,
                                                      //                     titleEn: bestItem
                                                      //                         .items[
                                                      //                             i]
                                                      //                         .nameEn,
                                                      //                     price: bestItem
                                                      //                         .items[
                                                      //                             i]
                                                      //                         .price
                                                      //                         .toDouble(),
                                                      //                     quantity: 1,
                                                      //                     att: att,
                                                      //                     des: des,
                                                      //                     idp: bestItem
                                                      //                         .items[
                                                      //                             i]
                                                      //                         .id,
                                                      //                     idc: bestItem
                                                      //                         .items[
                                                      //                             i]
                                                      //                         .id,
                                                      //                     catNameEn:
                                                      //                         "",
                                                      //                     catNameAr:
                                                      //                         "",
                                                      //                     catSVG:
                                                      //                         ""));
                                                      //               } else {
                                                      //                 int quantity = cart
                                                      //                     .items
                                                      //                     .firstWhere((element) =>
                                                      //                         element
                                                      //                             .idp ==
                                                      //                         bestItem
                                                      //                             .items[i]
                                                      //                             .id)
                                                      //                     .quantity;
                                                      //                 await helper.updateProduct(
                                                      //                     1 +
                                                      //                         quantity,
                                                      //                     bestItem
                                                      //                         .items[
                                                      //                             i]
                                                      //                         .id,
                                                      //                     bestItem
                                                      //                         .items[
                                                      //                             i]
                                                      //                         .finalPrice
                                                      //                         .toDouble(),
                                                      //                     jsonEncode(
                                                      //                         att),
                                                      //                     jsonEncode(
                                                      //                         des));
                                                      //               }
                                                      //               await cart
                                                      //                   .setItems();
                                                      //             } catch (e) {
                                                      //               print('e');
                                                      //               print(e);
                                                      //             }
                                                      //           } else {}
                                                      //         }
                                                      //       },
                                                      //       child: CircleAvatar(
                                                      //         backgroundColor:
                                                      //             mainColor,
                                                      //         radius: w * .05,
                                                      //         child: Center(
                                                      //           child: Icon(
                                                      //             Icons
                                                      //                 .shopping_cart_outlined,
                                                      //             color: Colors.white,
                                                      //             size: w * 0.05,
                                                      //           ),
                                                      //         ),
                                                      //       ),
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                    ),
                                                    SizedBox(
                                                      width: w * 0.45,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: h * 0.01,
                                                          ),
                                                          Container(
                                                              constraints:
                                                                  BoxConstraints(
                                                                maxHeight:
                                                                    h * 0.07,
                                                              ),
                                                              child: Text(
                                                                  translateString(
                                                                      bestItem
                                                                          .items[
                                                                              i]
                                                                          .nameEn,
                                                                      bestItem
                                                                          .items[
                                                                              i]
                                                                          .nameAr),
                                                                  style: TextStyle(
                                                                      fontSize: w *
                                                                          0.035),
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
                                                                    if (bestItem
                                                                        .items[
                                                                            i]
                                                                        .isSale)
                                                                      TextSpan(
                                                                          text: getProductprice(
                                                                              currency: currency,
                                                                              productPrice: bestItem.items[i].salePrice!),
                                                                          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: mainColor)),
                                                                    if (!bestItem
                                                                        .items[
                                                                            i]
                                                                        .isSale)
                                                                      TextSpan(
                                                                          text: getProductprice(
                                                                              currency: currency,
                                                                              productPrice: bestItem.items[i].price),
                                                                          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: mainColor)),
                                                                  ],
                                                                ),
                                                              ),
                                                              // if (bestItem.items[i].isSale &&
                                                              //     bestItem.items[i]
                                                              //             .disPer !=
                                                              //         null)
                                                              //   Text(
                                                              //       bestItem.items[i]
                                                              //               .disPer! +
                                                              //           '%',
                                                              //       style: const TextStyle(
                                                              //           fontWeight:
                                                              //               FontWeight
                                                              //                   .bold,
                                                              //           color: Colors
                                                              //               .red)),

                                                              if (bestItem
                                                                  .items[i]
                                                                  .isSale)
                                                                Text(
                                                                  getProductprice(
                                                                      currency:
                                                                          currency,
                                                                      productPrice: bestItem
                                                                          .items[
                                                                              i]
                                                                          .price),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: w *
                                                                        0.035,
                                                                    decorationThickness:
                                                                        w * 0.1,
                                                                    decorationColor:
                                                                        mainColor,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                    color: Colors
                                                                        .grey,
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
                                                await getItem(
                                                    bestItem.items[i].id);
                                                Navigator.pushReplacementNamed(
                                                    context, 'pro');
                                              },
                                            );
                                          }),
                                        )
                                      : Center(
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(top: h * 0.3),
                                            child: CircularProgressIndicator(
                                              color: mainColor,
                                            ),
                                          ),
                                        );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    mask3
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
                                  _controller3.animateTo(0,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.ease);
                                },
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              SizedBox(
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
                          controller: _controller4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: h * 0.01,
                              ),
                              Consumer<ReItemProvider>(
                                builder: (context, item, _) {
                                  return DropdownButton<String>(
                                    isDense: true,
                                    underline: const SizedBox(),
                                    iconEnabledColor: mainColor,
                                    iconDisabledColor: mainColor,
                                    iconSize: w * 0.08,
                                    hint: Text(
                                        translate(context, 'home', 'sort')),
                                    items: List.generate(item.sorts.length,
                                        (index) {
                                      return DropdownMenuItem(
                                        value: item.sorts[index],
                                        child: Column(
                                          children: [
                                            (prefs.getString('language_code') ==
                                                    'en')
                                                ? Text(
                                                    item.sorts[index],
                                                    style: TextStyle(
                                                      fontFamily: 'Tajawal',
                                                      color: Colors.grey[600],
                                                    ),
                                                  )
                                                : Text(
                                                    item.sortsAr[index],
                                                    style: TextStyle(
                                                      fontFamily: 'Tajawal',
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                            Divider(
                                              color: mainColor,
                                            )
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() {
                                            item.sort = item.apiSort[index];
                                            item.sortList(index);
                                          });
                                        },
                                      );
                                    }),
                                    onChanged: (val) {},
                                    // value: item.sort,
                                  );
                                },
                              ),
                              SizedBox(
                                height: h * 0.01,
                              ),
                              SizedBox(
                                width: w,
                                child: Consumer<ReItemProvider>(
                                    builder: (context, reItem, _) {
                                  return (reItem.items.isNotEmpty)
                                      ? Wrap(
                                          children: List.generate(
                                              reItem.items.length, (i) {
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: w * 0.45,
                                                      height: h * 0.28,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              reItem.items[i]
                                                                  .image),
                                                          // image: AssetImage('assets/food${i+1}.png'),
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                      ),

                                                      // child: Padding(
                                                      //   padding:
                                                      //       EdgeInsets.all(w * 0.015),
                                                      //   child: Align(
                                                      //     alignment: isLeft()
                                                      //         ? Alignment.bottomLeft
                                                      //         : Alignment.bottomRight,
                                                      //     child: InkWell(
                                                      //       onTap: () async {
                                                      //         if (cartId == null ||
                                                      //             cartId ==
                                                      //                 studentId) {
                                                      //           try {
                                                      //             if (!cart.idp
                                                      //                 .contains(reItem
                                                      //                     .items[i]
                                                      //                     .id)) {
                                                      //               await helper.createCar(CartProducts(
                                                      //                   id: null,
                                                      //                   studentId:
                                                      //                       studentId,
                                                      //                   image: reItem
                                                      //                       .items[i]
                                                      //                       .image,
                                                      //                   titleAr: reItem
                                                      //                       .items[i]
                                                      //                       .nameAr,
                                                      //                   titleEn: reItem
                                                      //                       .items[i]
                                                      //                       .nameEn,
                                                      //                   price: reItem
                                                      //                       .items[i]
                                                      //                       .finalPrice
                                                      //                       .toDouble(),
                                                      //                   quantity: 1,
                                                      //                   att: att,
                                                      //                   des: des,
                                                      //                   idp: reItem
                                                      //                       .items[i]
                                                      //                       .id,
                                                      //                   idc: 0,
                                                      //                   catNameEn: "",
                                                      //                   catNameAr: "",
                                                      //                   catSVG: ""));
                                                      //             } else {
                                                      //               int quantity = cart
                                                      //                   .items
                                                      //                   .firstWhere((element) =>
                                                      //                       element
                                                      //                           .idp ==
                                                      //                       reItem
                                                      //                           .items[
                                                      //                               i]
                                                      //                           .id)
                                                      //                   .quantity;
                                                      //               await helper.updateProduct(
                                                      //                   1 + quantity,
                                                      //                   reItem
                                                      //                       .items[i]
                                                      //                       .id,
                                                      //                   reItem
                                                      //                       .items[i]
                                                      //                       .finalPrice
                                                      //                       .toDouble(),
                                                      //                   jsonEncode(
                                                      //                       att),
                                                      //                   jsonEncode(
                                                      //                       des));
                                                      //             }
                                                      //             await cart
                                                      //                 .setItems();
                                                      //           } catch (e) {
                                                      //             error(context);
                                                      //             print('e');
                                                      //             print(e);
                                                      //           }
                                                      //         } else {
                                                      //           if (cartId == null ||
                                                      //               cartId ==
                                                      //                   studentId) {
                                                      //             try {
                                                      //               if (!cart.idp
                                                      //                   .contains(reItem
                                                      //                       .items[i]
                                                      //                       .id)) {
                                                      //                 await helper.createCar(CartProducts(
                                                      //                     id: null,
                                                      //                     studentId: reItem
                                                      //                         .items[
                                                      //                             i]
                                                      //                         .brands![
                                                      //                             i]
                                                      //                         .id,
                                                      //                     image: reItem
                                                      //                         .items[
                                                      //                             i]
                                                      //                         .image,
                                                      //                     titleAr: reItem
                                                      //                         .items[
                                                      //                             i]
                                                      //                         .nameAr,
                                                      //                     titleEn: reItem
                                                      //                         .items[
                                                      //                             i]
                                                      //                         .nameEn,
                                                      //                     price: reItem
                                                      //                         .items[
                                                      //                             i]
                                                      //                         .price
                                                      //                         .toDouble(),
                                                      //                     quantity: 1,
                                                      //                     att: att,
                                                      //                     des: des,
                                                      //                     idp: reItem
                                                      //                         .items[
                                                      //                             i]
                                                      //                         .id,
                                                      //                     idc: reItem
                                                      //                         .items[
                                                      //                             i]
                                                      //                         .id,
                                                      //                     catNameEn:
                                                      //                         "",
                                                      //                     catNameAr:
                                                      //                         "",
                                                      //                     catSVG:
                                                      //                         ""));
                                                      //               } else {
                                                      //                 int quantity = cart
                                                      //                     .items
                                                      //                     .firstWhere((element) =>
                                                      //                         element
                                                      //                             .idp ==
                                                      //                         reItem
                                                      //                             .items[i]
                                                      //                             .id)
                                                      //                     .quantity;
                                                      //                 await helper.updateProduct(
                                                      //                     1 +
                                                      //                         quantity,
                                                      //                     reItem
                                                      //                         .items[
                                                      //                             i]
                                                      //                         .id,
                                                      //                     reItem
                                                      //                         .items[
                                                      //                             i]
                                                      //                         .finalPrice
                                                      //                         .toDouble(),
                                                      //                     jsonEncode(
                                                      //                         att),
                                                      //                     jsonEncode(
                                                      //                         des));
                                                      //               }
                                                      //               await cart
                                                      //                   .setItems();
                                                      //             } catch (e) {
                                                      //               print('e');
                                                      //               print(e);
                                                      //             }
                                                      //           } else {}
                                                      //         }
                                                      //       },
                                                      //       child: CircleAvatar(
                                                      //         backgroundColor:
                                                      //             mainColor,
                                                      //         radius: w * .05,
                                                      //         child: Center(
                                                      //           child: Icon(
                                                      //             Icons
                                                      //                 .shopping_cart_outlined,
                                                      //             color: Colors.white,
                                                      //             size: w * 0.05,
                                                      //           ),
                                                      //         ),
                                                      //       ),
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                    ),
                                                    SizedBox(
                                                      width: w * 0.45,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: h * 0.01,
                                                          ),
                                                          Container(
                                                              constraints:
                                                                  BoxConstraints(
                                                                maxHeight:
                                                                    h * 0.07,
                                                              ),
                                                              child: Text(
                                                                  translateString(
                                                                      reItem
                                                                          .items[
                                                                              i]
                                                                          .nameEn,
                                                                      reItem
                                                                          .items[
                                                                              i]
                                                                          .nameAr),
                                                                  style: TextStyle(
                                                                      fontSize: w *
                                                                          0.035),
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
                                                                    if (reItem
                                                                        .items[
                                                                            i]
                                                                        .isSale)
                                                                      TextSpan(
                                                                          text: getProductprice(
                                                                              currency: currency,
                                                                              productPrice: reItem.items[i].salePrice!),
                                                                          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: mainColor)),
                                                                    if (!reItem
                                                                        .items[
                                                                            i]
                                                                        .isSale)
                                                                      TextSpan(
                                                                          text: getProductprice(
                                                                              currency: currency,
                                                                              productPrice: reItem.items[i].price),
                                                                          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: mainColor)),
                                                                  ],
                                                                ),
                                                              ),
                                                              // if (reItem.items[i]
                                                              //         .isSale &&
                                                              //     reItem.items[i]
                                                              //             .disPer !=
                                                              //         null)
                                                              //   Text(
                                                              //       reItem.items[i]
                                                              //               .disPer! +
                                                              //           '%',
                                                              //       style: const TextStyle(
                                                              //           fontWeight:
                                                              //               FontWeight
                                                              //                   .bold,
                                                              //           color: Colors
                                                              //               .red)),

                                                              if (reItem
                                                                  .items[i]
                                                                  .isSale)
                                                                Text(
                                                                  getProductprice(
                                                                      currency:
                                                                          currency,
                                                                      productPrice: reItem
                                                                          .items[
                                                                              i]
                                                                          .price),
                                                                  style:
                                                                      TextStyle(
                                                                    decorationThickness:
                                                                        w * 0.1,
                                                                    fontSize: w *
                                                                        0.035,
                                                                    decorationColor:
                                                                        mainColor,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                    color: Colors
                                                                        .grey,
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
                                                await getItem(
                                                    reItem.items[i].id);
                                                Navigator.pushReplacementNamed(
                                                    context, 'pro');
                                              },
                                            );
                                          }),
                                        )
                                      : Center(
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(top: h * 0.3),
                                            child: CircularProgressIndicator(
                                              color: mainColor,
                                            ),
                                          ),
                                        );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    mask4
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
                                  _controller4.animateTo(0,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.ease);
                                },
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              SizedBox(
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
                          controller: _controller5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: h * 0.01,
                              ),
                              Consumer<OfferItemProvider>(
                                builder: (context, item, _) {
                                  return DropdownButton<String>(
                                    isDense: true,
                                    underline: const SizedBox(),
                                    iconEnabledColor: mainColor,
                                    iconDisabledColor: mainColor,
                                    iconSize: w * 0.08,
                                    hint: Text(
                                        translate(context, 'home', 'sort')),
                                    items: List.generate(item.sorts.length,
                                        (index) {
                                      return DropdownMenuItem(
                                        value: item.sorts[index],
                                        child: Column(
                                          children: [
                                            (prefs.getString('language_code') ==
                                                    'en')
                                                ? Text(
                                                    item.sorts[index],
                                                    style: TextStyle(
                                                      fontFamily: 'Tajawal',
                                                      color: Colors.grey[600],
                                                    ),
                                                  )
                                                : Text(
                                                    item.sortsAr[index],
                                                    style: TextStyle(
                                                      fontFamily: 'Tajawal',
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                            Divider(
                                              color: mainColor,
                                            )
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() {
                                            setState(() {
                                              item.sort = item.apiSort[index];
                                              item.sortList(index);
                                            });
                                          });
                                        },
                                      );
                                    }),
                                    onChanged: (val) {},
                                    // value: item.sort,
                                  );
                                },
                              ),
                              SizedBox(
                                height: h * 0.01,
                              ),
                              SizedBox(
                                width: w,
                                child: Consumer<OfferItemProvider>(
                                    builder: (context, offerItem, _) {
                                  return (offerItem.items.isNotEmpty)
                                      ? Wrap(
                                          children: List.generate(
                                              offerItem.items.length, (i) {
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: w * 0.45,
                                                      height: h * 0.28,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              offerItem.items[i]
                                                                  .image),
                                                          // image: AssetImage('assets/food${i+1}.png'),
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            w * 0.015),
                                                        child: Align(
                                                          alignment: isLeft()
                                                              ? Alignment
                                                                  .topRight
                                                              : Alignment
                                                                  .topLeft,
                                                          child: InkWell(
                                                            onTap: () async {
                                                              if (cartId ==
                                                                      null ||
                                                                  cartId ==
                                                                      studentId) {
                                                                try {
                                                                  if (!cart.idp.contains(
                                                                      offerItem
                                                                          .items[
                                                                              i]
                                                                          .id)) {
                                                                    await helper.createCar(CartProducts(
                                                                        id:
                                                                            null,
                                                                        studentId:
                                                                            studentId,
                                                                        image: offerItem
                                                                            .items[
                                                                                i]
                                                                            .image,
                                                                        titleAr: offerItem
                                                                            .items[
                                                                                i]
                                                                            .nameAr,
                                                                        titleEn: offerItem
                                                                            .items[
                                                                                i]
                                                                            .nameEn,
                                                                        price: offerItem
                                                                            .items[
                                                                                i]
                                                                            .finalPrice
                                                                            .toDouble(),
                                                                        quantity:
                                                                            1,
                                                                        att:
                                                                            att,
                                                                        des:
                                                                            des,
                                                                        idp: offerItem
                                                                            .items[
                                                                                i]
                                                                            .id,
                                                                        idc: 0,
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
                                                                            element.idp ==
                                                                            offerItem.items[i].id)
                                                                        .quantity;
                                                                    await helper.updateProduct(
                                                                        1 +
                                                                            quantity,
                                                                        offerItem
                                                                            .items[
                                                                                i]
                                                                            .id,
                                                                        offerItem
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
                                                                  error(
                                                                      context);
                                                                  print('e');
                                                                  print(e);
                                                                }
                                                              } else {
                                                                if (cartId ==
                                                                        null ||
                                                                    cartId ==
                                                                        studentId) {
                                                                  try {
                                                                    if (!cart
                                                                        .idp
                                                                        .contains(offerItem
                                                                            .items[i]
                                                                            .id)) {
                                                                      await helper.createCar(CartProducts(
                                                                          id:
                                                                              null,
                                                                          studentId: offerItem
                                                                              .items[
                                                                                  i]
                                                                              .brands![
                                                                                  i]
                                                                              .id,
                                                                          image: offerItem
                                                                              .items[
                                                                                  i]
                                                                              .image,
                                                                          titleAr: offerItem
                                                                              .items[
                                                                                  i]
                                                                              .nameAr,
                                                                          titleEn: offerItem
                                                                              .items[
                                                                                  i]
                                                                              .nameEn,
                                                                          price: offerItem
                                                                              .items[
                                                                                  i]
                                                                              .price
                                                                              .toDouble(),
                                                                          quantity:
                                                                              1,
                                                                          att:
                                                                              att,
                                                                          des:
                                                                              des,
                                                                          idp: offerItem
                                                                              .items[
                                                                                  i]
                                                                              .id,
                                                                          idc: offerItem
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
                                                                              element.idp ==
                                                                              offerItem.items[i].id)
                                                                          .quantity;
                                                                      await helper.updateProduct(
                                                                          1 +
                                                                              quantity,
                                                                          offerItem
                                                                              .items[
                                                                                  i]
                                                                              .id,
                                                                          offerItem
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
                                                                      .add_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                  size:
                                                                      w * 0.05,
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
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: h * 0.01,
                                                          ),
                                                          Container(
                                                              constraints:
                                                                  BoxConstraints(
                                                                maxHeight:
                                                                    h * 0.07,
                                                              ),
                                                              child: Text(
                                                                  translateString(
                                                                      offerItem
                                                                          .items[
                                                                              i]
                                                                          .nameEn,
                                                                      offerItem
                                                                          .items[
                                                                              i]
                                                                          .nameAr),
                                                                  style: TextStyle(
                                                                      fontSize: w *
                                                                          0.035),
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
                                                                    if (offerItem
                                                                        .items[
                                                                            i]
                                                                        .isSale)
                                                                      TextSpan(
                                                                          text: getProductprice(
                                                                              currency: currency,
                                                                              productPrice: offerItem.items[i].salePrice!),
                                                                          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: mainColor)),
                                                                    if (!offerItem
                                                                        .items[
                                                                            i]
                                                                        .isSale)
                                                                      TextSpan(
                                                                          text: getProductprice(
                                                                              currency: currency,
                                                                              productPrice: offerItem.items[i].price),
                                                                          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: mainColor)),
                                                                  ],
                                                                ),
                                                              ),
                                                              if (offerItem
                                                                  .items[i]
                                                                  .isSale)
                                                                Text(
                                                                  getProductprice(
                                                                      currency:
                                                                          currency,
                                                                      productPrice: offerItem
                                                                          .items[
                                                                              i]
                                                                          .price),
                                                                  style:
                                                                      TextStyle(
                                                                    decorationThickness:
                                                                        w * 0.1,
                                                                    fontSize: w *
                                                                        0.035,
                                                                    decorationColor:
                                                                        mainColor,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                              // if (offerItem.items[i]
                                                              //         .isSale &&
                                                              //     offerItem.items[i]
                                                              //             .disPer !=
                                                              //         null)
                                                              //   Text(
                                                              //       offerItem.items[i]
                                                              //               .disPer! +
                                                              //           '%',
                                                              //       style: const TextStyle(
                                                              //           fontWeight:
                                                              //               FontWeight
                                                              //                   .bold,
                                                              //           color: Colors
                                                              //               .red)),
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
                                                await getItem(
                                                    offerItem.items[i].id);
                                                Navigator.pushReplacementNamed(
                                                    context, 'pro');
                                              },
                                            );
                                          }),
                                        )
                                      : Center(
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(top: h * 0.3),
                                            child: CircularProgressIndicator(
                                              color: mainColor,
                                            ),
                                          ),
                                        );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    mask5
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
                                  _controller5.animateTo(0,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.ease);
                                },
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
