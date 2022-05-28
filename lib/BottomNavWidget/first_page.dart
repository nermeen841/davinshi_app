// ignore_for_file: use_key_in_widget_constructors, unused_local_variable, avoid_print, unnecessary_this, prefer_final_fields

import 'package:davinshi_app/dbhelper.dart';
import 'package:davinshi_app/elements/newtwork_image.dart';
import 'package:davinshi_app/models/home_item.dart';
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

import '../screens/product_info/products.dart';

class FirstPage extends StatefulWidget {
  final TabController tabBarHome;

  const FirstPage({Key? key, required this.tabBarHome}) : super(key: key);
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage>
    with SingleTickerProviderStateMixin {
  var currency = (prefs.getString('language_code').toString() == 'en')
      ? prefs.getString('currencyEn').toString()
      : prefs.getString('currencyAr').toString();

  ScrollController controller = ScrollController();
  ScrollController _controller2 = ScrollController();
  ScrollController _controller3 = ScrollController();
  ScrollController _controller4 = ScrollController();
  ScrollController _controller5 = ScrollController();
  bool mask = false, mask2 = false, mask3 = false, mask4 = false, mask5 = false;
  bool f1 = true, f2 = true, f3 = true, f4 = true, f5 = true;
  bool fi1 = true,
      fi2 = true,
      fi3 = true,
      fi4 = true,
      fi5 = true,
      finish = false;

  void start(context) {
    Provider.of<MapProvider>(context, listen: false).start();
    Provider.of<AddressProvider>(context, listen: false).getAddress();
    Provider.of<CartProvider>(context, listen: false).setItems();
    var of1 = Provider.of<NewItemProvider>(context, listen: true);
    var of2 = Provider.of<BestItemProvider>(context, listen: true);
    var of3 = Provider.of<ReItemProvider>(context, listen: true);
    var of4 = Provider.of<OfferItemProvider>(context, listen: true);

    widget.tabBarHome.addListener(() async {
      if (widget.tabBarHome.index == 1) {
        if (fi1) {
          fi1 = false;
          NewItemProvider newItem =
              Provider.of<NewItemProvider>(context, listen: false);
          if (newItem.items.isEmpty) {
            // dialog(context);
            await newItem.getItems();
            // Navigator.pop(context);
          }
          fi1 = true;
        }
      }
      if (widget.tabBarHome.index == 2) {
        if (fi2) {
          fi2 = false;
          BestItemProvider bestItem =
              Provider.of<BestItemProvider>(context, listen: false);
          if (bestItem.items.isEmpty) {
            // dialog(context);
            await bestItem.getItems();
            // Navigator.pop(context);
          }
          fi2 = true;
        }
      }
      if (widget.tabBarHome.index == 3) {
        if (fi3) {
          fi3 = false;
          ReItemProvider reItem =
              Provider.of<ReItemProvider>(context, listen: false);
          if (reItem.items.isEmpty) {
            // dialog(context);
            await reItem.getItems();
            // Navigator.pop(context);
          }
          fi3 = true;
        }
      }
      if (widget.tabBarHome.index == 4) {
        if (fi4) {
          fi4 = false;
          OfferItemProvider offerItem =
              Provider.of<OfferItemProvider>(context, listen: false);
          if (offerItem.items.isEmpty) {
            // dialog(context);
            await offerItem.getItems();
            // Navigator.pop(context);
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
    Provider.of<HomeProvider>(context, listen: false).getHomeItems();
    return Directionality(
      textDirection: getDirection(),
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBarHome.app_bar_home(context, widget.tabBarHome),
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
          body: Consumer<HomeProvider>(
            builder: (context, value, child) {
              return TabBarView(
                controller: widget.tabBarHome,
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
                                        items: List.generate(
                                            newItem.sorts.length, (index) {
                                          return DropdownMenuItem(
                                            value: newItem.sorts[index],
                                            child: Column(
                                              children: [
                                                (prefs.getString(
                                                            'language_code') ==
                                                        'en')
                                                    ? Text(
                                                        newItem.sorts[index],
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                          fontFamily: 'Tajawal',
                                                        ),
                                                      )
                                                    : Text(
                                                        newItem.sortsAr[index],
                                                        style: TextStyle(
                                                          fontFamily: 'Tajawal',
                                                          color:
                                                              Colors.grey[600],
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
                                                        Stack(
                                                          children: [
                                                            SizedBox(
                                                              width: w * 0.45,
                                                              height: h * 0.28,
                                                              child:
                                                                  ImageeNetworkWidget(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: newItem
                                                                    .items[i]
                                                                    .image,
                                                              ),
                                                            ),
                                                            (newItem.items[i]
                                                                        .isOrder ==
                                                                    1)
                                                                ? Container(
                                                                    height: h *
                                                                        0.04,
                                                                    width: w *
                                                                        0.22,
                                                                    margin: EdgeInsets.symmetric(
                                                                        horizontal: w *
                                                                            0.01,
                                                                        vertical:
                                                                            h * 0.01),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          mainColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(w *
                                                                              0.02),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        translateString(
                                                                            "Order",
                                                                            "علي الطلب"),
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Tajawal',
                                                                            fontSize: w *
                                                                                0.04,
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.w500),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const SizedBox(),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: w * 0.45,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height:
                                                                    h * 0.01,
                                                              ),
                                                              Container(
                                                                  width:
                                                                      w * 0.45,
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
                                                                      maxLines:
                                                                          2,
                                                                      style: TextStyle(
                                                                          fontSize: w *
                                                                              0.035),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis)),
                                                              SizedBox(
                                                                height:
                                                                    h * 0.005,
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
                                                                    text:
                                                                        TextSpan(
                                                                      children: [
                                                                        if (newItem
                                                                            .items[
                                                                                i]
                                                                            .isSale)
                                                                          TextSpan(
                                                                              text: getProductprice(currency: currency, productPrice: newItem.items[i].salePrice!),
                                                                              style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: mainColor)),
                                                                        if (!newItem
                                                                            .items[
                                                                                i]
                                                                            .isSale)
                                                                          TextSpan(
                                                                              text: getProductprice(currency: currency, productPrice: newItem.items[i].price),
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
                                                                              .items[i]
                                                                              .price),
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Tajawal',
                                                                        fontSize:
                                                                            w * 0.035,
                                                                        decorationThickness:
                                                                            w * 0.1,
                                                                        decorationColor:
                                                                            mainColor,
                                                                        decoration:
                                                                            TextDecoration.lineThrough,
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
                                                    // await getItem(
                                                    //     newItem.items[i].id);
                                                    // Navigator.pushNamed(
                                                    //     context, 'pro');
                                                    navP(
                                                      context,
                                                      Products(
                                                        fromFav: false,
                                                        productId:
                                                            newItem.items[i].id,
                                                      ),
                                                    );
                                                  },
                                                );
                                              }),
                                            )
                                          : Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: h * 0.3),
                                                child: Text(
                                                  translateString(
                                                      "No products here",
                                                      "لا توجد منتجات"),
                                                  style: TextStyle(
                                                      fontFamily: "Tajawal",
                                                      fontSize: w * 0.04,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: mainColor),
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
                                                (prefs.getString(
                                                            'language_code') ==
                                                        'en')
                                                    ? Text(
                                                        item.sorts[index],
                                                        style: TextStyle(
                                                          fontFamily: 'Tajawal',
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      )
                                                    : Text(
                                                        item.sortsAr[index],
                                                        style: TextStyle(
                                                          fontFamily: 'Tajawal',
                                                          color:
                                                              Colors.grey[600],
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
                                                        Stack(
                                                          children: [
                                                            ImageeNetworkWidget(
                                                              fit: BoxFit.cover,
                                                              image: bestItem
                                                                  .items[i]
                                                                  .image,
                                                              width: w * 0.45,
                                                              height: h * 0.28,
                                                            ),
                                                            (bestItem.items[i]
                                                                        .isOrder ==
                                                                    1)
                                                                ? Container(
                                                                    height: h *
                                                                        0.04,
                                                                    width: w *
                                                                        0.22,
                                                                    margin: EdgeInsets.symmetric(
                                                                        horizontal: w *
                                                                            0.01,
                                                                        vertical:
                                                                            h * 0.01),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          mainColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(w *
                                                                              0.02),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        translateString(
                                                                            "Order",
                                                                            "علي الطلب"),
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Tajawal',
                                                                            fontSize: w *
                                                                                0.04,
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.w500),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const SizedBox(),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: w * 0.45,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height:
                                                                    h * 0.01,
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
                                                                height:
                                                                    h * 0.005,
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
                                                                    text:
                                                                        TextSpan(
                                                                      children: [
                                                                        if (bestItem
                                                                            .items[
                                                                                i]
                                                                            .isSale)
                                                                          TextSpan(
                                                                              text: getProductprice(currency: currency, productPrice: bestItem.items[i].salePrice!),
                                                                              style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: mainColor)),
                                                                        if (!bestItem
                                                                            .items[
                                                                                i]
                                                                            .isSale)
                                                                          TextSpan(
                                                                              text: getProductprice(currency: currency, productPrice: bestItem.items[i].price),
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
                                                                              .items[i]
                                                                              .price),
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            w * 0.035,
                                                                        decorationThickness:
                                                                            w * 0.1,
                                                                        decorationColor:
                                                                            mainColor,
                                                                        decoration:
                                                                            TextDecoration.lineThrough,
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
                                                    // await getItem(
                                                    //     bestItem.items[i].id);
                                                    // Navigator.pushNamed(
                                                    //     context, 'pro');
                                                    navP(
                                                      context,
                                                      Products(
                                                        fromFav: false,
                                                        productId: bestItem
                                                            .items[i].id,
                                                      ),
                                                    );
                                                  },
                                                );
                                              }),
                                            )
                                          : Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: h * 0.3),
                                                child: Text(
                                                  translateString(
                                                      "No products here",
                                                      "لا توجد منتجات"),
                                                  style: TextStyle(
                                                      fontFamily: "Tajawal",
                                                      fontSize: w * 0.04,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: mainColor),
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
                                                (prefs.getString(
                                                            'language_code') ==
                                                        'en')
                                                    ? Text(
                                                        item.sorts[index],
                                                        style: TextStyle(
                                                          fontFamily: 'Tajawal',
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      )
                                                    : Text(
                                                        item.sortsAr[index],
                                                        style: TextStyle(
                                                          fontFamily: 'Tajawal',
                                                          color:
                                                              Colors.grey[600],
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
                                                        Stack(
                                                          children: [
                                                            ImageeNetworkWidget(
                                                              fit: BoxFit.cover,
                                                              image: reItem
                                                                  .items[i]
                                                                  .image,
                                                              width: w * 0.45,
                                                              height: h * 0.28,
                                                            ),
                                                            (reItem.items[i]
                                                                        .isOrder ==
                                                                    1)
                                                                ? Container(
                                                                    height: h *
                                                                        0.04,
                                                                    width: w *
                                                                        0.22,
                                                                    margin: EdgeInsets.symmetric(
                                                                        horizontal: w *
                                                                            0.01,
                                                                        vertical:
                                                                            h * 0.01),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color:
                                                                          mainColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(w *
                                                                              0.02),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        translateString(
                                                                            "Order",
                                                                            "علي الطلب"),
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Tajawal',
                                                                            fontSize: w *
                                                                                0.04,
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.w500),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const SizedBox(),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: w * 0.45,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height:
                                                                    h * 0.01,
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
                                                                height:
                                                                    h * 0.005,
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
                                                                    text:
                                                                        TextSpan(
                                                                      children: [
                                                                        if (reItem
                                                                            .items[
                                                                                i]
                                                                            .isSale)
                                                                          TextSpan(
                                                                              text: getProductprice(currency: currency, productPrice: reItem.items[i].salePrice!),
                                                                              style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: mainColor)),
                                                                        if (!reItem
                                                                            .items[
                                                                                i]
                                                                            .isSale)
                                                                          TextSpan(
                                                                              text: getProductprice(currency: currency, productPrice: reItem.items[i].price),
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
                                                                              .items[i]
                                                                              .price),
                                                                      style:
                                                                          TextStyle(
                                                                        decorationThickness:
                                                                            w * 0.1,
                                                                        fontSize:
                                                                            w * 0.035,
                                                                        decorationColor:
                                                                            mainColor,
                                                                        decoration:
                                                                            TextDecoration.lineThrough,
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
                                                    // await getItem(
                                                    //     reItem.items[i].id);
                                                    // Navigator.pushNamed(
                                                    //     context, 'pro');
                                                    navP(
                                                      context,
                                                      Products(
                                                        fromFav: false,
                                                        productId:
                                                            reItem.items[i].id,
                                                      ),
                                                    );
                                                  },
                                                );
                                              }),
                                            )
                                          : Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: h * 0.3),
                                                child: Text(
                                                  translateString(
                                                      "No products here",
                                                      "لا توجد منتجات"),
                                                  style: TextStyle(
                                                      fontFamily: "Tajawal",
                                                      fontSize: w * 0.04,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: mainColor),
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
                                                (prefs.getString(
                                                            'language_code') ==
                                                        'en')
                                                    ? Text(
                                                        item.sorts[index],
                                                        style: TextStyle(
                                                          fontFamily: 'Tajawal',
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                      )
                                                    : Text(
                                                        item.sortsAr[index],
                                                        style: TextStyle(
                                                          fontFamily: 'Tajawal',
                                                          color:
                                                              Colors.grey[600],
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
                                                  item.sort =
                                                      item.apiSort[index];
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
                                                        Stack(
                                                          children: [
                                                            Stack(
                                                              children: [
                                                                ImageeNetworkWidget(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image: offerItem
                                                                      .items[i]
                                                                      .image,
                                                                  width:
                                                                      w * 0.45,
                                                                  height:
                                                                      h * 0.28,
                                                                ),
                                                                (offerItem.items[i]
                                                                            .isOrder ==
                                                                        1)
                                                                    ? Container(
                                                                        height: h *
                                                                            0.04,
                                                                        width: w *
                                                                            0.22,
                                                                        margin: EdgeInsets.symmetric(
                                                                            horizontal: w *
                                                                                0.01,
                                                                            vertical:
                                                                                h * 0.01),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              mainColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(w * 0.02),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            translateString("Order",
                                                                                "علي الطلب"),
                                                                            style: TextStyle(
                                                                                fontFamily: 'Tajawal',
                                                                                fontSize: w * 0.04,
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : const SizedBox(),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: w * 0.45,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height:
                                                                    h * 0.01,
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
                                                                height:
                                                                    h * 0.005,
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
                                                                    text:
                                                                        TextSpan(
                                                                      children: [
                                                                        if (offerItem
                                                                            .items[
                                                                                i]
                                                                            .isSale)
                                                                          TextSpan(
                                                                              text: getProductprice(currency: currency, productPrice: offerItem.items[i].salePrice!),
                                                                              style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: mainColor)),
                                                                        if (!offerItem
                                                                            .items[
                                                                                i]
                                                                            .isSale)
                                                                          TextSpan(
                                                                              text: getProductprice(currency: currency, productPrice: offerItem.items[i].price),
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
                                                                              .items[i]
                                                                              .price),
                                                                      style:
                                                                          TextStyle(
                                                                        decorationThickness:
                                                                            w * 0.1,
                                                                        fontSize:
                                                                            w * 0.035,
                                                                        decorationColor:
                                                                            mainColor,
                                                                        decoration:
                                                                            TextDecoration.lineThrough,
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
                                                    // await getItem(
                                                    //     offerItem.items[i].id);
                                                    // Navigator.pushNamed(
                                                    //     context, 'pro');
                                                    navP(
                                                      context,
                                                      Products(
                                                        fromFav: false,
                                                        productId: offerItem
                                                            .items[i].id,
                                                      ),
                                                    );
                                                  },
                                                );
                                              }),
                                            )
                                          : Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: h * 0.3),
                                                child: Text(
                                                  translateString(
                                                      "No products here",
                                                      "لا توجد منتجات"),
                                                  style: TextStyle(
                                                      fontFamily: "Tajawal",
                                                      fontSize: w * 0.04,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: mainColor),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
