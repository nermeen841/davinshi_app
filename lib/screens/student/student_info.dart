// ignore_for_file: prefer_const_constructors_in_immutables
import 'package:badges/badges.dart';
import 'package:davinshi_app/elements/newtwork_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/products_cla.dart';
import 'package:davinshi_app/provider/cart_provider.dart';
import 'package:davinshi_app/provider/student_product.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/home_item.dart';
import '../cart/cart.dart';
import '../product_info/products.dart';

class StudentInfo extends StatefulWidget {
  final dynamic studentClass;
  final int studentId;
  StudentInfo({Key? key, required this.studentClass, required this.studentId})
      : super(key: key);
  @override
  _StudentInfo createState() => _StudentInfo();
}

class _StudentInfo extends State<StudentInfo> {
  int counter = 0;
  final ScrollController _controller = ScrollController();
  final ScrollController _controller2 = ScrollController();
  bool f1 = true, finish = false;
  bool isLoading = false;
  var currency = (prefs.getString('language_code').toString() == 'en')
      ? prefs.getString('currencyEn').toString()
      : prefs.getString('currencyAr').toString();
  int currentIndex = 0;
  late PageController pageController;
  @override
  void initState() {
    pageController = PageController(initialPage: currentIndex);
    super.initState();
  }

  void start(context) {
    isLoading = false;
    studentId = widget.studentClass.id;
    var of1 = Provider.of<StudentItemProvider>(context, listen: false);
    of1.getItems(widget.studentClass.id).then((value) {
      isLoading = true;
    });
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        if (_controller.position.pixels != 0) {
          if (f1) {
            if (!of1.finish) {
              f1 = false;
              isLoading = false;
              of1.getItems(widget.studentClass.id).then((value) {
                f1 = true;
                isLoading = true;
              });
            }
          }
        }
      }
    });
    _controller2.addListener(() {
      if (_controller2.position.atEdge) {
        if (_controller2.position.pixels != 0) {
          if (f1) {
            if (!of1.finish) {
              f1 = false;
              isLoading = false;
              of1.getItems(widget.studentClass.id).then((value) {
                f1 = true;
                isLoading = true;
              });
            }
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    studentId = 0;
    _controller.dispose();
    _controller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    if (!finish) {
      start(context);
      finish = true;
    }
    CartProvider cart = Provider.of<CartProvider>(context, listen: true);
    return Directionality(
      textDirection: getDirection(),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.grey[200]!.withOpacity(0.85),
                  insetPadding: EdgeInsets.all(w * 0.05),
                  child: Padding(
                    padding: isLeft()
                        ? EdgeInsets.only(
                            top: h * 0.01,
                            bottom: h * 0.02,
                            right: w * 0.03,
                            left: w * 0.04)
                        : EdgeInsets.only(
                            top: h * 0.01,
                            bottom: h * 0.02,
                            left: w * 0.03,
                            right: w * 0.04),
                    child: Container(
                      width: w * 0.93,
                      constraints: BoxConstraints(
                        minHeight: h * 0.4,
                        maxHeight: h * 0.5,
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: w * 0.12,
                            backgroundColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: widget.studentClass.image == null
                                  ? CircleAvatar(
                                      radius: w * 0.1,
                                      backgroundImage:
                                          const AssetImage('assets/logo2.png'),
                                    )
                                  : CircleAvatar(
                                      radius: w * 0.1,
                                      backgroundImage: NetworkImage(
                                          widget.studentClass.image!),
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: h * 0.02,
                          ),
                          Text(
                            widget.studentClass.name ?? '',
                            style:
                                TextStyle(color: mainColor, fontSize: w * 0.05),
                          ),
                          SizedBox(
                            height: h * 0.02,
                          ),
                          row(
                              w,
                              'assets/facebook-logo.png',
                              'assets/instagram.png',
                              widget.studentClass.facebook ?? 'Empty',
                              widget.studentClass.instagram ?? 'Empty',
                              () async {
                            await launch(widget.studentClass.facebook);
                          }, () async {
                            await launch(widget.studentClass.instagram);
                          }),
                          SizedBox(
                            height: h * 0.03,
                          ),
                          row(
                              w,
                              'assets/twitter.png',
                              'assets/linkedin.png',
                              widget.studentClass.twitter ?? 'Empty',
                              widget.studentClass.linkedin ?? 'Empty',
                              () async {
                            await launch(widget.studentClass.twitter);
                          }, () async {
                            await launch(widget.studentClass.linkedin);
                          }),
                          SizedBox(
                            height: h * 0.03,
                          ),
                          row(
                              w,
                              'assets/phone-receiver-silhouette.png',
                              'assets/email.png',
                              widget.studentClass.phone,
                              widget.studentClass.email, () async {
                            await launch('tel: ${widget.studentClass.phone}');
                          }, () async {
                            final Uri params = Uri(
                              scheme: 'mailto',
                              path: widget.studentClass.email,
                            );
                            String url = params.toString();
                            await launch(url);
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          backgroundColor: mainColor,
          child: Center(
            child: Icon(
              Icons.call,
              color: Colors.white,
              size: w * 0.08,
            ),
          ),
        ),
        appBar: AppBar(
          title: Text(
            widget.studentClass.name ?? '',
            style: TextStyle(color: Colors.white, fontSize: w * 0.04),
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: w * 0.05,
              height: h * 0.01,
              margin: EdgeInsets.symmetric(
                  horizontal: w * 0.02, vertical: h * 0.017),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(w * 0.01)),
              child: Icon(
                Icons.arrow_back,
                color: mainColor,
              ),
            ),
          ),
          elevation: 0.0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(5),
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
            SizedBox(
              width: w * 0.02,
            ),
          ],
          backgroundColor: mainColor,
        ),
        body: Center(
          child: SizedBox(
            width: w,
            height: h * 0.9,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (getAds(9).isNotEmpty)
                    SizedBox(
                      height: h * 0.3,
                      child: Swiper(
                        pagination: const SwiperPagination(
                            builder: DotSwiperPaginationBuilder(
                                color: Colors.white54,
                                activeColor: Colors.white),
                            alignment: Alignment.bottomCenter),
                        itemCount: getAds(9).length,
                        itemBuilder: (BuildContext context, int i) {
                          Ads _ads = getAds(9)[i];
                          return InkWell(
                            child: ImageeNetworkWidget(
                              height: h * 0.2 + 5,
                              width: w,
                              image: _ads.image,
                              fit: BoxFit.cover,
                            ),
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              if (_ads.inApp) {
                                if (_ads.type) {
                                  navP(
                                      context,
                                      Products(
                                        fromFav: false,
                                        productId: int.parse(_ads.link),
                                      ));
                                }
                              } else {
                                await canLaunch(_ads.link)
                                    ? await launch(_ads.link)
                                    : throw 'Could not launch ${_ads.link}';
                              }
                            },
                          );
                        },
                        autoplay: true,
                        autoplayDelay: 5000,
                      ),
                    ),
                  SizedBox(
                    height: h * 0.01,
                  ),

                  SizedBox(
                    width: w * 0.95,
                    child: Consumer<StudentItemProvider>(
                        builder: (context, item, _) {
                      if (item.offers.isNotEmpty) {
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: w * 0.025),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    translate(context, 'home', 'offers'),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: w * 0.045,
                                        fontFamily: 'Tajawal'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: h * 0.01,
                            ),
                            SizedBox(
                              width: w,
                              height: h * 0.4,
                              child: ListView.builder(
                                itemCount: item.offers.length,
                                scrollDirection: Axis.horizontal,
                                controller: _controller2,
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
                                            width: w * 0.4,
                                            height: h * 0.25,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    item.offers[i].image),
                                                fit: BoxFit.fitHeight,
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
                                                            item.offers[i]
                                                                .nameEn,
                                                            item.offers[i]
                                                                .nameAr),
                                                        style: TextStyle(
                                                            fontSize:
                                                                w * 0.035),
                                                        overflow:
                                                            TextOverflow.fade)),
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
                                                          if (item
                                                              .offers[i].isSale)
                                                            TextSpan(
                                                                text:
                                                                    '${item.offers[i].salePrice}' +
                                                                        currency,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        mainColor)),
                                                          if (!item
                                                              .offers[i].isSale)
                                                            TextSpan(
                                                                text:
                                                                    '${item.offers[i].price} '
                                                                    '$currency',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color:
                                                                        mainColor)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (item.offers[i].isSale)
                                                  Text(
                                                    '${item.offers[i].price} '
                                                    '$currency',
                                                    style: TextStyle(
                                                      fontSize: w * 0.035,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      decorationColor:
                                                          mainColor,
                                                      decorationThickness: 20,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      navP(
                                          context,
                                          Products(
                                            fromFav: false,
                                            productId: item.offers[i].id,
                                          ));
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),
                  ),
                  // SizedBox(
                  //   height: h * 0.01,
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: w * 0.025),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         translate(context, 'student', 'all_products'),
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: w * 0.05,
                  //           fontFamily: 'Tajawal',
                  //         ),
                  //       ),
                  //       Divider(
                  //         color: mainColor,
                  //         thickness: 3,
                  //         endIndent: 250,
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  SizedBox(
                    height: h * 0.03,
                  ),
                  SizedBox(
                    width: w,
                    height: h * 0.07,
                    child: Center(
                      child: Consumer<StudentItemProvider>(
                        builder: (context, newItem, _) {
                          return Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: List.generate(
                                  newItem.sorts.length,
                                  (index) => buildOrderStatus(
                                    index: index,
                                    text:
                                        (prefs.getString('language_code') == 'en')
                                            ? newItem.sorts[index]
                                            : newItem.sortsAr[index],
                                    press: () async {
                                      pageController.animateToPage(index,
                                          duration:
                                              const Duration(microseconds: 500),
                                          curve: Curves.fastOutSlowIn);
                            
                                      if (f1) {
                                        f1 = false;
                                        isLoading = false;
                                        setState(() {
                                          setState(() {
                                            newItem.sortList(
                                                index,
                                                widget.studentClass.id
                                                    .toString());
                                            newItem.sort = newItem.apiSort[index];
                                          });
                                        });
                                       start(context);
                                        await newItem
                                            .getItems(widget.studentClass.id)
                                            .then((value) {
                                          setState(() {
                                            f1 = true;
                                            isLoading = true;
                                          });
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                          // return DropdownButton<String>(
                          //   isDense: true,
                          //   underline: const SizedBox(),
                          //   iconEnabledColor: mainColor,
                          //   iconDisabledColor: mainColor,
                          //   iconSize: w * 0.08,
                          //   hint: Text(
                          //       translate(context, 'student', 'sort'),
                          //       style: const TextStyle(
                          //         color: Colors.black,
                          //       )),
                          //   items: List.generate(newItem.sorts.length,
                          //       (index) {
                          //     return DropdownMenuItem(
                          //       value: newItem.sorts[index],
                          //       child: Column(
                          //         children: [
                          //           (prefs.getString('language_code') ==
                          //                   'en')
                          //               ? Text(
                          //                   newItem.sorts[index],
                          //                   style: TextStyle(
                          //                     color: Colors.grey[600],
                          //                     fontFamily: 'Tajawal',
                          //                   ),
                          //                 )
                          //               : Text(
                          //                   newItem.sortsAr[index],
                          //                   style: TextStyle(
                          //                     color: Colors.grey[600],
                          //                     fontFamily: 'Tajawal',
                          //                   ),
                          //                 ),
                          //           Divider(
                          //             color: mainColor,
                          //           )
                          //         ],
                          //       ),
                          //       onTap: () {
                          //         setState(() {
                          //           newItem.sortList(
                          //               index,
                          //               widget.studentClass.id
                          //                   .toString());
                          //           newItem.sort =
                          //               newItem.apiSort[index];
                          //         });
                          //       },
                          //     );
                          //   }),
                          //   onChanged: (val) {},
                          //   // value: newItem.sort,
                          // );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  SizedBox(
                    width: w * 0.95,
                    height: h,
                    child: Consumer<StudentItemProvider>(
                        builder: (context, item, _) {
                      return PageView.builder(
                          controller: pageController,
                          itemCount: 4,
                          physics: const NeverScrollableScrollPhysics(),
                          onPageChanged: (index) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            if (!isLoading) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: mainColor,
                                ),
                              );
                            } else {
                              return (item.items.isNotEmpty)
                                  ? GridView.builder(
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisSpacing: h * 0.001,
                                              mainAxisSpacing: w * 0.05,
                                              crossAxisCount: 2,
                                              childAspectRatio: 0.75),
                                      itemCount: item.items.length,
                                      itemBuilder: (context, i) {
                                        return InkWell(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: i.isOdd ? w * 0.025 : 0,
                                                bottom: h * 0.02,
                                                left: i.isOdd ? w * 0.025 : 0),
                                            child: Container(
                                              width: w * 0.45,
                                              height: h * 0.35,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    spreadRadius: 3,
                                                    blurRadius: 3,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: w * 0.45,
                                                    height: h * 0.25,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      image: DecorationImage(
                                                        image: NetworkImage(item
                                                            .items[i].image),
                                                        fit: BoxFit.fitHeight,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: w * 0.45,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  w * 0.02),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
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
                                                                      item
                                                                          .items[
                                                                              i]
                                                                          .nameEn,
                                                                      item
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
                                                                    if (item
                                                                        .items[
                                                                            i]
                                                                        .isSale)
                                                                      TextSpan(
                                                                          text: getProductprice(
                                                                              currency: currency,
                                                                              productPrice: item.items[i].salePrice!),
                                                                          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: mainColor)),
                                                                    if (!item
                                                                        .items[
                                                                            i]
                                                                        .isSale)
                                                                      TextSpan(
                                                                          text: getProductprice(
                                                                              currency: currency,
                                                                              productPrice: item.items[i].price),
                                                                          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, color: mainColor)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          if (item
                                                              .items[i].isSale)
                                                            Text(
                                                              getProductprice(
                                                                  currency:
                                                                      currency,
                                                                  productPrice:
                                                                      item
                                                                          .items[
                                                                              i]
                                                                          .price),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      w * 0.035,
                                                                  fontFamily:
                                                                      'Tajawal',
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  color: Colors
                                                                      .grey,
                                                                  decorationColor:
                                                                      mainColor,
                                                                  decorationThickness:
                                                                      20),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                           
                                            navP(
                                                context,
                                                Products(
                                                  fromFav: false,
                                                  productId: item.items[i].id,
                                                  brandId: widget.studentClass.id,
                                                ));
                                          },
                                        );
                                      })
                                  : SizedBox(
                                      width: w,
                                      height: h * 0.5,
                                      child: Center(
                                        child: Text(
                                          translate(
                                              context, 'empty', 'no_products'),
                                          style: TextStyle(
                                              color: mainColor,
                                              fontSize: w * 0.05),
                                        ),
                                      ),
                                    );
                            }
                          });
                    }),
                  ),
                  SizedBox(
                    height: h * 0.08,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildOrderStatus(
      {required int index, required String text, required VoidCallback press}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: w * 0.01),
      child: InkWell(
        onTap: press,
        child: Container(
       
         width: w*0.3,
          height: h * 0.08,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(0, 2)
              ),
            ],
              borderRadius: BorderRadius.circular(w * 0.015),
              border: Border.all(color: currentIndex == index ? Colors.white : mainColor),
              color: currentIndex == index ? mainColor : Colors.white),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: w * 0.04,
                color: currentIndex == index ? Colors.white : Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget row(
      w, svg1, svg2, text1, text2, VoidCallback press1, VoidCallback press2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        (text1 != 'Empty')
            ? InkWell(
                onTap: press1,
                child: CircleAvatar(
                  radius: w * 0.05,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    svg1,
                    fit: BoxFit.contain,
                    color: mainColor,
                    width: w * 0.05,
                  ),
                ),
              )
            : const SizedBox(),
        (text1 != 'Empty')
            ? SizedBox(
                width: w * 0.02,
              )
            : const SizedBox(),
        (text1 != 'Empty')
            ? Expanded(
                child: InkWell(
                  onTap: press1,
                  child: Text(
                    text1,
                    style: TextStyle(color: mainColor, fontSize: w * 0.029),
                  ),
                ),
              )
            : const SizedBox(),
        (text2 != 'Empty')
            ? InkWell(
                onTap: press2,
                child: CircleAvatar(
                  radius: w * 0.05,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    svg2,
                    fit: BoxFit.contain,
                    color: mainColor,
                    width: w * 0.05,
                  ),
                ),
              )
            : const SizedBox(),
        (text2 != 'Empty')
            ? SizedBox(
                width: w * 0.02,
              )
            : const SizedBox(),
        (text2 != 'Empty')
            ? Expanded(
                child: InkWell(
                  onTap: press2,
                  child: Text(
                    text2,
                    style: TextStyle(color: mainColor, fontSize: w * 0.029),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
