// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/products_cla.dart';
import 'package:davinshi_app/provider/cart_provider.dart';
import 'package:davinshi_app/provider/student_product.dart';
import 'package:davinshi_app/provider/student_provider.dart';
import '../cart/cart.dart';

class StudentInfo extends StatefulWidget {
  final StudentClass studentClass;
  StudentInfo({Key? key, required this.studentClass}) : super(key: key);
  @override
  _StudentInfo createState() => _StudentInfo();
}

class _StudentInfo extends State<StudentInfo> {
  int counter = 0;
  final ScrollController _controller = ScrollController();
  final ScrollController _controller2 = ScrollController();
  bool f1 = true, finish = false;
  void start(context) {
    studentId = widget.studentClass.id;
    var of1 = Provider.of<StudentItemProvider>(context, listen: true);
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        if (_controller.position.pixels != 0) {
          if (f1) {
            if (!of1.finish) {
              f1 = false;
              dialog(context);
              of1.getItems(widget.studentClass.id).then((value) {
                Navigator.pop(context);
                f1 = true;
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
              dialog(context);
              of1.getItems(widget.studentClass.id).then((value) {
                Navigator.pop(context);
                f1 = true;
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
                              'assets/facebook.svg',
                              'assets/inst.svg',
                              widget.studentClass.facebook ?? 'Empty',
                              widget.studentClass.instagram ?? 'Empty'),
                          SizedBox(
                            height: h * 0.03,
                          ),
                          row(
                              w,
                              'assets/twitter.svg',
                              'assets/link.svg',
                              widget.studentClass.twitter ?? 'Empty',
                              widget.studentClass.linkedin ?? 'Empty'),
                          SizedBox(
                            height: h * 0.03,
                          ),
                          row(
                              w,
                              'assets/tele.svg',
                              'assets/email.svg',
                              widget.studentClass.phone,
                              widget.studentClass.email),
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
          elevation: 5,
          leading: const BackButton(color: Colors.white),
          actions: [
            Padding(
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
            SizedBox(
              width: w * 0.02,
            ),
          ],
          backgroundColor: mainColor,
          iconTheme: IconThemeData(color: mainColor),
        ),
        body: Center(
          child: SizedBox(
            width: w,
            height: h * 0.9,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: h * 0.01,
                  ),
                  if (widget.studentClass.cover != null)
                    Container(
                      height: h * 0.2,
                      width: w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.studentClass.cover!),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  if (widget.studentClass.cover != null)
                    SizedBox(
                      height: h * 0.01,
                    ),
                  Material(
                    elevation: 1,
                    child: SizedBox(
                      width: w,
                      height: h * 0.07,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: h * 0.07,
                            child: Center(
                              child: Consumer<StudentItemProvider>(
                                builder: (context, newItem, _) {
                                  return DropdownButton<String>(
                                    isDense: true,
                                    underline: const SizedBox(),
                                    iconEnabledColor: mainColor,
                                    iconDisabledColor: mainColor,
                                    iconSize: w * 0.08,
                                    hint: Text(
                                        translate(context, 'student', 'sort'),
                                        style: const TextStyle(
                                          color: Colors.black,
                                        )),
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
                                                      color: Colors.grey[600],
                                                      fontFamily: 'Tajawal',
                                                    ),
                                                  ),
                                            Divider(
                                              color: mainColor,
                                            )
                                          ],
                                        ),
                                        onTap: () {
                                          newItem.sortList(index);
                                        },
                                      );
                                    }),
                                    onChanged: (val) {},
                                    value: newItem.sort,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.015,
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
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      if (item.offers[i].isSale)
                                                        TextSpan(
                                                            text:
                                                                '${item.offers[i].salePrice}'
                                                                ' ${prefs.getString("currency").toString()} ',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black)),
                                                      if (!item
                                                          .offers[i].isSale)
                                                        TextSpan(
                                                            text:
                                                                '${item.offers[i].price} '
                                                                '${prefs.getString("currency").toString()} ',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black)),
                                                      if (item.offers[i]
                                                              .isSale &&
                                                          item.offers[i]
                                                                  .disPer !=
                                                              null)
                                                        TextSpan(
                                                            text:
                                                                item.offers[i]
                                                                        .disPer! +
                                                                    '%',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .red)),
                                                    ],
                                                  ),
                                                ),
                                                if (item.offers[i].isSale)
                                                  Text(
                                                    '${item.offers[i].price} '
                                                    '${prefs.getString("currency").toString()}',
                                                    style: TextStyle(
                                                      fontSize: w * 0.035,
                                                      decoration: TextDecoration
                                                          .lineThrough,
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
                                      dialog(context);
                                      await getItem(item.offers[i].id);
                                      Navigator.pushReplacementNamed(
                                          context, 'pro');
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
                  SizedBox(
                    height: h * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.025),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          translate(context, 'student', 'all_products'),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: w * 0.05,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: w * 0.95,
                    child: Consumer<StudentItemProvider>(
                        builder: (context, item, _) {
                      if (item.items.isEmpty || item.items.isEmpty) {
                        return SizedBox(
                          width: w,
                          height: h * 0.5,
                          child: Center(
                            child: Text(
                              translate(context, 'empty', 'no_products'),
                              style: TextStyle(
                                  color: mainColor, fontSize: w * 0.05),
                            ),
                          ),
                        );
                      } else {
                        return Wrap(
                          children: List.generate(item.items.length, (i) {
                            return InkWell(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: i.isOdd ? w * 0.025 : 0,
                                    bottom: h * 0.02,
                                    left: i.isOdd ? w * 0.025 : 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: w * 0.45,
                                      height: h * 0.28,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        image: DecorationImage(
                                          image:
                                              NetworkImage(item.items[i].image),
                                          // image: AssetImage('assets/food${i+1}.png'),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(w * 0.015),
                                        child: Align(
                                          alignment: isLeft()
                                              ? Alignment.bottomLeft
                                              : Alignment.bottomRight,
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
                                    SizedBox(
                                      width: w * 0.45,
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
                                                      item.items[i].nameEn,
                                                      item.items[i].nameAr),
                                                  style: TextStyle(
                                                      fontSize: w * 0.035),
                                                  overflow: TextOverflow.fade)),
                                          SizedBox(
                                            height: h * 0.005,
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                if (item.items[i].isSale)
                                                  TextSpan(
                                                      text:
                                                          '${item.items[i].salePrice}'
                                                          ' ${prefs.getString("currency").toString()} ',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black)),
                                                if (!item.items[i].isSale)
                                                  TextSpan(
                                                      text:
                                                          '${item.items[i].price}'
                                                          ' ${prefs.getString("currency").toString()} ',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black)),
                                                if (item.items[i].isSale &&
                                                    item.items[i].disPer !=
                                                        null)
                                                  TextSpan(
                                                      text: item.items[i]
                                                              .disPer! +
                                                          '%',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.red)),
                                              ],
                                            ),
                                          ),
                                          if (item.items[i].isSale)
                                            Text(
                                              '${item.items[i].price} '
                                              '${prefs.getString("currency").toString()}',
                                              style: TextStyle(
                                                fontSize: w * 0.035,
                                                decoration:
                                                    TextDecoration.lineThrough,
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
                                dialog(context);
                                await getItem(item.items[i].id);
                                Navigator.pushReplacementNamed(context, 'pro');
                              },
                            );
                          }),
                        );
                      }
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

  Widget row(w, svg1, svg2, text1, text2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: w * 0.05,
          backgroundColor: Colors.white,
          child: SvgPicture.asset(svg1),
        ),
        SizedBox(
          width: w * 0.02,
        ),
        Expanded(
          child: Text(
            text1,
            style: TextStyle(color: mainColor, fontSize: w * 0.029),
          ),
        ),
        CircleAvatar(
          radius: w * 0.05,
          backgroundColor: Colors.white,
          child: SvgPicture.asset(svg2),
        ),
        SizedBox(
          width: w * 0.02,
        ),
        Expanded(
          child: Text(
            text2,
            style: TextStyle(color: mainColor, fontSize: w * 0.029),
          ),
        ),
      ],
    );
  }
}
