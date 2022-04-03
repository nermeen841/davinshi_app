// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, unrelated_type_equality_checks

import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:davinshi_app/screens/auth/sign_upScreen.dart';
import 'package:davinshi_app/screens/product%20rating/addRate.dart';
import 'package:davinshi_app/screens/product_info/similar.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
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
  List<int> selectedItem = [];
  List<num> optionsPrice = [];
  Map<String, num> attPrice = {};
  List<int> optionsQuantity = [];
  bool check = false, error = false;
  bool finish = false;
  num finalPrice =
      productCla.isOffer ? productCla.offerPrice! : productCla.price;
  final RoundedLoadingButtonController _btnController2 =
      RoundedLoadingButtonController();
  TabController? _tabBar;
  Future getRates() async {
    final String url = domain + 'product/get-ratings';
    try {
      dio.Response response = await dio.Dio()
          .get(url, queryParameters: {'product_id': productCla.id.toString()});
      print(productCla.id.toString());
      rate = [];
      if (response.statusCode == 200 && response.data['status'] == 1) {
        setState(() {
          response.data['data'].forEach((e) {
            rate.add(Rate(rate: e['rating'], comment: e['comment']));
          });
        });
      } else {
        print(response.data);
      }
    } catch (e) {
      print(e);
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
    selectedItem = [];
    for (int i = 0; i < productCla.attributes.length; i++) {
      des.add('');
      att.add(0);
      optionsPrice.add(0);
      optionsQuantity.add(0);
      attPrice[''] = 0;
    }
    _tabBar = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabBar?.addListener(() {
      if (_tabBar?.index == 1) {
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
                                    if (selectedItem.isNotEmpty) {
                                      optionsQuantity.forEach((element) async {
                                        if (element >= counter) {
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
                                          await cart.setItems();
                                        } else {
                                          final snackBar = SnackBar(
                                            content: Text(
                                              translateString(
                                                  'product amount not available',
                                                  'كمية المنتج غير متاحة حاليا '),
                                              style: TextStyle(
                                                  fontFamily: 'Tajawal',
                                                  fontSize: w * 0.04,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            action: SnackBarAction(
                                              label: translateString(
                                                  "Undo", "تراجع"),
                                              disabledTextColor: Colors.yellow,
                                              textColor: Colors.yellow,
                                              onPressed: () {},
                                            ),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      });
                                    } else {
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
                                    }
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
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: mainColor,
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: w * 0.01),
                child: Padding(
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
                  labelColor: mainColor,
                  indicatorColor: Colors.brown.withOpacity(0.8),
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
                    Stack(
                      children: [
                        SizedBox(
                          width: w,
                          height: h,
                          child: Stack(
                            children: [
                              (productCla.images.isEmpty)
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Img(
                                                      productCla.image,
                                                      images: const [],
                                                    )));
                                      },
                                      child: Container(
                                        width: w,
                                        height: h * 0.4,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  productCla.image),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: h * 0.4,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Img(
                                                        productCla.image,
                                                        images:
                                                            productCla.images,
                                                      )));
                                        },
                                        child: Swiper(
                                          autoplayDelay: 5000,
                                          pagination: SwiperPagination(
                                              builder:
                                                  DotSwiperPaginationBuilder(
                                                      color: mainColor
                                                          .withOpacity(0.3),
                                                      activeColor: mainColor),
                                              alignment:
                                                  Alignment.bottomCenter),
                                          itemCount: productCla.images.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              width: w,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        productCla
                                                            .images[index]),
                                                    fit: BoxFit.cover),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: h * 0.02),
                                    child: Icon(
                                      Icons.zoom_out_map_outlined,
                                      color: mainColor,
                                    ),
                                  ),
                                  (productCla.isOffer)
                                      ? Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: w * 0.01,
                                              vertical: h * 0.01),
                                          child: CircleAvatar(
                                            radius: w * 0.07,
                                            backgroundColor: mainColor,
                                            child: Center(
                                              child: Text(
                                                productCla.percentage
                                                        .toString() +
                                                    "%",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Tajawal',
                                                    fontSize: w * 0.04,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: w,
                          height: h,
                          margin: EdgeInsets.only(top: h * 0.3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(w * 0.03),
                              topRight: Radius.circular(w * 0.03),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: w * 0.02, vertical: h * 0.02),
                                  child: SizedBox(
                                    width: w,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: w * 0.55,
                                          child: Text(
                                            translateString(productCla.nameEn,
                                                productCla.nameAr),
                                            maxLines: 3,
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: w * 0.04),
                                          ),
                                        ),
                                        SizedBox(
                                          width: w * 0.01,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (productCla.isOffer)
                                              Text(
                                                  productCla.offerPrice
                                                          .toString() +
                                                      ' '
                                                          '$currency',
                                                  style: TextStyle(
                                                      fontFamily: 'Tajawal',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: mainColor,
                                                      fontSize: w * 0.05)),
                                            if (!productCla.isOffer)
                                              Text(
                                                  productCla.price.toString() +
                                                      ' $currency',
                                                  style: TextStyle(
                                                      fontFamily: 'Tajawal',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: mainColor,
                                                      fontSize: w * 0.05)),
                                            if (productCla.isOffer)
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: w * 0.03),
                                                child: Text(
                                                  '${productCla.price}'
                                                  ' $currency',
                                                  style: TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: w * 0.05,
                                                    color: Colors.grey,
                                                    fontFamily: 'Tajawal',
                                                    decorationThickness:
                                                        w * 0.1,
                                                    decorationColor: mainColor,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: h * 0.015),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: translate(
                                                context, 'home', 'seller_name'),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                                fontSize: w * 0.035)),
                                        TextSpan(
                                            text: (productCla.sellerName !=
                                                    null)
                                                ? productCla.sellerName
                                                    .toString()
                                                : (productCla.brandName != null)
                                                    ? productCla.brandName
                                                        .toString()
                                                    : translateString(
                                                        'Multi', 'مالتي'),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                                fontSize: w * 0.035)),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: h * 0.04,
                                ),
                                if (productCla.attributes.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w * 0.025),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: List.generate(
                                        productCla.attributes.length,
                                        (index) => InkWell(
                                          onTap: () {
                                            homeBottomSheet(
                                              context: context,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: w * 0.04,
                                                    vertical: h * 0.04),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      translateString(
                                                          productCla
                                                              .attributes[index]
                                                              .nameEn,
                                                          productCla
                                                              .attributes[index]
                                                              .nameAr),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: w * 0.05,
                                                          fontFamily: 'Tajawal',
                                                          color: Colors.black),
                                                    ),
                                                    ListView.builder(
                                                        primary: true,
                                                        shrinkWrap: true,
                                                        itemCount: productCla
                                                            .attributes[index]
                                                            .options
                                                            .length,
                                                        itemBuilder:
                                                            (context, i) {
                                                          return Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: h *
                                                                            0.02),
                                                                child: Text(
                                                                  translateString(
                                                                      productCla
                                                                          .attributes[
                                                                              index]
                                                                          .options[
                                                                              i]
                                                                          .nameEn,
                                                                      productCla
                                                                          .attributes[
                                                                              index]
                                                                          .options[
                                                                              i]
                                                                          .nameAr),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize: w *
                                                                          0.05,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              Radio(
                                                                  activeColor:
                                                                      mainColor,
                                                                  value: productCla
                                                                      .attributes[
                                                                          index]
                                                                      .options[
                                                                          i]
                                                                      .id,
                                                                  groupValue:
                                                                      att[
                                                                          index],
                                                                  onChanged: (int?
                                                                      value) {
                                                                    setState(
                                                                      () {
                                                                        print(
                                                                            attPrice);
                                                                        if (productCla.attributes[index].nameEn ==
                                                                            attPrice[productCla.attributes[index].nameEn]) {
                                                                          attPrice.updateAll(((key, value) => productCla
                                                                              .attributes[index]
                                                                              .options[i]
                                                                              .price));
                                                                        } else {
                                                                          attPrice
                                                                              .addAll({
                                                                            productCla.attributes[index].nameEn:
                                                                                productCla.attributes[index].options[i].price
                                                                          });
                                                                        }
                                                                        optionsPrice[index] = productCla
                                                                            .attributes[index]
                                                                            .options[i]
                                                                            .price;
                                                                        optionsQuantity[index] = productCla
                                                                            .attributes[index]
                                                                            .options[i]
                                                                            .quantity;
                                                                        att[index] = productCla
                                                                            .attributes[index]
                                                                            .options[i]
                                                                            .id;
                                                                        selectedItem
                                                                            .add(att[index]);
                                                                        finalPrice = productCla.price +
                                                                            attPrice.values.reduce((sum, element) =>
                                                                                sum +
                                                                                element);

                                                                        print(
                                                                            optionsPrice);
                                                                        if (language ==
                                                                            'en') {
                                                                          des[index] = productCla
                                                                              .attributes[index]
                                                                              .options[i]
                                                                              .nameEn;
                                                                        } else {
                                                                          des[index] = productCla
                                                                              .attributes[index]
                                                                              .options[i]
                                                                              .nameAr;
                                                                        }
                                                                      },
                                                                    );
                                                                    Navigator.pop(
                                                                        context);
                                                                  }),
                                                            ],
                                                          );
                                                        }),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                translateString(
                                                    productCla.attributes[index]
                                                        .nameEn,
                                                    productCla.attributes[index]
                                                        .nameAr),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: w * 0.05,
                                                    fontFamily: 'Tajawal',
                                                    color: Colors.black),
                                              ),
                                              SizedBox(
                                                width: w * 0.01,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            w * 0.01),
                                                    color: Colors.black),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: mainColor,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (productCla.attributes.isNotEmpty)
                                  SizedBox(
                                    height: h * 0.05,
                                  ),
                                if (productCla.hasOptions)
                                  SizedBox(
                                    height: h * 0.01,
                                  ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: w * 0.025),
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: w * 0.025),
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w * 0.025),
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
                                          translate(
                                              context, 'product', 'about'),
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
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w * 0.025),
                                    child: Text(
                                      translateString(productCla.aboutEn!,
                                          productCla.aboutAr!),
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: w * 0.03),
                                    ),
                                  ),
                                if (productCla.aboutEn != null)
                                  SizedBox(
                                    height: h * 0.04,
                                  ),
                                if (productCla.about.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: w * 0.025),
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
                                          '${translate(context, 'product', 'why')} Multi',
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
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w * 0.025,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                        productCla.about.length, (index) {
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
                                                color: mainColor,
                                                fontSize: w * 0.04),
                                          ),
                                          subtitle: Text(
                                            translateString(
                                                productCla.about[index].valueEn,
                                                productCla
                                                    .about[index].valueEn),
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
                                  height: h * 0.03,
                                ),
                                (productCla.similar.isNotEmpty)
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: w * 0.025),
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
                                              translateString("Similar Product",
                                                  "المنتجات المشابه"),
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
                                      )
                                    : Container(),
                                (productCla.similar.isNotEmpty)
                                    ? SizedBox(
                                        height: h * 0.03,
                                      )
                                    : Container(),
                                (productCla.similar.isNotEmpty)
                                    ? SimilarProductScreen(
                                        similar: productCla.similar)
                                    : Container(),
                                SizedBox(
                                  height: h * 0.05,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Stack(
                        children: [
                          SizedBox(
                            height: h,
                            child: rate.isNotEmpty
                                ? SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        // SizedBox(
                                        //   height: h * 0.02,
                                        // ),
                                        // Center(
                                        //   child: InkWell(
                                        //     onTap: () => Navigator.push(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               AddRateScreen(
                                        //                 productId: productCla.id
                                        //                     .toString(),
                                        //               )),
                                        //     ),
                                        //     child: Container(
                                        //       width: double.infinity,
                                        //       height: h * 0.08,
                                        //       decoration: BoxDecoration(
                                        //           color: mainColor,
                                        //           borderRadius:
                                        //               BorderRadius.circular(
                                        //                   w * 0.05)),
                                        //       child: Center(
                                        //         child: Text(
                                        //           translate(context,
                                        //               "check_out", "rate"),
                                        //           style: TextStyle(
                                        //               color: Colors.white,
                                        //               fontSize: w * 0.05,
                                        //               fontFamily: 'Tajawal',
                                        //               fontWeight:
                                        //                   FontWeight.bold),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),

                                        SizedBox(
                                          height: h * 0.02,
                                        ),
                                        ListView.builder(
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount: rate.length,
                                          itemBuilder: (context, i) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: h * 0.05),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundImage: const AssetImage(
                                                      'assets/images/logo_multi.png'),
                                                  radius: w * 0.07,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                ),
                                                title: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: w * 0.25,
                                                      height: h * 0.02,
                                                      child: RatingBarIndicator(
                                                        rating: double.parse(
                                                            rate[i]
                                                                .rate
                                                                .toString()),
                                                        itemBuilder:
                                                            (context, index) =>
                                                                Icon(
                                                          Icons.star,
                                                          size: w * 0.045,
                                                          color: const Color(
                                                              0xffEE5A30),
                                                        ),
                                                        itemCount: 5,
                                                        itemSize: w * 0.045,
                                                        direction:
                                                            Axis.horizontal,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                subtitle: SizedBox(
                                                    width: w * 0.37,
                                                    child: Text(
                                                      rate[i].comment ?? "",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: w * 0.04),
                                                    )),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text(
                                          translate(
                                              context, 'empty', 'no_rate'),
                                          style: TextStyle(
                                              color: mainColor,
                                              fontSize: w * 0.05),
                                        ),
                                      ),
                                      SizedBox(
                                        height: h * 0.03,
                                      ),
                                      Center(
                                        child: InkWell(
                                          onTap: () {
                                            if (login) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddRateScreen(
                                                          productId: productCla
                                                              .id
                                                              .toString(),
                                                        )),
                                              );
                                            } else {
                                              final snackBar = SnackBar(
                                                content: Text(translate(context,
                                                    'snack_bar', 'login')),
                                                action: SnackBarAction(
                                                  label: translate(context,
                                                      'buttons', 'login'),
                                                  disabledTextColor:
                                                      Colors.yellow,
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
                                          child: Container(
                                            height: h * 0.08,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: h * 0.04),
                                            decoration: BoxDecoration(
                                                color: mainColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        w * 0.05)),
                                            child: Center(
                                              child: Text(
                                                translate(context, "check_out",
                                                    "rate"),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: w * 0.05,
                                                    fontFamily: 'Tajawal',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          (rate.isNotEmpty)
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: w * 0.03, vertical: h * 0.02),
                                  child: Align(
                                    alignment: (language == 'ar')
                                        ? Alignment.bottomLeft
                                        : Alignment.bottomRight,
                                    child: InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddRateScreen(
                                            productId: productCla.id.toString(),
                                          ),
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: w * 0.08,
                                        backgroundColor: mainColor,
                                        child: Center(
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: w * 0.1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
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
                                                  : (index == 2)
                                                      ? TextInputType.phone
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
                                    language == 'en' ? w * 0.05 : w * 0.05),
                          )),
                        ),
                        onTap: () {
                          if (productCla.attributes.isNotEmpty) {
                            if (selectedItem.isNotEmpty) {
                              show(context);
                            } else {
                              final snackBar = SnackBar(
                                content: Text(
                                  translateString('Select product options',
                                      'يجب تحديد الاختيارات اولا'),
                                  style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontSize: w * 0.04,
                                      fontWeight: FontWeight.w500),
                                ),
                                action: SnackBarAction(
                                  label: translateString("Undo", "تراجع"),
                                  disabledTextColor: Colors.yellow,
                                  textColor: Colors.yellow,
                                  onPressed: () {},
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          } else {
                            show(context);
                          }
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

getFinalPrice({required Map<String, num> optionsPrice}) {
  optionsPrice.values.forEach((element) {});
}

InputBorder form() {
  return OutlineInputBorder(
    borderSide: BorderSide(color: mainColor, width: 1.5),
    borderRadius: BorderRadius.circular(15),
  );
}
