// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/cart.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/fav.dart';
import 'package:davinshi_app/models/products_cla.dart';
import 'package:davinshi_app/models/rate.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/provider/cart_provider.dart';
import 'package:davinshi_app/screens/auth/login.dart';
import 'package:davinshi_app/screens/cart/cart.dart';
import 'package:davinshi_app/screens/product_info/image.dart';
import 'package:simple_star_rating/simple_star_rating.dart';
import '../../dbhelper.dart';

class Products extends StatefulWidget {
  final bool fromFav;
  final int brandId;
  const Products({Key? key, required this.fromFav, required this.brandId})
      : super(key: key);
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  DbHelper helper = DbHelper();
  String selectefCat = '';
  final List<String> _hint = language == 'en'
      ? ['Full name', 'E-mail', 'phone number', 'Title', 'Message']
      : [
          'الاسم بالكامل',
          'البريد الاكتروني',
          'رقم الهاتف',
          'العنوان',
          'المحتوى'
        ];
  String getText(int index) {
    return _listEd[index].text;
  }

  Future sendReq() async {
    final String url = domain +
        'contact?name=${getText(0)}&email=${getText(1)}&phone=${getText(2)}&title=${getText(3)}&message=${getText(4)}';
    try {
      Response response = await Dio().post(url);
      if (response.data['status'] == 0) {
        String data = '';
        if (language == 'ar') {
          response.data['message'].forEach((e) {
            data += e + '\n';
          });
        } else {
          response.data['message'].forEach((e) {
            data += e + '\n';
          });
        }
        final snackBar = SnackBar(
          content: Text(data),
          action: SnackBarAction(
            label: translate(context, 'snack_bar', 'undo'),
            disabledTextColor: Colors.yellow,
            textColor: Colors.yellow,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _btnController2.stop();
      }
      if (response.statusCode == 200) {
        _btnController2.stop();
        alertSuccessData(context, 'Question Sent');
      }
    } catch (e) {
      print('e');
      print(e);
      _btnController2.error();
      await Future.delayed(const Duration(seconds: 2));
      _btnController2.stop();
    }
  }

  final List<FocusNode> _listFocus =
      List<FocusNode>.generate(5, (_) => FocusNode());
  final List<TextEditingController> _listEd =
      List<TextEditingController>.generate(
          5,
          (_) => _ == 3
              ? language == 'en'
                  ? TextEditingController(
                      text: 'Question about ${productCla.nameEn}')
                  : TextEditingController(text: 'سوال عن ${productCla.nameAr}')
              : TextEditingController());
  List<Rate> rate = [];
  List<int> att = [];
  List<String> des = [];
  double stars = 5.0;
  String rating = '';
  bool check = false, error = false;
  bool finish = false;
  num finalPrice =
      productCla.isOffer ? productCla.offerPrice! : productCla.price;
  final RoundedLoadingButtonController _btnController2 =
      RoundedLoadingButtonController();
  late TabController _tabBar;
  // String text='Humidity is one of the most important factors that determine a comfortable indoor environment. I will introduce a dehumidifier in the living workshop that will catch the damp moisture all over the house. If you gently place it in a closet, chest of drawers, shelf, or shoe cabinet, it collects moisture enough to fill a bucket full of water. Thanks to the neat achromatic package design, it does not pop out no matter where you put it, so please put it in every corner.';
  // String text2='The more everyday items you use, the longer you need to focus on the basics. Under the slogan of Keep the basics, create life, Life Workshop is a brand that makes household items that can be used comfortably in everyday life. In order to satisfy all of the unique designs, reasonable prices, and good ingredients, we are developing daily products by communicating with consumers as well as researching data. Thanks to this, we can find products that improve the quality of life in the closest places to our lives, such as rubber gloves made of latex, durable hangers, disposable loofahs, and wool dryer balls. Now, try using the various household items of the living workshop through Curly. You can experience a daily life that makes cleaning up all over the house more enjoyable and makes washing and washing dishes easier.';
  // String text3='Strict Products Committee';
  // String text4='With the heart of choosing products for me and my family to eat and use, I try and experience the products myself every week, and only sell products that pass various standards such as ingredients, taste, and stability.';
  Future getRates() async {
    final String url =
        domain + 'product/get-ratings?product_id=${productCla.id.toString()}';
    try {
      dio.Response response = await dio.Dio().get(
        url,
      );
      if (response.statusCode == 200 && response.data['status'] == 1) {
        rate = [];
        response.data['data'].forEach((e) {
          rate.add(Rate(rate: e['rating'], comment: e['comment']));
        });
        setState(() {});
      } else {}
    } catch (e) {
      print(e);
    }
  }

  Future saveRate() async {
    final String url = domain + 'save-rating';
    try {
      dio.Response response = await dio.Dio().post(
        url,
        data: {
          "product_id": productCla.id,
          "rating": stars,
          'comment': rating,
        },
        options: dio.Options(headers: {"auth-token": auth}),
      );
      if (response.statusCode == 200) {
        //getRates();
        alertSuccessData(context, translate(context, 'home', 'review'));
        _btnController.success();
        await Future.delayed(const Duration(milliseconds: 2500));
        _btnController.stop();
      } else {
        _btnController.error();
        await Future.delayed(const Duration(milliseconds: 2500));
        _btnController.stop();
      }
    } catch (e) {
      print(e);
      _btnController.error();
      await Future.delayed(const Duration(milliseconds: 2500));
      _btnController.stop();
    }
  }

  Future saveLike(bool type) async {
    final String url = domain + 'product/like';
    try {
      dio.Response response = await dio.Dio().post(
        url,
        data: {
          'brand_id': widget.fromFav ? widget.brandId : studentId,
          "product_id": productCla.id,
        },
        options: dio.Options(headers: {"auth-token": auth}),
      );
      if (response.statusCode == 200 && response.data['status'] == 1) {
        check = type;
        if (type) {
          favIds.add(productCla.id);
        } else {
          favIds.remove(productCla.id);
        }
        setState(() {});
      } else {
        final snackBar = SnackBar(
          content: Text(translate(context, 'snack_bar', 'try')),
          action: SnackBarAction(
            label: translate(context, 'snack_bar', 'undo'),
            disabledTextColor: Colors.yellow,
            textColor: Colors.yellow,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      final snackBar = SnackBar(
        content: Text(translate(context, 'snack_bar', 'try')),
        action: SnackBarAction(
          label: translate(context, 'snack_bar', 'undo'),
          disabledTextColor: Colors.yellow,
          textColor: Colors.yellow,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  bool finishTab = true;
  @override
  void initState() {
    super.initState();
    // List<int> _list = [];
    // List<String> _des = [];
    for (int i = 0; i < productCla.attributes.length; i++) {
      // _list.add(productCla.attributes[i].options[0].id);
      // _des.add(productCla.attributes[i].options[0].nameEn);
      // if(i==productCla.attributes.length-1){
      //   finalPrice = productCla.attributes[i].options[0].price;
      // }
      des.add('');
      att.add(0);
    }
    // att = _list;
    // des = _des;
    _tabBar = TabController(length: 5, vsync: this);
    _tabBar.addListener(() {
      if (_tabBar.index == 3) {
        if (finishTab) {
          finishTab = false;
          dialog(context);
          getRates().then((value) {
            navPop(context);
            finishTab = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    CartProvider cart = Provider.of<CartProvider>(context, listen: true);
    void show(context) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (context) {
          int _counter = 1;
          return StatefulBuilder(
            builder: (context, setState2) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  width: w,
                  height: h * 0.25,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: w * 0.05, right: w * 0.05),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: h * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                child: CircleAvatar(
                                  backgroundColor: mainColor,
                                  radius: w * 0.045,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: w * 0.04,
                                  ),
                                ),
                                onTap: () {
                                  setState2(() {
                                    _counter++;
                                  });
                                },
                              ),
                              SizedBox(
                                  width: w * 0.15,
                                  height: h * 0.05,
                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(50),
                                  //   border: Border.all(color: mainColor,width: 1),
                                  //   color: Colors.white,
                                  // ),
                                  child: Center(
                                      child: Text(
                                    _counter.toString(),
                                    style: TextStyle(
                                      color: mainColor,
                                      fontSize: w * 0.04,
                                    ),
                                  ))),
                              InkWell(
                                child: CircleAvatar(
                                  backgroundColor: mainColor,
                                  radius: w * 0.045,
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: w * 0.04,
                                  ),
                                ),
                                onTap: () {
                                  if (_counter > 1) {
                                    setState2(() {
                                      _counter--;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: h * 0.02,
                          ),
                          InkWell(
                            child: Container(
                              width: login ? w * 0.7 : w * 0.9,
                              height: h * 0.07,
                              decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                  child: Text(
                                translate(context, 'buttons', 'add'),
                                style: TextStyle(
                                    color: Colors.white, fontSize: w * 0.05),
                              )),
                            ),
                            onTap: () async {
                              if (!widget.fromFav) {
                                if (cartId == null || cartId == studentId) {
                                  try {
                                    if (!cart.idp.contains(productCla.id)) {
                                      await helper.createCar(CartProducts(
                                          id: null,
                                          studentId: studentId,
                                          image: productCla.image,
                                          titleAr: productCla.nameAr,
                                          titleEn: productCla.nameEn,
                                          price: finalPrice.toDouble(),
                                          quantity: _counter,
                                          att: att,
                                          des: des,
                                          idp: productCla.id,
                                          idc: productCla.cat.id,
                                          catNameEn: productCla.cat.nameEn,
                                          catNameAr: productCla.cat.nameAr,
                                          catSVG: productCla.cat.svg));
                                    } else {
                                      int quantity = cart.items
                                          .firstWhere((element) =>
                                              element.idp == productCla.id)
                                          .quantity;
                                      await helper.updateProduct(
                                          _counter + quantity,
                                          productCla.id,
                                          finalPrice.toDouble(),
                                          jsonEncode(att),
                                          jsonEncode(des));
                                    }
                                    await cart.setItems();
                                  } catch (e) {
                                    print('e');
                                    print(e);
                                  }
                                  Navigator.pop(context);
                                } else {
                                  setState2(() {
                                    error = true;
                                  });
                                }
                              } else {
                                if (cartId == null ||
                                    cartId == widget.brandId) {
                                  try {
                                    if (!cart.idp.contains(productCla.id)) {
                                      await helper.createCar(CartProducts(
                                          id: null,
                                          studentId: widget.brandId,
                                          image: productCla.image,
                                          titleAr: productCla.nameAr,
                                          titleEn: productCla.nameEn,
                                          price: finalPrice.toDouble(),
                                          quantity: _counter,
                                          att: att,
                                          des: des,
                                          idp: productCla.id,
                                          idc: productCla.cat.id,
                                          catNameEn: productCla.cat.nameEn,
                                          catNameAr: productCla.cat.nameAr,
                                          catSVG: productCla.cat.svg));
                                    } else {
                                      int quantity = cart.items
                                          .firstWhere((element) =>
                                              element.idp == productCla.id)
                                          .quantity;
                                      await helper.updateProduct(
                                          _counter + quantity,
                                          productCla.id,
                                          finalPrice.toDouble(),
                                          jsonEncode(att),
                                          jsonEncode(des));
                                    }
                                    await cart.setItems();
                                  } catch (e) {
                                    print('e');
                                    print(e);
                                  }
                                  Navigator.pop(context);
                                } else {
                                  setState2(() {
                                    error = true;
                                  });
                                }
                              }
                            },
                          ),
                          if (error)
                            SizedBox(
                              height: h * 0.02,
                            ),
                          if (error)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  translate(context, 'product', 'error_cart'),
                                  style: TextStyle(
                                      color: mainColor2, fontSize: w * 0.035),
                                ),
                                InkWell(
                                  child: Text(
                                    translate(
                                      context,
                                      'buttons',
                                      'error_cart',
                                    ),
                                    style: TextStyle(
                                        color: mainColor2, fontSize: w * 0.035),
                                  ),
                                  onTap: () async {
                                    await dbHelper.deleteAll();
                                    await cart.setItems();
                                    try {
                                      if (!cart.idp.contains(productCla.id)) {
                                        await helper.createCar(CartProducts(
                                            id: null,
                                            studentId: widget.fromFav
                                                ? widget.brandId
                                                : studentId,
                                            image: productCla.image,
                                            titleAr: productCla.nameAr,
                                            titleEn: productCla.nameEn,
                                            price: finalPrice.toDouble(),
                                            quantity: _counter,
                                            att: att,
                                            des: des,
                                            idp: productCla.id,
                                            idc: productCla.cat.id,
                                            catNameEn: productCla.cat.nameEn,
                                            catNameAr: productCla.cat.nameAr,
                                            catSVG: productCla.cat.svg));
                                      } else {
                                        int quantity = cart.items
                                            .firstWhere((element) =>
                                                element.idp == productCla.id)
                                            .quantity;
                                        await helper.updateProduct(
                                            _counter + quantity,
                                            productCla.id,
                                            finalPrice.toDouble(),
                                            jsonEncode(att),
                                            jsonEncode(des));
                                      }
                                      await cart.setItems();
                                      error = false;
                                    } catch (e) {
                                      print('e');
                                      print(e);
                                      error = false;
                                    }
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          SizedBox(
                            height: h * 0.05,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        isScrollControlled: true,
      );
    }

    var currency = (prefs.getString('language_code').toString() == 'en')
        ? prefs.getString('currencyEn').toString()
        : prefs.getString('currencyAr').toString();
    if (!finish) {
      if (favIds.contains(productCla.id)) {
        check = true;
        if (mounted) {
          setState(() {});
        }
      } else {
        check = false;
      }
      finish = true;
    }

    return Directionality(
      textDirection: getDirection(),
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: mainColor,
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
            bottom: PreferredSize(
              preferredSize: Size(w, h * 0.07),
              child: Container(
                width: w,
                color: Colors.white,
                child: TabBar(
                  controller: _tabBar,
                  tabs: [
                    Tab(
                      text: translate(context, 'product', 'tab1'),
                    ),
                    Tab(
                      text: translate(context, 'product', 'tab2'),
                    ),
                    Tab(
                      text: translate(context, 'product', 'tab3'),
                    ),
                    Tab(
                      text: translate(context, 'product', 'tab4'),
                    ),
                    Tab(
                      text: translate(context, 'product', 'tab5'),
                    ),
                  ],
                  overlayColor: MaterialStateProperty.all(Colors.white),
                  unselectedLabelColor: Colors.grey,
                  indicatorWeight: 3,
                  automaticIndicatorColorAdjustment: true,
                  labelColor: mainColor2,
                  isScrollable: true,
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabBar,
                  children: [
                    SizedBox(
                      width: w,
                      height: h,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          Stack(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Img(productCla.image)));
                                  // showCatchDialog(
                                  //     context: context,
                                  //     image: productCla.image);
                                },
                                child: Container(
                                  width: w,
                                  height: h * 0.4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    image: DecorationImage(
                                        image: NetworkImage(productCla.image),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              Align(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Icon(
                                    Icons.zoom_out_map_outlined,
                                    color: mainColor,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: h * 0.01,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                            child: SizedBox(
                              width: w,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: w * 0.4,
                                      child: Text(
                                        translateString(productCla.nameEn,
                                            productCla.nameAr),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: w * 0.04),
                                      )),

                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: translate(
                                            context, 'home', 'seller_name'),
                                        style: TextStyle(
                                          fontFamily: 'Tajawal',
                                          fontSize: w * 0.04,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    TextSpan(
                                        text: translate(
                                            context, 'home', 'seller'),
                                        style: TextStyle(
                                          fontSize: w * 0.04,
                                          fontFamily: 'Tajawal',
                                          color: mainColor,
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ]))
                                  // SizedBox(width: w*0.8,child: Text(productCla.descriptionEn,style: TextStyle(fontWeight: FontWeight.bold,fontSize: w*0.04,color: Colors.grey),)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: h * 0.03,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: w * 0.025),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: translate(
                                                context, 'product', 'price') +
                                            " :  ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Tajawal',
                                            fontSize: w * 0.045,
                                            color: Colors.black),
                                      ),
                                      if (productCla.isOffer)
                                        TextSpan(
                                            text: productCla.offerPrice
                                                    .toString() +
                                                ' '
                                                    '$currency',
                                            style: TextStyle(
                                                fontFamily: 'Tajawal',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: w * 0.05)),
                                      if (!productCla.isOffer)
                                        TextSpan(
                                            text: productCla.price.toString() +
                                                ' $currency',
                                            style: TextStyle(
                                                fontFamily: 'Tajawal',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: w * 0.05)),
                                    ],
                                  ),
                                ),
                                if (productCla.isOffer)
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: w * 0.025),
                                        child: Text(
                                          productCla.price.toString() +
                                              ' $currency',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: w * 0.04,
                                              color: Colors.grey,
                                              fontFamily: 'Tajawal',
                                              decorationColor: mainColor,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                      ),
                                      SizedBox(
                                        height: h * 0.01,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: w * 0.025),
                                        child: RichText(
                                            text: TextSpan(children: [
                                          if (productCla.isOffer &&
                                              productCla.percentage != null)
                                            TextSpan(
                                                text: translate(context, 'home',
                                                    'discount'),
                                                style: TextStyle(
                                                    fontFamily: 'Tajawal',
                                                    fontWeight: FontWeight.w400,
                                                    color: mainColor,
                                                    fontSize: w * 0.04)),
                                          if (productCla.isOffer &&
                                              productCla.percentage != null)
                                            TextSpan(
                                                text: productCla.percentage! +
                                                    '%',
                                                style: TextStyle(
                                                    fontFamily: 'Tajawal',
                                                    fontWeight: FontWeight.w400,
                                                    color: mainColor,
                                                    fontSize: w * 0.05)),
                                        ])),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          // SizedBox(height: h*0.01,),
                          // if(!login)InkWell(
                          //   child: Padding(
                          //     padding:  EdgeInsets.symmetric(horizontal: w*0.025),
                          //     child: Text(translate(context,'product','sign_up'),style: TextStyle(fontWeight: FontWeight.bold,fontSize: w*0.035,color: mainColor),),
                          //   ),
                          //   onTap: (){
                          //
                          //   },
                          // ),
                          // SizedBox(
                          //   height: h * 0.04,
                          // ),
                          // Padding(
                          //   padding:
                          //       EdgeInsets.symmetric(horizontal: w * 0.025),
                          //   child: Row(
                          //     children: [
                          //       Expanded(
                          //           child: Container(
                          //               width: 1,
                          //               child: Divider(
                          //                 color: Colors.grey,
                          //                 thickness: h * 0.001,
                          //               ))),
                          //       SizedBox(
                          //         width: w * 0.02,
                          //       ),
                          //       Text(
                          //         translate(context, 'product', 'cat'),
                          //         style: TextStyle(
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: w * 0.045,
                          //             color: mainColor),
                          //       ),
                          //       SizedBox(
                          //         width: w * 0.02,
                          //       ),
                          //       Expanded(
                          //           child: Container(
                          //               width: 1,
                          //               child: Divider(
                          //                 color: Colors.grey,
                          //                 thickness: h * 0.001,
                          //               ))),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: h * 0.02,
                          // ),
                          // Padding(
                          //   padding:
                          //       EdgeInsets.symmetric(horizontal: w * 0.025),
                          //   child: Wrap(
                          //     children: productCla.categories.map((e) {
                          //       return InkWell(
                          //         child: Padding(
                          //           padding: EdgeInsets.only(
                          //               top: h * 0.01, right: w * 0.015),
                          //           child: Container(
                          //             decoration: BoxDecoration(
                          //               borderRadius: BorderRadius.circular(25),
                          //               color: selectefCat == e.nameEn ||
                          //                       selectefCat == e.nameAr
                          //                   ? mainColor
                          //                   : Colors.white,
                          //               border: Border.all(color: mainColor),
                          //               // border: Border.all(color: Colors.grey[400]!),
                          //             ),
                          //             child: Padding(
                          //               padding: EdgeInsets.fromLTRB(w * 0.04,
                          //                   h * 0.01, w * 0.04, h * 0.007),
                          //               child: Text(
                          //                   translateString(e.nameEn, e.nameAr),
                          //                   style: TextStyle(
                          //                     fontWeight: FontWeight.bold,
                          //                     fontSize: w * 0.035,
                          //                     color: selectefCat == e.nameEn ||
                          //                             selectefCat == e.nameAr
                          //                         ? Colors.white
                          //                         : mainColor,
                          //                   )),
                          //             ),
                          //           ),
                          //         ),
                          //         onTap: () async {
                          //           setState(() {
                          //             selectefCat = e.nameEn;
                          //           });
                          //           dialog(context);
                          //           Provider.of<NewPackageItemProvider>(context,
                          //                   listen: false)
                          //               .clearList();
                          //           // Provider.of<RePackageItemProvider>(context,listen: false).clearList();
                          //           // Provider.of<BestPackageItemProvider>(context,listen: false).clearList();
                          //           await Provider.of<NewPackageItemProvider>(
                          //                   context,
                          //                   listen: false)
                          //               .getItems(e.catId);
                          //           Navigator.pushReplacement(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (ctx) => MultiplePackages(
                          //                         id: e.catId,
                          //                       )));
                          //         },
                          //       );
                          //     }).toList(),
                          //   ),
                          //  ),
                          SizedBox(
                            height: h * 0.04,
                          ),
                          for (int q = 0; q < productCla.attributes.length; q++)
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: w * 0.025),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        translateString(
                                            productCla.attributes[q].nameEn,
                                            productCla.attributes[q].nameAr),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: w * 0.04,
                                            color: mainColor),
                                      ),
                                      Wrap(
                                        children: [
                                          for (int i = 0;
                                              i <
                                                  productCla.attributes[q]
                                                      .options.length;
                                              i++)
                                            Padding(
                                              padding: isLeft()
                                                  ? EdgeInsets.only(
                                                      right: w * 0.025)
                                                  : EdgeInsets.only(
                                                      left: w * 0.025),
                                              child: InkWell(
                                                onTap: () {
                                                  // if(q==productCla.attributes.length-1){
                                                  //   finalPrice = productCla.attributes[q].options[i].price;
                                                  // }
                                                  if (att[q] !=
                                                      productCla.attributes[q]
                                                          .options[i].id) {
                                                    finalPrice = productCla
                                                        .attributes[q]
                                                        .options[i]
                                                        .price;
                                                  }
                                                  setState(() {
                                                    att[q] = productCla
                                                        .attributes[q]
                                                        .options[i]
                                                        .id;
                                                    if (language == 'en') {
                                                      des[q] = productCla
                                                          .attributes[q]
                                                          .options[i]
                                                          .nameEn;
                                                    } else {
                                                      des[q] = productCla
                                                          .attributes[q]
                                                          .options[i]
                                                          .nameAr;
                                                    }
                                                  });
                                                  print(att);
                                                  print(des);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: att[q] ==
                                                              productCla
                                                                  .attributes[q]
                                                                  .options[i]
                                                                  .id
                                                          ? mainColor
                                                          : Colors.white),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        w * 0.03),
                                                    child: Text(
                                                      translateString(
                                                          productCla
                                                              .attributes[q]
                                                              .options[i]
                                                              .nameEn,
                                                          productCla
                                                              .attributes[q]
                                                              .options[i]
                                                              .nameAr),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: w * 0.035,
                                                          color: att[q] ==
                                                                  productCla
                                                                      .attributes[
                                                                          q]
                                                                      .options[
                                                                          i]
                                                                      .id
                                                              ? Colors.white
                                                              : mainColor),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: h * 0.01,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                ],
                              ),
                            ),
                          if (productCla.hasOptions)
                            SizedBox(
                              height: h * 0.01,
                            ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: w * 0.025),
                            child: Row(
                              children: [
                                Expanded(
                                    child: SizedBox(
                                        width: 1,
                                        child: Divider(
                                          color: Colors.grey,
                                          thickness: h * 0.001,
                                        ))),
                                SizedBox(
                                  width: w * 0.02,
                                ),
                                Text(
                                  translate(context, 'product', 'des'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: w * 0.045,
                                      color: mainColor),
                                ),
                                SizedBox(
                                  width: w * 0.02,
                                ),
                                Expanded(
                                    child: SizedBox(
                                        width: 1,
                                        child: Divider(
                                          color: Colors.grey,
                                          thickness: h * 0.001,
                                        ))),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: h * 0.04,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: w * 0.025),
                            child: Text(
                              translateString(productCla.descriptionEn,
                                  productCla.descriptionAr),
                              style: TextStyle(
                                  color: Colors.grey, fontSize: w * 0.03),
                            ),
                          ),
                          SizedBox(
                            height: h * 0.02,
                          ),
                          if (productCla.aboutEn != null)
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: w * 0.025),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: SizedBox(
                                          width: 1,
                                          child: Divider(
                                            color: Colors.grey,
                                            thickness: h * 0.001,
                                          ))),
                                  SizedBox(
                                    width: w * 0.02,
                                  ),
                                  Text(
                                    translate(context, 'product', 'about'),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: w * 0.045,
                                        color: mainColor),
                                  ),
                                  SizedBox(
                                    width: w * 0.02,
                                  ),
                                  Expanded(
                                      child: SizedBox(
                                          width: 1,
                                          child: Divider(
                                            color: Colors.grey,
                                            thickness: h * 0.001,
                                          ))),
                                ],
                              ),
                            ),
                          if (productCla.aboutEn != null)
                            SizedBox(
                              height: h * 0.04,
                            ),
                          if (productCla.aboutEn != null)
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: w * 0.025),
                              child: Text(
                                translateString(
                                    productCla.aboutEn!, productCla.aboutAr!),
                                style: TextStyle(
                                    color: Colors.grey, fontSize: w * 0.03),
                              ),
                            ),
                          if (productCla.aboutEn != null)
                            SizedBox(
                              height: h * 0.04,
                            ),
                          if (productCla.about.isNotEmpty)
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: w * 0.025),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: SizedBox(
                                          width: 1,
                                          child: Divider(
                                            color: Colors.grey,
                                            thickness: h * 0.001,
                                          ))),
                                  SizedBox(
                                    width: w * 0.02,
                                  ),
                                  Text(
                                    '${translate(context, 'product', 'why')} davinshi',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: w * 0.045,
                                        color: mainColor),
                                  ),
                                  SizedBox(
                                    width: w * 0.02,
                                  ),
                                  Expanded(
                                      child: SizedBox(
                                          width: 1,
                                          child: Divider(
                                            color: Colors.grey,
                                            thickness: h * 0.001,
                                          ))),
                                ],
                              ),
                            ),
                          if (productCla.about.isNotEmpty)
                            SizedBox(
                              height: h * 0.02,
                            ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: w * 0.025),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(productCla.about.length,
                                  (index) {
                                return SizedBox(
                                  width: w * 0.9,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: mainColor,
                                      radius: w * 0.05,
                                      child: Center(
                                        child: Icon(
                                          Icons.assignment_outlined,
                                          color: Colors.white,
                                          size: w * 0.06,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      translateString(
                                          productCla.about[index].nameEn,
                                          productCla.about[index].nameAr),
                                      style: TextStyle(
                                          color: mainColor, fontSize: w * 0.04),
                                    ),
                                    subtitle: Text(
                                      translateString(
                                          productCla.about[index].valueEn,
                                          productCla.about[index].valueEn),
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: w * 0.035),
                                    ),
                                    minVerticalPadding: h * 0.02,
                                  ),
                                );
                              }),
                            ),
                          ),
                          SizedBox(
                            height: h * 0.1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: w,
                      height: h,
                      child: SingleChildScrollView(
                        child: Column(
                          children:
                              List.generate(productCla.images.length, (i) {
                            return InkWell(
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: h * 0.02),
                                child: Container(
                                  width: w,
                                  height: h * 0.28,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    image: DecorationImage(
                                      image: NetworkImage(productCla.images[i]),
                                      // image: AssetImage('assets/food${i+1}.png'),
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Img(productCla.images[i])));
                              },
                            );
                          }),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: w,
                      height: h,
                      child: productCla.statements.isEmpty
                          ? Center(
                              child: Text(
                                translate(context, 'empty', 'no_details'),
                                style: TextStyle(
                                    color: mainColor, fontSize: w * 0.05),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.all(w * 0.025),
                              child: ListView.builder(
                                itemCount: productCla.statements.length,
                                itemBuilder: (ctx, i) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(w * 0.025),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: w * 0.25,
                                              child: Text(
                                                translateString(
                                                    productCla
                                                        .statements[i].nameEn,
                                                    productCla
                                                        .statements[i].nameAr),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: w * 0.035),
                                              ),
                                            ),
                                            SizedBox(
                                              width: w * 0.02,
                                            ),
                                            // Container(
                                            //   child: Text(translateString(productCla.statements[i].valueEn, productCla.statements[i].valueAr),style: TextStyle(color: Colors.grey[400],fontWeight: FontWeight.bold,fontSize: w*0.035),),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.grey[300],
                                        thickness: h * 0.001,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                    ),
                    Center(
                      child: SizedBox(
                        width: w * 0.9,
                        height: h,
                        child: rate.isEmpty
                            ? SingleChildScrollView(
                                child: Column(
                                  children: [
                                    // SizedBox(height: h*0.02,),
                                    // InkWell(
                                    //   child: Container(
                                    //     width: w*0.9,
                                    //     height: h*0.07,
                                    //     decoration: BoxDecoration(
                                    //         color: Colors.white,
                                    //         borderRadius: BorderRadius.circular(7),
                                    //         border: Border.all(color: mainColor)
                                    //     ),
                                    //     child: Center(child: Text('Add Comment',style: TextStyle(color: mainColor,fontSize: w*0.05),)),
                                    //   ),
                                    //   onTap: (){
                                    //     Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Login(true)));
                                    //   },
                                    // ),
                                    // SizedBox(height: h*0.01,),
                                    // Align(
                                    //   child: Text('Some reviews',style: TextStyle(fontWeight: FontWeight.bold,fontSize: w*0.05),),
                                    //   alignment: Alignment.centerLeft,
                                    // ),
                                    // SizedBox(height: h*0.04,),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Text('Review',style: TextStyle(fontSize: w*0.04),),
                                    //     Icon(Icons.image_outlined,size: w*0.04,),
                                    //   ],
                                    // ),
                                    // SizedBox(height: h*0.01,),
                                    // Divider(color: Colors.grey[300],thickness: h*0.001,),
                                    // SizedBox(height: h*0.01,),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Text('Review',style: TextStyle(fontSize: w*0.04),),
                                    //     Icon(Icons.image_outlined,size: w*0.04,),
                                    //   ],
                                    // ),
                                    // SizedBox(height: h*0.01,),
                                    // Divider(color: Colors.grey[300],thickness: h*0.001,),
                                    // SizedBox(height: h*0.01,),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    //   children: [
                                    //     BackButton(onPressed: (){
                                    //
                                    //     },color: Colors.grey[300],),
                                    //     Text('See All',style: TextStyle(fontSize: w*0.04),),
                                    //   ],
                                    // ),
                                    // if (login)
                                    SizedBox(
                                      height: h * 0.02,
                                    ),
                                    // if (login)
                                    Directionality(
                                      textDirection: getDirection(),
                                      child: SimpleStarRating(
                                        starCount: 5,
                                        rating: 5,
                                        allowHalfRating: true,
                                        size: w * 0.08,
                                        isReadOnly: false,
                                        onRated: (rate) {
                                          setState(() {
                                            stars = rate!;
                                          });
                                        },
                                        spacing: 10,
                                      ),
                                    ),
                                    // if (login)
                                    SizedBox(
                                      height: h * 0.03,
                                    ),
                                    // if (login)
                                    TextFormField(
                                      cursorColor: Colors.black,
                                      minLines: 1,
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                        focusedBorder: form2(),
                                        enabledBorder: form2(),
                                        errorBorder: form2(),
                                        focusedErrorBorder: form2(),
                                        hintText: translate(
                                            context, 'inputs', 'comment'),
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        errorMaxLines: 1,
                                        errorStyle:
                                            TextStyle(fontSize: w * 0.03),
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          rating = val;
                                        });
                                      },
                                    ),
                                    // if (login)
                                    SizedBox(
                                      height: h * 0.03,
                                    ),
                                    // if (login)
                                    RoundedLoadingButton(
                                      borderRadius: 15,
                                      child: Container(
                                        height: h * 0.08,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: mainColor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            translate(
                                                context, 'buttons', 'send'),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: w * 0.045,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      controller: _btnController,
                                      successColor: mainColor,
                                      color: mainColor,
                                      disabledColor: mainColor,
                                      onPressed: () async {
                                        if (login) {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          saveRate();
                                        } else {
                                          final snackBar = SnackBar(
                                            content: Text(translate(
                                                context, 'snack_bar', 'login')),
                                            action: SnackBarAction(
                                              label: translate(
                                                  context, 'buttons', 'login'),
                                              disabledTextColor: Colors.yellow,
                                              textColor: Colors.yellow,
                                              onPressed: () {
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const Login()),
                                                    (route) => false);
                                              },
                                            ),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                          _btnController.error();
                                          Future.delayed(
                                              const Duration(seconds: 1));
                                          _btnController.stop();
                                        }
                                      },
                                    ),

                                    // if (login)
                                    SizedBox(
                                      height: h * 0.03,
                                    ),
                                    for (int i = 0; i < rate.length; i++)
                                      Padding(
                                        padding:
                                            EdgeInsets.only(bottom: h * 0.05),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: const AssetImage(
                                                'assets/logo2.png'),
                                            radius: w * 0.07,
                                            backgroundColor: Colors.transparent,
                                          ),
                                          title: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: w * 0.25,
                                                height: h * 0.02,
                                                child: RatingBarIndicator(
                                                  rating: double.parse(
                                                      rate[i].rate.toString()),
                                                  itemBuilder:
                                                      (context, index) => Icon(
                                                    Icons.star,
                                                    size: w * 0.045,
                                                    color:
                                                        const Color(0xffEE5A30),
                                                  ),
                                                  itemCount: 5,
                                                  itemSize: w * 0.045,
                                                  direction: Axis.horizontal,
                                                ),
                                              ),
                                            ],
                                          ),
                                          subtitle: SizedBox(
                                              width: w * 0.37,
                                              child: Text(
                                                rate[i].comment!,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: w * 0.04),
                                              )),
                                        ),
                                      ),
                                  ],
                                ),
                              )
                            : Center(
                                child: Text(
                                  translate(context, 'empty', 'no_rate'),
                                  style: TextStyle(
                                      color: mainColor, fontSize: w * 0.05),
                                ),
                              ),
                      ),
                    ),
                    // Center(
                    //   child: Container(
                    //     width: w*0.9,
                    //     height: h,
                    //     child: SingleChildScrollView(
                    //       child: Column(
                    //         children: [
                    //           SizedBox(height: h*0.02,),
                    //           InkWell(
                    //             child: Container(
                    //               width: w*0.9,
                    //               height: h*0.07,
                    //               decoration: BoxDecoration(
                    //                   color: Colors.white,
                    //                   borderRadius: BorderRadius.circular(7),
                    //                   border: Border.all(color: mainColor)
                    //               ),
                    //               child: Center(child: Text('Product Inquiry',style: TextStyle(color: mainColor,fontSize: w*0.05),)),
                    //             ),
                    //             onTap: (){
                    //               Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Login(true)));
                    //             },
                    //           ),
                    //           SizedBox(height: h*0.01,),
                    //           Align(
                    //             child: Text('Some questions',style: TextStyle(fontWeight: FontWeight.bold,fontSize: w*0.05),),
                    //             alignment: Alignment.centerLeft,
                    //           ),
                    //           SizedBox(height: h*0.04,),
                    //           Column(
                    //             children: List.generate(7, (index) {
                    //               return Column(
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   Padding(
                    //                     padding:  EdgeInsets.all(w*0.025),
                    //                     child: Column(
                    //                       crossAxisAlignment: CrossAxisAlignment.start,
                    //                       children: [
                    //                         Text('Product Inquiry',style: TextStyle(fontWeight: FontWeight.bold,fontSize: w*0.035),),
                    //                         // Text('Answered  | 1/7/2021',style: TextStyle(fontWeight: FontWeight.bold,fontSize: w*0.035,color: mainColor),),
                    //                         RichText(
                    //                           text: TextSpan(
                    //                               children:[
                    //                                 TextSpan(text: 'Answered  ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: w*0.035,color: mainColor),),
                    //                                 TextSpan(text: '| 1/7/2021',style: TextStyle(fontSize: w*0.035,color: Colors.grey),),
                    //                               ]
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   Divider(color: Colors.grey[300],thickness: h*0.001,),
                    //                 ],
                    //               );
                    //             }),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Form(
                      key: _formKey,
                      child: Center(
                        child: SizedBox(
                          width: w * 0.9,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Column(
                                  children:
                                      List.generate(_listFocus.length, (index) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: h * 0.03,
                                        ),
                                        TextFormField(
                                          cursorColor: Colors.black,
                                          readOnly: index == 3 ? true : false,
                                          controller: _listEd[index],
                                          focusNode: _listFocus[index],
                                          textInputAction: index == 4
                                              ? TextInputAction.newline
                                              : TextInputAction.next,
                                          keyboardType: index == 1
                                              ? TextInputType.emailAddress
                                              : index == 4
                                                  ? TextInputType.multiline
                                                  : TextInputType.text,
                                          inputFormatters: index != 1
                                              ? null
                                              : [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(
                                                          r"[0-9 a-z  @ .]")),
                                                ],
                                          maxLines: index != 4 ? 1 : 6,
                                          onEditingComplete: () {
                                            _listFocus[index].unfocus();
                                            if (index < _listEd.length - 1) {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _listFocus[index + 1]);
                                            }
                                          },
                                          validator: (value) {
                                            if (index == 1) {
                                              if (value!.length < 4 ||
                                                  !value.endsWith('.com') ||
                                                  '@'
                                                          .allMatches(value)
                                                          .length !=
                                                      1) {
                                                return translate(
                                                    context,
                                                    'validation',
                                                    'valid_email');
                                              }
                                            }
                                            if (index != 1) {
                                              if (value!.isEmpty) {
                                                return translate(context,
                                                    'validation', 'field');
                                              }
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            focusedBorder: form(),
                                            enabledBorder: form(),
                                            errorBorder: form(),
                                            focusedErrorBorder: form(),
                                            hintText: _hint[index],
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400]),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                                SizedBox(
                                  height: h * .04,
                                ),
                                RoundedLoadingButton(
                                  child: SizedBox(
                                    width: w * 0.9,
                                    height: h * 0.07,
                                    child: Center(
                                        child: Text(
                                      translate(context, 'buttons', 'send'),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: w * 0.05),
                                    )),
                                  ),
                                  controller: _btnController2,
                                  successColor: mainColor,
                                  color: mainColor,
                                  disabledColor: mainColor,
                                  errorColor: Colors.red,
                                  onPressed: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    if (_formKey.currentState!.validate()) {
                                      sendReq();
                                    } else {
                                      _btnController2.error();
                                      await Future.delayed(
                                          const Duration(seconds: 2));
                                      _btnController2.stop();
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: h * .05,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: w,
                height: h * 0.1,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 0.1,
                      ),
                      InkWell(
                        child: Container(
                          width: w * 0.7,
                          height: h * 0.07,
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                              child: Text(
                            translate(context, 'buttons', 'add_cart') +
                                "     " +
                                '$finalPrice $currency',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    language == 'en' ? w * 0.05 : w * 0.06),
                          )),
                        ),
                        onTap: () {
                          // if (login) {
                          show(context);
                          // } else {
                          //   final snackBar = SnackBar(
                          //     content: Text(
                          //         translate(context, 'snack_bar', 'login')),
                          //     action: SnackBarAction(
                          //       label: translate(context, 'buttons', 'login'),
                          //       disabledTextColor: Colors.yellow,
                          //       textColor: Colors.yellow,
                          //       onPressed: () {
                          //         Navigator.pushAndRemoveUntil(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (context) => const Login()),
                          //             (route) => false);
                          //       },
                          //     ),
                          //   );
                          //   ScaffoldMessenger.of(context)
                          //       .showSnackBar(snackBar);
                          // }
                        },
                      ),
                      const SizedBox(
                        width: 0.1,
                      ),
                      check
                          ? InkWell(
                              child: Container(
                                width: w * 0.2,
                                height: h * 0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey[400]!),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.favorite,
                                    color: mainColor,
                                  ),
                                ),
                              ),
                              onTap: () {
                                if (login) {
                                  dialog(context);
                                  saveLike(false)
                                      .then((value) => navPop(context));
                                } else {
                                  final snackBar = SnackBar(
                                    content: Text(translate(
                                        context, 'snack_bar', 'login')),
                                    action: SnackBarAction(
                                      label: translate(
                                          context, 'buttons', 'login'),
                                      disabledTextColor: Colors.yellow,
                                      textColor: Colors.yellow,
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Login()),
                                            (route) => false);
                                      },
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                            )
                          : InkWell(
                              child: Container(
                                width: w * 0.2,
                                height: h * 0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.grey[400]!),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.favorite_border,
                                    color: mainColor,
                                  ),
                                ),
                              ),
                              onTap: () {
                                if (login) {
                                  dialog(context);
                                  saveLike(true)
                                      .then((value) => navPop(context));
                                } else {
                                  final snackBar = SnackBar(
                                    content: Text(translate(
                                        context, 'snack_bar', 'login')),
                                    action: SnackBarAction(
                                      label: translate(
                                          context, 'buttons', 'login'),
                                      disabledTextColor: Colors.yellow,
                                      textColor: Colors.yellow,
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Login()),
                                            (route) => false);
                                      },
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                            ),
                      const SizedBox(
                        width: 0.1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

InputBorder form2() {
  return UnderlineInputBorder(
    borderSide: BorderSide(color: (Colors.grey[350]!), width: 1),
    borderRadius: BorderRadius.circular(25),
  );
}

InputBorder form() {
  return OutlineInputBorder(
    borderSide: BorderSide(color: mainColor, width: 1.5),
    borderRadius: BorderRadius.circular(15),
  );
}
