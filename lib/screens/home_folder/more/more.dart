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
import 'package:davinshi_app/screens/home_folder/more/model/all_product_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoreScreen extends StatefulWidget {
  final String endPoint;

  const MoreScreen({Key? key, required this.endPoint}) : super(key: key);
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen>
    with SingleTickerProviderStateMixin {
  DbHelper helper = DbHelper();
  List<int> att = [];
  List<String> des = [];
  String? value;
  List sorts = [
    'Low price',
    'High price',
    'New',
  ];
  List sortsAr = [
    'سعر أقل',
    'سعر أعلي',
    'جديد',
  ];

  int page = 1;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;
  List allProduct = [];
  // This function will be called when the app launches (see the initState function)
  void firstLoad() async {
    setState(() {
      isFirstLoadRunning = true;
      allProduct = [];
    });

    try {
      final String url = domain + widget.endPoint;
      Response response = await Dio().get(
        url,
        queryParameters: {'page': page},
      );

      AllProductModel allProductModel = AllProductModel.fromJson(response.data);
      setState(() {
        allProduct = allProductModel.data!;
      });
    } catch (err) {
      print(err.toString());
    }

    setState(() {
      isFirstLoadRunning = false;
    });
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void loadMore() async {
    if (hasNextPage == true &&
        isFirstLoadRunning == false &&
        isLoadMoreRunning == false &&
        _controller.position.extentAfter < 400) {
      setState(() {
        isLoadMoreRunning = true;
        page++; // Display a progress indicator at the bottom
      });
      // Increase _page by 1
      try {
        final String url = domain + widget.endPoint;
        Response response = await Dio().get(
          url,
          queryParameters: {'page': page},
        );
        AllProductModel allProductModel =
            AllProductModel.fromJson(response.data);
        final List<Data>? fetchedPosts = allProductModel.data!;
        if (fetchedPosts!.isNotEmpty) {
          setState(() {
            allProduct.addAll(fetchedPosts);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            hasNextPage = false;
          });
        }
      } catch (err) {
        print(err.toString());
      }

      setState(() {
        isLoadMoreRunning = false;
      });
    }
  }

  late ScrollController _controller;
  @override
  void initState() {
    firstLoad();
    _controller = ScrollController()..addListener(loadMore);
    super.initState();
  }

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
              backgroundColor: mainColor,
              centerTitle: false,
              titleTextStyle:
                  const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
              title: DropdownButton<String>(
                isDense: true,
                underline: const SizedBox(),
                iconEnabledColor: Colors.white,
                iconDisabledColor: Colors.white,
                iconSize: w * 0.08,
                value: value,
                hint: Text(
                  translate(context, 'home', 'sort'),
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Tajawal'),
                ),
                items: List.generate(sorts.length, (index) {
                  return DropdownMenuItem(
                    value: sorts[index],
                    child: Column(
                      children: [
                        (prefs.getString('language_code') == 'en')
                            ? Text(
                                sorts[index],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: 'Tajawal',
                                ),
                              )
                            : Text(
                                sortsAr[index],
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
                    onTap: () {},
                  );
                }),
                onChanged: (val) {
                  setState(() {
                    value = val!;
                  });
                },
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: w * 0.01),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    // child: Icon(Icons.search,color: Colors.white,size: w*0.05,),
                    child: Badge(
                      badgeColor: const Color(0xffFF0921),
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
              child: isFirstLoadRunning
                  ? Center(
                      child: CircularProgressIndicator(
                        color: mainColor,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: h * 0.03,
                        ),
                        SizedBox(
                          height: h * 0.78,
                          child: GridView.builder(
                            controller: _controller,
                            itemCount: allProduct.length,
                            itemBuilder: (ctx, i) {
                              return InkWell(
                                  child: Padding(
                                    padding: isLeft()
                                        ? EdgeInsets.only(left: w * 0.025)
                                        : EdgeInsets.only(right: w * 0.025),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: w * 0.5,
                                            height: h * 0.25,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    allProduct[i].img),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.all(w * 0.015),
                                              child: Align(
                                                alignment: isLeft()
                                                    ? Alignment.topRight
                                                    : Alignment.topLeft,
                                                child: InkWell(
                                                  onTap: () async {
                                                    if (cartId == null ||
                                                        cartId == studentId) {
                                                      try {
                                                        if (!cart.idp.contains(
                                                            bestDis[i].id)) {
                                                          await helper.createCar(CartProducts(
                                                              id: null,
                                                              studentId:
                                                                  studentId,
                                                              image:
                                                                  allProduct[i]
                                                                      .img,
                                                              titleAr:
                                                                  allProduct[i]
                                                                      .nameAr,
                                                              titleEn:
                                                                  allProduct[i]
                                                                      .nameEn,
                                                              price: allProduct[
                                                                      i]
                                                                  .regularPrice
                                                                  .toDouble(),
                                                              quantity: 1,
                                                              att: att,
                                                              des: des,
                                                              idp: allProduct[i]
                                                                  .id,
                                                              idc: 0,
                                                              catNameEn: "",
                                                              catNameAr: "",
                                                              catSVG: ""));
                                                        } else {
                                                          int quantity = cart
                                                              .items
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .idp ==
                                                                      allProduct[
                                                                              i]
                                                                          .id)
                                                              .quantity;
                                                          await helper.updateProduct(
                                                              1 + quantity,
                                                              allProduct[i].id,
                                                              allProduct[i]
                                                                  .regularPrice
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
                                                              .contains(
                                                                  topRate[i]
                                                                      .id)) {
                                                            await helper.createCar(CartProducts(
                                                                id: null,
                                                                studentId: 0,
                                                                image: allProduct[
                                                                        i]
                                                                    .img,
                                                                titleAr:
                                                                    allProduct[
                                                                            i]
                                                                        .nameAr,
                                                                titleEn:
                                                                    allProduct[
                                                                            i]
                                                                        .nameEn,
                                                                price: allProduct[
                                                                        i]
                                                                    .regularPrice
                                                                    .toDouble(),
                                                                quantity: 1,
                                                                att: att,
                                                                des: des,
                                                                idp: allProduct[
                                                                        i]
                                                                    .id,
                                                                idc: allProduct[
                                                                        i]
                                                                    .id,
                                                                catNameEn: "",
                                                                catNameAr: "",
                                                                catSVG: ""));
                                                          } else {
                                                            int quantity = cart
                                                                .items
                                                                .firstWhere(
                                                                    (element) =>
                                                                        element
                                                                            .idp ==
                                                                        allProduct[i]
                                                                            .id)
                                                                .quantity;
                                                            await helper.updateProduct(
                                                                1 + quantity,
                                                                allProduct[i]
                                                                    .id,
                                                                allProduct[i]
                                                                    .regularPrice
                                                                    .toDouble(),
                                                                jsonEncode(att),
                                                                jsonEncode(
                                                                    des));
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
                                                        Icons.add_outlined,
                                                        color: Colors.white,
                                                        size: w * 0.05,
                                                      ),
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
                                                  width: w * 0.45,
                                                  constraints: BoxConstraints(
                                                    maxHeight: h * 0.07,
                                                  ),
                                                  child: Text(
                                                      translateString(
                                                          allProduct[i].nameEn,
                                                          allProduct[i].nameAr),
                                                      style: TextStyle(
                                                          fontSize: w * 0.035),
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                              SizedBox(
                                                height: h * 0.005,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        if (allProduct[i]
                                                            .inSale)
                                                          TextSpan(
                                                              text: getProductprice(
                                                                  currency:
                                                                      currency,
                                                                  productPrice:
                                                                      allProduct[
                                                                              i]
                                                                          .salePrice),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Tajawal',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      mainColor)),
                                                        if (!allProduct[
                                                                i]
                                                            .inSale)
                                                          TextSpan(
                                                              text: getProductprice(
                                                                  currency:
                                                                      currency,
                                                                  productPrice:
                                                                      allProduct[
                                                                              i]
                                                                          .regularPrice),
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
                                                  if (allProduct[i].inSale)
                                                    Text(
                                                      getProductprice(
                                                          currency: currency,
                                                          productPrice:
                                                              allProduct[i]
                                                                  .salePrice),
                                                      style: TextStyle(
                                                        fontSize: w * 0.035,
                                                        decorationThickness:
                                                            w * 0.1,
                                                        decorationColor:
                                                            mainColor,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
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
                                    await getItem(allProduct[i].id);
                                    Navigator.pushReplacementNamed(
                                        context, 'pro');
                                  });
                            },
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: h * 0.001,
                                    mainAxisSpacing: w * 0.05,
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.8),
                          ),
                        ),

                        if (isLoadMoreRunning == true)
                          Padding(
                            padding: EdgeInsets.only(
                                top: h * 0.01, bottom: h * 0.01),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: mainColor,
                              ),
                            ),
                          ),

                        // When nothing else to load
                        if (hasNextPage == false)
                          Container(
                            padding: EdgeInsets.only(
                                top: h * 0.01, bottom: h * 0.01),
                            color: Colors.white,
                            child: Text(
                              translate(context, 'contac_us', 'paginate'),
                              style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: w * 0.04,
                                  color: mainColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
            )),
      ),
    );
  }
}
