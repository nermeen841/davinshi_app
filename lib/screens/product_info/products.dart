// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, unrelated_type_equality_checks, iterable_contains_unrelated_type

import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:davinshi_app/elements/newtwork_image.dart';
import 'package:davinshi_app/screens/auth/sign_upScreen.dart';
import 'package:davinshi_app/screens/product_info/product_help.dart';
import 'package:davinshi_app/screens/product_info/product_rate.dart';
import 'package:davinshi_app/screens/product_info/similar.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
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
import '../../models/product_color.dart';

class Products extends StatefulWidget {
  final bool fromFav;
  final int? brandId;
  final int? productId;

  const Products(
      {Key? key, required this.fromFav, this.brandId, this.productId})
      : super(key: key);
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DbHelper helper = DbHelper();
  String selectefCat = '';
  List<Rate> rate = [];
  List<int> att = [];
  int? selectedColor;
  int? selectedSize;
  List<String> des = [];
  List<int> selectedItem = [];
  List<num> optionsPrice = [];
  Map<String, num> attPrice = {};
  List<int> optionsQuantity = [];
  List<int> attributesID = [];
  bool check = false, error = false;
  bool finish = false;
  num finalPrice = 0.0;

  TabController? _tabBar;
  List<String> selectedColorSize = [];
  Future saveLike(bool type) async {
    final String url = domain + 'product/like';
    try {
      dio.Response response = await dio.Dio().post(
        url,
        data: {
          'brand_id': widget.fromFav ? widget.brandId : studentId,
          "product_id": productCla?.id ?? 0,
        },
        options: dio.Options(headers: {"auth-token": auth}),
      );
      if (response.statusCode == 200 && response.data['status'] == 1) {
        check = type;
        if (type) {
          favIds.add(productCla?.id ?? 0);
        } else {
          favIds.remove(productCla?.id ?? 0);
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
  bool visible = false;
  loading() async {
    visible = false;
    await getItem(widget.productId!.toInt()).then((value) {
      if (value && productCla != null) {
        for (int i = 0; i < (productCla?.attributes.length ?? 0); i++) {
          des.add('');
          att.add(0);
          attributesID.add(0);
          optionsPrice.add(0);
          optionsQuantity.add(0);
          attPrice[''] = 0;
        }
        if (!finish) {
          if (favIds.contains(productCla!.id)) {
            check = true;
            if (mounted) {
              setState(() {});
            }
          } else {
            check = false;
          }
          finish = true;
        }

        setState(() {
          visible = true;
          finalPrice =
              productCla!.isOffer ? productCla!.offerPrice! : productCla!.price;
        });
      } else if (!value && productCla == null) {
        setState(() {
          visible = false;
        });
      }
    });
  }

  @override
  void initState() {
    loading();
    super.initState();
    selectedItem = [];
    _tabBar = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  int _counter = 1;

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
                                    if (productCla!.isClothes!) {
                                      if (cart.idp.contains(productCla!.id)) {
                                        int quantity = cart.items
                                            .firstWhere((element) =>
                                                element.idp == productCla!.id)
                                            .quantity;
                                        final cartDesc = cart.items
                                            .firstWhere((element) =>
                                                element.idp == productCla!.id)
                                            .des;
                                        if (listEquals(des, cartDesc)) {
                                          print(
                                              "8888888888888888888888888888888888888");
                                          checkProductClothesQuantity(
                                              colorId: selectedColor!,
                                              sizeId: selectedSize!,
                                              productId: productCla!.id,
                                              quantity: quantity + _counter,
                                              scaffoldKey: scaffoldKey);
                                          if (itemCount > quantity + _counter) {
                                            setState2(() {
                                              _counter++;
                                            });
                                          } else if (itemCount <=
                                              quantity + _counter) {
                                            setState2(() {
                                              _counter = _counter;
                                            });
                                            Navigator.pop(context);
                                          }
                                        } else if (!listEquals(des, cartDesc)) {
                                          checkProductClothesQuantity(
                                              colorId: selectedColor!,
                                              sizeId: selectedSize!,
                                              productId: productCla!.id,
                                              quantity: _counter,
                                              scaffoldKey: scaffoldKey);
                                          if (itemCount > _counter) {
                                            setState2(() {
                                              _counter++;
                                            });
                                          } else if (itemCount <= _counter) {
                                            setState2(() {
                                              _counter = _counter;
                                            });
                                            Navigator.pop(context);
                                          }
                                        }
                                      } else {
                                        checkProductClothesQuantity(
                                            colorId: selectedColor!,
                                            sizeId: selectedSize!,
                                            productId: productCla!.id,
                                            quantity: _counter,
                                            scaffoldKey: scaffoldKey);
                                        if (itemCount > _counter) {
                                          setState2(() {
                                            _counter++;
                                          });
                                        } else if (itemCount <= _counter) {
                                          setState2(() {
                                            _counter = _counter;
                                          });
                                          Navigator.pop(context);
                                        }
                                      }
                                    } else if (productCla!
                                        .attributes.isNotEmpty) {
                                      if (cart.idp.contains(productCla!.id)) {
                                        int quantity = cart.items
                                            .firstWhere((element) =>
                                                element.idp == productCla!.id)
                                            .quantity;
                                        final cartDesc = cart.items
                                            .firstWhere((element) =>
                                                element.idp == productCla!.id)
                                            .des;
                                        if (listEquals(des, cartDesc)) {
                                          checkProductquantity(
                                            scaffoldKey: scaffoldKey,
                                            attributes: attributesID,
                                            options: optionsQuantity,
                                            productId:
                                                productCla!.id.toString(),
                                            quantity: quantity + _counter,
                                            context: context,
                                          );
                                          if (itemsAvailable! >
                                              quantity + _counter) {
                                            setState2(() {
                                              _counter++;
                                            });
                                          } else if (itemsAvailable! <=
                                              quantity + _counter) {
                                            setState2(() {
                                              _counter = _counter;
                                            });
                                            Navigator.pop(context);
                                          }
                                        } else if (!listEquals(des, cartDesc)) {
                                          checkProductquantity(
                                            scaffoldKey: scaffoldKey,
                                            attributes: attributesID,
                                            options: optionsQuantity,
                                            productId:
                                                productCla!.id.toString(),
                                            quantity: _counter,
                                            context: context,
                                          );
                                          if (itemsAvailable! > _counter) {
                                            setState2(() {
                                              _counter++;
                                            });
                                          } else if (itemsAvailable! <=
                                              _counter) {
                                            setState2(() {
                                              _counter = _counter;
                                            });
                                            Navigator.pop(context);
                                          }
                                        }
                                      } else if (!cart.idp
                                          .contains(productCla!.id)) {
                                        checkProductquantity(
                                          scaffoldKey: scaffoldKey,
                                          attributes: attributesID,
                                          options: optionsQuantity,
                                          productId: productCla!.id.toString(),
                                          quantity: _counter,
                                          context: context,
                                        );
                                        if (itemsAvailable! > _counter) {
                                          setState2(() {
                                            _counter++;
                                          });
                                        } else if (itemsAvailable! <=
                                            _counter) {
                                          setState2(() {
                                            _counter = _counter;
                                          });
                                          Navigator.pop(context);
                                        }
                                      }
                                    } else if (!productCla!.isClothes! &&
                                        productCla!.attributes.isEmpty) {
                                      if (productCla!.quantity > _counter) {
                                        setState2(() {
                                          _counter++;
                                        });
                                      } else if (productCla!.quantity <=
                                          _counter) {
                                        setState2(() {
                                          _counter = _counter;
                                        });
                                        Navigator.pop(context);
                                        final snackBar = SnackBar(
                                          content: Text(
                                            translateString(
                                                'product available quantity is only ${productCla!.quantity}',
                                                'هذا المنتج متاح منه فقط ${productCla!.quantity}'),
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
                                        ScaffoldMessenger.of(
                                                scaffoldKey.currentContext!)
                                            .showSnackBar(snackBar);
                                      }
                                    }
                                  }),
                              SizedBox(
                                  width: w * 0.15,
                                  height: h * 0.05,
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
                                    if (cart.items.isNotEmpty) {
                                      for (var element in cart.items) {
                                        if (productCla!.isOrder! == 1 &&
                                                element.isOrder == 0 ||
                                            productCla!.isOrder! == 0 &&
                                                element.isOrder == 1) {
                                          Navigator.pop(context);
                                          print("dddddddddddddddddddddddddd");
                                          return showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            w * 0.05),
                                                  ),
                                                  title: const Text(''),
                                                  content: Text(
                                                    translateString(
                                                        "It is not possible to add a product to order with a ready-made product",
                                                        "لا يمكن إضافة منتج بالطلب مع منتج جاهز "),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'Tajawal',
                                                        fontSize: w * 0.035),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text(
                                                        translateString(
                                                            "Cancel", "الغاء"),
                                                        style: const TextStyle(
                                                          fontFamily: 'Tajawal',
                                                        ),
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                    ),
                                                    InkWell(
                                                      child: Text(
                                                        translate(
                                                          context,
                                                          'buttons',
                                                          'error_cart',
                                                        ),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Tajawal',
                                                            fontSize:
                                                                w * 0.035),
                                                      ),
                                                      onTap: () async {
                                                        await dbHelper
                                                            .deleteAll();
                                                        await cart.setItems();
                                                        try {
                                                          if (!cart.idp
                                                              .contains(
                                                                  productCla!
                                                                      .id)) {
                                                            await helper.createCar(CartProducts(
                                                                isOrder: productCla!
                                                                    .isOrder!,
                                                                productquantity:
                                                                    productCla!
                                                                        .quantity
                                                                        .toInt(),
                                                                id: null,
                                                                studentId: widget.fromFav
                                                                    ? widget
                                                                        .brandId!
                                                                    : studentId,
                                                                image: productCla!
                                                                    .image,
                                                                titleAr:
                                                                    productCla!
                                                                        .nameAr,
                                                                titleEn:
                                                                    productCla!
                                                                        .nameEn,
                                                                price: finalPrice
                                                                    .toDouble(),
                                                                quantity:
                                                                    _counter,
                                                                productOptions:
                                                                    optionsQuantity,
                                                                att: att,
                                                                des: des,
                                                                idp: productCla!
                                                                    .id,
                                                                idc: productCla!
                                                                    .cat.id!,
                                                                catNameEn:
                                                                    productCla!
                                                                        .cat
                                                                        .nameEn!,
                                                                catNameAr:
                                                                    productCla!
                                                                        .cat
                                                                        .nameAr!,
                                                                catSVG:
                                                                    productCla!
                                                                        .cat
                                                                        .svg!));
                                                          } else {
                                                            int quantity = cart
                                                                .items
                                                                .firstWhere(
                                                                    (element) =>
                                                                        element
                                                                            .idp ==
                                                                        productCla!
                                                                            .id)
                                                                .quantity;
                                                            await helper.updateProduct(
                                                                counter +
                                                                    quantity,
                                                                productCla!.id,
                                                                finalPrice
                                                                    .toDouble(),
                                                                jsonEncode(att),
                                                                jsonEncode(des),
                                                                jsonEncode(
                                                                    optionsQuantity),
                                                                productCla!
                                                                    .quantity
                                                                    .toInt(),
                                                                productCla!
                                                                    .isOrder!);
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
                                                );
                                              });
                                        } else if (productCla!.isOrder == 1 &&
                                                element.isOrder == 1 ||
                                            productCla!.isOrder == 0 &&
                                                element.isOrder == 0) {
                                          if (productCla!.isClothes! == false) {
                                            if (selectedItem.isNotEmpty) {
                                              if (!cart.idp
                                                  .contains(productCla!.id)) {
                                                if (itemsAvailable! >=
                                                    _counter) {
                                                  await helper.createCar(
                                                      CartProducts(
                                                          id: null,
                                                          isOrder: productCla!
                                                              .isOrder!,
                                                          productquantity:
                                                              productCla!
                                                                  .quantity
                                                                  .toInt(),
                                                          studentId: studentId,
                                                          image:
                                                              productCla!.image,
                                                          titleAr: productCla!
                                                              .nameAr,
                                                          titleEn: productCla!
                                                              .nameEn,
                                                          price: finalPrice
                                                              .toDouble(),
                                                          quantity: _counter,
                                                          att: att,
                                                          des: des,
                                                          idp: productCla!.id,
                                                          productOptions:
                                                              optionsQuantity,
                                                          idc: productCla!
                                                              .cat.id!,
                                                          catNameEn: productCla!
                                                              .cat.nameEn!,
                                                          catNameAr: productCla!
                                                              .cat.nameAr!,
                                                          catSVG: productCla!
                                                              .cat.svg!));
                                                }
                                              } else {
                                                int quantity = cart.items
                                                    .firstWhere((element) =>
                                                        element.idp ==
                                                        productCla!.id)
                                                    .quantity;
                                                final description = cart.items
                                                    .firstWhere((element) =>
                                                        element.idp ==
                                                        productCla!.id)
                                                    .des;
                                                if (listEquals(
                                                    des, description)) {
                                                  if (itemsAvailable! >=
                                                      _counter + quantity) {
                                                    await helper.updateProduct(
                                                        _counter + quantity,
                                                        productCla!.id,
                                                        finalPrice.toDouble(),
                                                        jsonEncode(att),
                                                        jsonEncode(des),
                                                        jsonEncode(
                                                            optionsQuantity),
                                                        productCla!.quantity
                                                            .toInt(),
                                                        productCla!.isOrder!);
                                                  } else if (_counter +
                                                          quantity >
                                                      itemsAvailable!) {
                                                    final snackBar = SnackBar(
                                                      content: Text(
                                                        translateString(
                                                            'product amount not available',
                                                            'كمية المنتج غير متاحة حاليا '),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Tajawal',
                                                            fontSize: w * 0.04,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      action: SnackBarAction(
                                                        label: translateString(
                                                            "Undo", "تراجع"),
                                                        disabledTextColor:
                                                            Colors.yellow,
                                                        textColor:
                                                            Colors.yellow,
                                                        onPressed: () {},
                                                      ),
                                                    );
                                                    ScaffoldMessenger.of(
                                                            scaffoldKey
                                                                .currentContext!)
                                                        .showSnackBar(snackBar);
                                                  }
                                                } else if (!listEquals(
                                                    des, description)) {
                                                  await helper.createCar(
                                                      CartProducts(
                                                          id: null,
                                                          isOrder: productCla!
                                                              .isOrder!,
                                                          productquantity:
                                                              productCla!
                                                                  .quantity
                                                                  .toInt(),
                                                          studentId: studentId,
                                                          image:
                                                              productCla!.image,
                                                          titleAr: productCla!
                                                              .nameAr,
                                                          titleEn: productCla!
                                                              .nameEn,
                                                          price: finalPrice
                                                              .toDouble(),
                                                          quantity: _counter,
                                                          productOptions:
                                                              optionsQuantity,
                                                          att: att,
                                                          des: des,
                                                          idp: productCla!.id,
                                                          idc: productCla!
                                                              .cat.id!,
                                                          catNameEn: productCla!
                                                              .cat.nameEn!,
                                                          catNameAr: productCla!
                                                              .cat.nameAr!,
                                                          catSVG: productCla!
                                                              .cat.svg!));
                                                }
                                              }
                                              await cart
                                                  .setItems()
                                                  .then((value) {
                                                _counter = 1;
                                              });
                                            } else {
                                              if (!cart.idp
                                                  .contains(productCla!.id)) {
                                                await helper.createCar(
                                                    CartProducts(
                                                        id: null,
                                                        isOrder: productCla!
                                                            .isOrder!,
                                                        productquantity:
                                                            productCla!.quantity
                                                                .toInt(),
                                                        productOptions:
                                                            optionsQuantity,
                                                        studentId: studentId,
                                                        image:
                                                            productCla!.image,
                                                        titleAr:
                                                            productCla!.nameAr,
                                                        titleEn:
                                                            productCla!.nameEn,
                                                        price: finalPrice
                                                            .toDouble(),
                                                        quantity: _counter,
                                                        att: att,
                                                        des: des,
                                                        idp: productCla!.id,
                                                        idc:
                                                            productCla!.cat.id!,
                                                        catNameEn: productCla!
                                                            .cat.nameEn!,
                                                        catNameAr: productCla!
                                                            .cat.nameAr!,
                                                        catSVG: productCla!
                                                            .cat.svg!));
                                              } else {
                                                int quantity = cart.items
                                                    .firstWhere((element) =>
                                                        element.idp ==
                                                        productCla!.id)
                                                    .quantity;
                                                await helper.updateProduct(
                                                    _counter + quantity,
                                                    productCla!.id,
                                                    finalPrice.toDouble(),
                                                    jsonEncode(att),
                                                    jsonEncode(des),
                                                    jsonEncode(optionsQuantity),
                                                    productCla!.quantity
                                                        .toInt(),
                                                    productCla!.isOrder!);
                                              }
                                              await cart.setItems();
                                            }
                                          } else if (productCla!.isClothes!) {
                                            if (selectedColor == null ||
                                                selectedSize == null) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor: Colors.black,
                                                  content: Text(
                                                    translateString(
                                                        "you should choose color and size",
                                                        "يجب اختيار المقاس واللون"),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: w * 0.04,
                                                        fontFamily: 'Tajawal'),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              if (itemCount >= _counter) {
                                                if (!cart.idp
                                                    .contains(productCla!.id)) {
                                                  await helper.createCar(
                                                      CartProducts(
                                                          id: null,
                                                          isOrder: productCla!
                                                              .isOrder!,
                                                          productquantity:
                                                              productCla!
                                                                  .quantity
                                                                  .toInt(),
                                                          studentId: studentId,
                                                          productOptions:
                                                              optionsQuantity,
                                                          image:
                                                              productCla!.image,
                                                          titleAr: productCla!
                                                              .nameAr,
                                                          titleEn: productCla!
                                                              .nameEn,
                                                          price: finalPrice
                                                              .toDouble(),
                                                          quantity: _counter,
                                                          att: att,
                                                          des: des,
                                                          idp: productCla!.id,
                                                          idc: productCla!
                                                              .cat.id!,
                                                          catNameEn: productCla!
                                                              .cat.nameEn!,
                                                          catNameAr: productCla!
                                                              .cat.nameAr!,
                                                          catSVG: productCla!
                                                              .cat.svg!));
                                                } else {
                                                  int quantity = cart.items
                                                      .firstWhere((element) =>
                                                          element.idp ==
                                                          productCla!.id)
                                                      .quantity;
                                                  final cartDesc = cart.items
                                                      .firstWhere((element) =>
                                                          element.idp ==
                                                          productCla!.id)
                                                      .des;
                                                  if (listEquals(
                                                      des, cartDesc)) {
                                                    if (itemCount >=
                                                        _counter + quantity) {
                                                      await helper.updateProduct(
                                                          _counter + quantity,
                                                          productCla!.id,
                                                          finalPrice.toDouble(),
                                                          jsonEncode(att),
                                                          jsonEncode(des),
                                                          jsonEncode(
                                                              optionsQuantity),
                                                          productCla!.quantity
                                                              .toInt(),
                                                          productCla!.isOrder!);
                                                    } else if (_counter +
                                                            quantity >
                                                        itemCount) {
                                                      final snackBar = SnackBar(
                                                        content: Text(
                                                          translateString(
                                                              'product amount not available',
                                                              'كمية المنتج غير متاحة حاليا '),
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Tajawal',
                                                              fontSize:
                                                                  w * 0.04,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        action: SnackBarAction(
                                                          label:
                                                              translateString(
                                                                  "Undo",
                                                                  "تراجع"),
                                                          disabledTextColor:
                                                              Colors.yellow,
                                                          textColor:
                                                              Colors.yellow,
                                                          onPressed: () {},
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(
                                                              scaffoldKey
                                                                  .currentContext!)
                                                          .showSnackBar(
                                                              snackBar);
                                                    }
                                                  } else if (!listEquals(
                                                      des, cartDesc)) {
                                                    await helper.createCar(
                                                        CartProducts(
                                                            id: null,
                                                            isOrder: productCla!
                                                                .isOrder!,
                                                            productquantity:
                                                                productCla!
                                                                    .quantity
                                                                    .toInt(),
                                                            studentId:
                                                                studentId,
                                                            productOptions:
                                                                optionsQuantity,
                                                            image: productCla!
                                                                .image,
                                                            titleAr: productCla!
                                                                .nameAr,
                                                            titleEn: productCla!
                                                                .nameEn,
                                                            price: finalPrice
                                                                .toDouble(),
                                                            quantity: _counter,
                                                            att: att,
                                                            des: des,
                                                            idp: productCla!.id,
                                                            idc:
                                                                productCla!
                                                                    .cat.id!,
                                                            catNameEn:
                                                                productCla!.cat
                                                                    .nameEn!,
                                                            catNameAr:
                                                                productCla!.cat
                                                                    .nameAr!,
                                                            catSVG: productCla!
                                                                .cat.svg!));
                                                  }
                                                }
                                                await cart
                                                    .setItems()
                                                    .then((value) {
                                                  selectedColor = null;
                                                  selectedSize = null;
                                                  att.clear();
                                                  des.clear();
                                                  selectedColorSize.clear();
                                                  _counter = 1;
                                                });
                                              }
                                            }
                                          }
                                        }
                                      }
                                    } else if (cart.items.isEmpty) {
                                      if (productCla!.isClothes! == false) {
                                        if (selectedItem.isNotEmpty &&
                                            productCla!.isOrder == 0) {
                                          if (!cart.idp
                                              .contains(productCla!.id)) {
                                            if (itemsAvailable! >= _counter) {
                                              await helper.createCar(
                                                  CartProducts(
                                                      id: null,
                                                      isOrder:
                                                          productCla!.isOrder!,
                                                      productquantity:
                                                          productCla!.quantity
                                                              .toInt(),
                                                      studentId: studentId,
                                                      image: productCla!.image,
                                                      titleAr:
                                                          productCla!.nameAr,
                                                      titleEn:
                                                          productCla!.nameEn,
                                                      price:
                                                          finalPrice.toDouble(),
                                                      quantity: _counter,
                                                      att: att,
                                                      des: des,
                                                      idp: productCla!.id,
                                                      productOptions:
                                                          optionsQuantity,
                                                      idc: productCla!.cat.id!,
                                                      catNameEn: productCla!
                                                          .cat.nameEn!,
                                                      catNameAr: productCla!
                                                          .cat.nameAr!,
                                                      catSVG: productCla!
                                                          .cat.svg!));
                                            }
                                          } else {
                                            int quantity = cart.items
                                                .firstWhere((element) =>
                                                    element.idp ==
                                                    productCla!.id)
                                                .quantity;
                                            final description = cart.items
                                                .firstWhere((element) =>
                                                    element.idp ==
                                                    productCla!.id)
                                                .des;
                                            if (listEquals(des, description)) {
                                              if (itemsAvailable! >=
                                                  _counter + quantity) {
                                                await helper.updateProduct(
                                                    _counter + quantity,
                                                    productCla!.id,
                                                    finalPrice.toDouble(),
                                                    jsonEncode(att),
                                                    jsonEncode(des),
                                                    jsonEncode(optionsQuantity),
                                                    productCla!.quantity
                                                        .toInt(),
                                                    productCla!.isOrder!);
                                              } else if (_counter + quantity >
                                                  itemsAvailable!) {
                                                final snackBar = SnackBar(
                                                  content: Text(
                                                    translateString(
                                                        'product amount not available',
                                                        'كمية المنتج غير متاحة حاليا '),
                                                    style: TextStyle(
                                                        fontFamily: 'Tajawal',
                                                        fontSize: w * 0.04,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  action: SnackBarAction(
                                                    label: translateString(
                                                        "Undo", "تراجع"),
                                                    disabledTextColor:
                                                        Colors.yellow,
                                                    textColor: Colors.yellow,
                                                    onPressed: () {},
                                                  ),
                                                );
                                                ScaffoldMessenger.of(scaffoldKey
                                                        .currentContext!)
                                                    .showSnackBar(snackBar);
                                              }
                                            } else if (!listEquals(
                                                des, description)) {
                                              await helper.createCar(
                                                  CartProducts(
                                                      id: null,
                                                      isOrder:
                                                          productCla!.isOrder!,
                                                      productquantity:
                                                          productCla!.quantity
                                                              .toInt(),
                                                      studentId: studentId,
                                                      image: productCla!.image,
                                                      titleAr:
                                                          productCla!.nameAr,
                                                      titleEn:
                                                          productCla!.nameEn,
                                                      price:
                                                          finalPrice.toDouble(),
                                                      quantity: _counter,
                                                      productOptions:
                                                          optionsQuantity,
                                                      att: att,
                                                      des: des,
                                                      idp: productCla!.id,
                                                      idc: productCla!.cat.id!,
                                                      catNameEn: productCla!
                                                          .cat.nameEn!,
                                                      catNameAr: productCla!
                                                          .cat.nameAr!,
                                                      catSVG: productCla!
                                                          .cat.svg!));
                                            }
                                          }
                                          await cart.setItems().then((value) {
                                            _counter = 1;
                                          });
                                        } else {
                                          if (!cart.idp
                                              .contains(productCla!.id)) {
                                            await helper.createCar(CartProducts(
                                                id: null,
                                                isOrder: productCla!.isOrder!,
                                                productquantity: productCla!
                                                    .quantity
                                                    .toInt(),
                                                productOptions: optionsQuantity,
                                                studentId: studentId,
                                                image: productCla!.image,
                                                titleAr: productCla!.nameAr,
                                                titleEn: productCla!.nameEn,
                                                price: finalPrice.toDouble(),
                                                quantity: _counter,
                                                att: att,
                                                des: des,
                                                idp: productCla!.id,
                                                idc: productCla!.cat.id!,
                                                catNameEn:
                                                    productCla!.cat.nameEn!,
                                                catNameAr:
                                                    productCla!.cat.nameAr!,
                                                catSVG: productCla!.cat.svg!));
                                          } else {
                                            int quantity = cart.items
                                                .firstWhere((element) =>
                                                    element.idp ==
                                                    productCla!.id)
                                                .quantity;
                                            await helper.updateProduct(
                                                _counter + quantity,
                                                productCla!.id,
                                                finalPrice.toDouble(),
                                                jsonEncode(att),
                                                jsonEncode(des),
                                                jsonEncode(optionsQuantity),
                                                productCla!.quantity.toInt(),
                                                productCla!.isOrder!);
                                          }
                                          await cart.setItems();
                                        }
                                      } else if (productCla!.isClothes!) {
                                        if (selectedColor == null ||
                                            selectedSize == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.black,
                                              content: Text(
                                                translateString(
                                                    "you should choose color and size",
                                                    "يجب اختيار المقاس واللون"),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: w * 0.04,
                                                    fontFamily: 'Tajawal'),
                                              ),
                                            ),
                                          );
                                        } else {
                                          if (itemCount >= _counter) {
                                            if (!cart.idp
                                                .contains(productCla!.id)) {
                                              await helper.createCar(
                                                  CartProducts(
                                                      id: null,
                                                      isOrder:
                                                          productCla!.isOrder!,
                                                      productquantity:
                                                          productCla!.quantity
                                                              .toInt(),
                                                      studentId: studentId,
                                                      productOptions:
                                                          optionsQuantity,
                                                      image: productCla!.image,
                                                      titleAr:
                                                          productCla!.nameAr,
                                                      titleEn:
                                                          productCla!.nameEn,
                                                      price:
                                                          finalPrice.toDouble(),
                                                      quantity: _counter,
                                                      att: att,
                                                      des: des,
                                                      idp: productCla!.id,
                                                      idc: productCla!.cat.id!,
                                                      catNameEn: productCla!
                                                          .cat.nameEn!,
                                                      catNameAr: productCla!
                                                          .cat.nameAr!,
                                                      catSVG: productCla!
                                                          .cat.svg!));
                                            } else {
                                              int quantity = cart.items
                                                  .firstWhere((element) =>
                                                      element.idp ==
                                                      productCla!.id)
                                                  .quantity;
                                              final cartDesc = cart.items
                                                  .firstWhere((element) =>
                                                      element.idp ==
                                                      productCla!.id)
                                                  .des;
                                              if (listEquals(des, cartDesc)) {
                                                if (itemCount >=
                                                    _counter + quantity) {
                                                  await helper.updateProduct(
                                                      _counter + quantity,
                                                      productCla!.id,
                                                      finalPrice.toDouble(),
                                                      jsonEncode(att),
                                                      jsonEncode(des),
                                                      jsonEncode(
                                                          optionsQuantity),
                                                      productCla!.quantity
                                                          .toInt(),
                                                      productCla!.isOrder!);
                                                } else if (_counter + quantity >
                                                    itemCount) {
                                                  final snackBar = SnackBar(
                                                    content: Text(
                                                      translateString(
                                                          'product amount not available',
                                                          'كمية المنتج غير متاحة حاليا '),
                                                      style: TextStyle(
                                                          fontFamily: 'Tajawal',
                                                          fontSize: w * 0.04,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    action: SnackBarAction(
                                                      label: translateString(
                                                          "Undo", "تراجع"),
                                                      disabledTextColor:
                                                          Colors.yellow,
                                                      textColor: Colors.yellow,
                                                      onPressed: () {},
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(
                                                          scaffoldKey
                                                              .currentContext!)
                                                      .showSnackBar(snackBar);
                                                }
                                              } else if (!listEquals(
                                                  des, cartDesc)) {
                                                await helper.createCar(
                                                    CartProducts(
                                                        id: null,
                                                        isOrder: productCla!
                                                            .isOrder!,
                                                        productquantity:
                                                            productCla!.quantity
                                                                .toInt(),
                                                        studentId: studentId,
                                                        productOptions:
                                                            optionsQuantity,
                                                        image:
                                                            productCla!.image,
                                                        titleAr:
                                                            productCla!.nameAr,
                                                        titleEn:
                                                            productCla!.nameEn,
                                                        price: finalPrice
                                                            .toDouble(),
                                                        quantity: _counter,
                                                        att: att,
                                                        des: des,
                                                        idp: productCla!.id,
                                                        idc:
                                                            productCla!.cat.id!,
                                                        catNameEn: productCla!
                                                            .cat.nameEn!,
                                                        catNameAr: productCla!
                                                            .cat.nameAr!,
                                                        catSVG: productCla!
                                                            .cat.svg!));
                                              }
                                            }
                                            await cart.setItems().then((value) {
                                              selectedColor = null;
                                              selectedSize = null;
                                              att.clear();
                                              des.clear();
                                              selectedColorSize.clear();
                                              _counter = 1;
                                            });
                                          }
                                        }
                                      }
                                    }
                                  } catch (e) {
                                    print('e');
                                    print(e);
                                  }
                                  Navigator.pop(context);
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(w * 0.05),
                                          ),
                                          title: const Text(''),
                                          content: Text(
                                            translateString(
                                                "you can't order from different brands",
                                                "لا يمكنك الطلب من اكثر من متجر"),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Tajawal',
                                                fontSize: w * 0.035),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: Text(
                                                translateString(
                                                    "Cancel", "الغاء"),
                                                style: const TextStyle(
                                                  fontFamily: 'Tajawal',
                                                ),
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                            InkWell(
                                              child: Text(
                                                translate(
                                                  context,
                                                  'buttons',
                                                  'error_cart',
                                                ),
                                                style: TextStyle(
                                                    fontFamily: 'Tajawal',
                                                    fontSize: w * 0.035),
                                              ),
                                              onTap: () async {
                                                await dbHelper.deleteAll();
                                                await cart.setItems();
                                                try {
                                                  if (!cart.idp.contains(
                                                      productCla!.id)) {
                                                    await helper.createCar(
                                                        CartProducts(
                                                            isOrder: productCla!
                                                                .isOrder!,
                                                            productquantity:
                                                                productCla!.quantity
                                                                    .toInt(),
                                                            id: null,
                                                            studentId: widget
                                                                    .fromFav
                                                                ? widget
                                                                    .brandId!
                                                                : studentId,
                                                            image: productCla!
                                                                .image,
                                                            titleAr: productCla!
                                                                .nameAr,
                                                            titleEn: productCla!
                                                                .nameEn,
                                                            price: finalPrice
                                                                .toDouble(),
                                                            quantity: _counter,
                                                            productOptions:
                                                                optionsQuantity,
                                                            att: att,
                                                            des: des,
                                                            idp: productCla!.id,
                                                            idc: productCla!
                                                                .cat.id!,
                                                            catNameEn:
                                                                productCla!
                                                                    .cat.nameEn!,
                                                            catNameAr:
                                                                productCla!.cat
                                                                    .nameAr!,
                                                            catSVG: productCla!
                                                                .cat.svg!));
                                                  } else {
                                                    int quantity = cart.items
                                                        .firstWhere((element) =>
                                                            element.idp ==
                                                            productCla!.id)
                                                        .quantity;
                                                    await helper.updateProduct(
                                                        counter + quantity,
                                                        productCla!.id,
                                                        finalPrice.toDouble(),
                                                        jsonEncode(att),
                                                        jsonEncode(des),
                                                        jsonEncode(
                                                            optionsQuantity),
                                                        productCla!.quantity
                                                            .toInt(),
                                                        productCla!.isOrder!);
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
                                        );
                                      });
                                }
                              } else {
                                if (cartId == null ||
                                    cartId == widget.brandId) {
                                  try {
                                    if (!cart.idp.contains(productCla!.id)) {
                                      await helper.createCar(CartProducts(
                                          id: null,
                                          isOrder: productCla!.isOrder!,
                                          productquantity:
                                              productCla!.quantity.toInt(),
                                          productOptions: optionsQuantity,
                                          studentId: widget.brandId!,
                                          image: productCla!.image,
                                          titleAr: productCla!.nameAr,
                                          titleEn: productCla!.nameEn,
                                          price: finalPrice.toDouble(),
                                          quantity: _counter,
                                          att: att,
                                          des: des,
                                          idp: productCla!.id,
                                          idc: productCla!.cat.id!,
                                          catNameEn: productCla!.cat.nameEn!,
                                          catNameAr: productCla!.cat.nameAr!,
                                          catSVG: productCla!.cat.svg!));
                                    } else {
                                      int quantity = cart.items
                                          .firstWhere((element) =>
                                              element.idp == productCla!.id)
                                          .quantity;
                                      await helper.updateProduct(
                                          _counter + quantity,
                                          productCla!.id,
                                          finalPrice.toDouble(),
                                          jsonEncode(att),
                                          jsonEncode(des),
                                          jsonEncode(optionsQuantity),
                                          productCla!.quantity.toInt(),
                                          productCla!.isOrder!);
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
                          SizedBox(
                            height: h * 0.02,
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

    return Directionality(
      textDirection: getDirection(),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
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
          body: (visible)
              ? Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        controller: _tabBar,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: w,
                                height: h,
                                // margin: EdgeInsets.only(top: h * 0.3),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(w * 0.03),
                                    topRight: Radius.circular(w * 0.03),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: w,
                                        height: h * 0.5,
                                        child: Stack(
                                          children: [
                                            (productCla!.images.isEmpty)
                                                ? InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Img(
                                                                        productCla!
                                                                            .image,
                                                                        images: const [],
                                                                      )));
                                                    },
                                                    child: ImageeNetworkWidget(
                                                        width: w,
                                                        height: h * 0.5,
                                                        image:
                                                            productCla!.image,
                                                        fit: BoxFit.contain))
                                                : SizedBox(
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Img(
                                                                          productCla!
                                                                              .image,
                                                                          images:
                                                                              productCla!.images,
                                                                        )));
                                                      },
                                                      child: Swiper(
                                                        autoplayDelay: 5000,
                                                        pagination: SwiperPagination(
                                                            builder: DotSwiperPaginationBuilder(
                                                                color: mainColor
                                                                    .withOpacity(
                                                                        0.3),
                                                                activeColor:
                                                                    mainColor),
                                                            alignment: Alignment
                                                                .bottomCenter),
                                                        itemCount: productCla!
                                                            .images.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return ImageeNetworkWidget(
                                                              width: w,
                                                              image: productCla!
                                                                      .images[
                                                                  index],
                                                              fit: BoxFit
                                                                  .contain);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: h * 0.02),
                                                  child: Icon(
                                                    Icons.zoom_out_map_outlined,
                                                    color: mainColor,
                                                  ),
                                                ),
                                                (productCla!.isOffer)
                                                    ? Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    w * 0.01,
                                                                vertical:
                                                                    h * 0.01),
                                                        child: CircleAvatar(
                                                          radius: w * 0.07,
                                                          backgroundColor:
                                                              mainColor,
                                                          child: Center(
                                                            child: Text(
                                                              productCla!
                                                                      .percentage
                                                                      .toString() +
                                                                  "%",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'Tajawal',
                                                                  fontSize:
                                                                      w * 0.04,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
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
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: w * 0.015,
                                            vertical: h * 0.02),
                                        child: SizedBox(
                                          width: w,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: w * 0.53,
                                                child: Text(
                                                  translateString(
                                                      productCla!.nameEn,
                                                      productCla!.nameAr),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.fade,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                  if (productCla!.isOffer)
                                                    Text(
                                                        getProductprice(
                                                            currency: currency,
                                                            productPrice:
                                                                productCla!
                                                                    .offerPrice!),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Tajawal',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: mainColor,
                                                            fontSize:
                                                                w * 0.04)),
                                                  if (!productCla!.isOffer)
                                                    Text(
                                                        getProductprice(
                                                            currency: currency,
                                                            productPrice:
                                                                productCla!
                                                                    .price),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Tajawal',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: mainColor,
                                                            fontSize:
                                                                w * 0.04)),
                                                  if (productCla!.isOffer)
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  w * 0.03),
                                                      child: Text(
                                                        getProductprice(
                                                            currency: currency,
                                                            productPrice:
                                                                productCla!
                                                                    .price),
                                                        style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: w * 0.04,
                                                          color: Colors.grey,
                                                          fontFamily: 'Tajawal',
                                                          decorationThickness:
                                                              w * 0.1,
                                                          decorationColor:
                                                              mainColor,
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
                                                  text: translate(context,
                                                      'home', 'seller_name'),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                      fontSize: w * 0.035)),
                                              TextSpan(
                                                  text: (productCla!
                                                              .sellerName !=
                                                          null)
                                                      ? productCla!.sellerName
                                                          .toString()
                                                      : (productCla!
                                                                  .brandName !=
                                                              null)
                                                          ? productCla!
                                                              .brandName
                                                              .toString()
                                                          : translateString(
                                                              'Multi', 'مالتي'),
                                                  style:
                                                      TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                          fontSize: w * 0.035)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      (productCla!.isOrder == 1)
                                          ? SizedBox(
                                              height: h * 0.01,
                                            )
                                          : const SizedBox(),
                                      (productCla!.isOrder == 1)
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: h * 0.015),
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: translateString(
                                                            'Order will be deliver within ${productCla!.deliverDays} days ',
                                                            'الطلب سيصل خلال  ${productCla!.deliverDays}  يوم '),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                'Tajawal',
                                                            color:
                                                                Colors.black87,
                                                            fontSize:
                                                                w * 0.035)),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      SizedBox(
                                        height: h * 0.04,
                                      ),
                                      (productCla!.quantity == 0)
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: h * 0.015),
                                              child: Text(
                                                  translateString(
                                                      "Product not available",
                                                      "المنتج غير متوفر حاليا"),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red,
                                                      fontSize: w * 0.04)),
                                            )
                                          : Container(),
                                      (productCla!.quantity == 0)
                                          ? SizedBox(
                                              height: h * 0.04,
                                            )
                                          : Container(),
                                      (productCla!.isClothes! == true &&
                                              productCla!.quantity != 0)
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: w * 0.025),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      homeBottomSheet(
                                                        context: context,
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      w * 0.04,
                                                                  vertical:
                                                                      h * 0.04),
                                                          child: SingleChildScrollView(
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  translateString(
                                                                      "Size",
                                                                      "المقاس"),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize: w *
                                                                          0.05,
                                                                      fontFamily:
                                                                          'Tajawal',
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                ListView
                                                                    .builder(
                                                                      primary: false,
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount: productCla!
                                                                            .attributesClothes!
                                                                            .length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                i) {
                                                                          return Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.only(top: h * 0.02),
                                                                                child: Text(
                                                                                  translateString(productCla!.attributesClothes![i].nameEn!, productCla!.attributesClothes![i].nameAr!),
                                                                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: w * 0.05, color: Colors.black),
                                                                                ),
                                                                              ),
                                                                              Radio(
                                                                                  activeColor: mainColor,
                                                                                  value: productCla!.attributesClothes![i].sizeId!,
                                                                                  groupValue: selectedSize,
                                                                                  onChanged: (int? value) async {
                                                                                    att.clear();
                                                                                    des.clear();
                                                                                    selectedColorSize.clear();
                                                                                    setState(
                                                                                      () {
                                                                                        att.add(productCla!.attributesClothes![i].sizeId!);
                                                                                        _counter = 1;
                                                                                        selectedSize = productCla!.attributesClothes![i].sizeId!;
                                                                                        if (language == 'en') {
                                                                                          des.add(productCla!.attributesClothes![i].nameEn!);
                                                                                          selectedColorSize.add(productCla!.attributesClothes![i].nameEn!);
                                                                                        } else {
                                                                                          des.add(productCla!.attributesClothes![i].nameAr!);
                                                                                          selectedColorSize.add(productCla!.attributesClothes![i].nameAr!);
                                                                                        }
                                                                                      },
                                                                                    );
                                                                                    Navigator.pop(context);
                                                                                  }),
                                                                            ],
                                                                          );
                                                                        }),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          translateString(
                                                              "Size", "المقاس"),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  w * 0.04,
                                                              fontFamily:
                                                                  'Tajawal'),
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(w *
                                                                          0.01),
                                                              color:
                                                                  Colors.black),
                                                          child: Center(
                                                            child: Icon(
                                                              Icons
                                                                  .keyboard_arrow_down,
                                                              color: mainColor,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),

                                                  InkWell(
                                                    onTap: () {
                                                      if (selectedSize !=
                                                          null) {
                                                        homeBottomSheet(
                                                          context: context,
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        w *
                                                                            0.04,
                                                                    vertical: h *
                                                                        0.04),
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  translateString(
                                                                      "Color",
                                                                      "اللون"),
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize: w *
                                                                          0.05,
                                                                      fontFamily:
                                                                          'Tajawal',
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                FutureBuilder(
                                                                    future:
                                                                        getProductcolor(
                                                                      productId:
                                                                          productCla!
                                                                              .id
                                                                              .toString(),
                                                                      sizeId: selectedSize
                                                                          .toString(),
                                                                    ),
                                                                    builder: (context,
                                                                        AsyncSnapshot
                                                                            snapshot) {
                                                                      if (snapshot
                                                                          .hasData) {
                                                                        return (snapshot.data.data.isNotEmpty)
                                                                            ? ListView.builder(
                                                                                // primary: true,
                                                                                shrinkWrap: true,
                                                                                physics: const NeverScrollableScrollPhysics(),
                                                                                itemCount: snapshot.data.data.length,
                                                                                itemBuilder: (context, i) {
                                                                                  return Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: EdgeInsets.only(top: h * 0.02),
                                                                                        child: Text(
                                                                                          translateString(snapshot.data.data[i].nameEn!, snapshot.data.data[i].nameAr!),
                                                                                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: w * 0.05, color: Colors.black),
                                                                                        ),
                                                                                      ),
                                                                                      Radio<int>(
                                                                                          activeColor: mainColor,
                                                                                          value: snapshot.data.data[i].id,
                                                                                          groupValue: selectedColor,
                                                                                          onChanged: (int? value) {
                                                                                            // prefs.remove("color_id");
                                                                                            setState(
                                                                                              () {
                                                                                                att.add(snapshot.data.data[i].id);
                                                                                                _counter = 1;
                                                                                                selectedColor = snapshot.data.data[i].id;

                                                                                                // prefs.setInt("color_id", snapshot.data.data[i].id);
                                                                                                if (language == 'en') {
                                                                                                  des.add(snapshot.data.data[i].nameEn!);
                                                                                                  selectedColorSize.add(snapshot.data.data[i].nameEn!);
                                                                                                } else {
                                                                                                  des.add(snapshot.data.data[i].nameAr!);
                                                                                                  selectedColorSize.add(snapshot.data.data[i].nameEn!);
                                                                                                }
                                                                                              },
                                                                                            );
                                                                                            checkProductClothesQuantity(colorId: snapshot.data.data[i].id, productId: productCla!.id, quantity: _counter, scaffoldKey: scaffoldKey, sizeId: selectedSize!);
                                                                                            Navigator.pop(context);
                                                                                          }),
                                                                                    ],
                                                                                  );
                                                                                })
                                                                            : Padding(
                                                                                padding: EdgeInsets.only(top: h * 0.15),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    translateString("No colors yet for this size \n product not available for this size", "  لقد نفذت كمية المنتج المتاحه لهذا المقاس  \n لا توجد الوان متاحه حاليا لهذا المقاس"),
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(color: mainColor, fontSize: w * 0.04, fontWeight: FontWeight.bold, fontFamily: 'Tajawal', height: 2),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                      } else {
                                                                        return Center(
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            color:
                                                                                mainColor,
                                                                          ),
                                                                        );
                                                                      }
                                                                    }),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            backgroundColor:
                                                                Colors.black,
                                                            content: Text(
                                                              translateString(
                                                                  "select size first",
                                                                  "يجب اختيار المقاس اولا"),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      w * 0.04,
                                                                  fontFamily:
                                                                      'Tajawal'),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          translateString(
                                                              "Color", "اللون"),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  w * 0.04,
                                                              fontFamily:
                                                                  'Tajawal'),
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(w *
                                                                          0.01),
                                                              color:
                                                                  Colors.black),
                                                          child: Center(
                                                            child: Icon(
                                                              Icons
                                                                  .keyboard_arrow_down,
                                                              color: mainColor,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                  // : Container(),
                                                ],
                                              ),
                                            )
                                          : (productCla!.attributes.isNotEmpty)
                                              ? Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: w * 0.025),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: List.generate(
                                                      productCla!
                                                          .attributes.length,
                                                      (index) => InkWell(
                                                        onTap: () {
                                                          homeBottomSheet(
                                                            context: context,
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          w *
                                                                              0.04,
                                                                      vertical: h *
                                                                          0.04),
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    translateString(
                                                                        productCla!
                                                                            .attributes[
                                                                                index]!
                                                                            .nameEn,
                                                                        productCla!
                                                                            .attributes[index]!
                                                                            .nameAr),
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize: w *
                                                                            0.05,
                                                                        fontFamily:
                                                                            'Tajawal',
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                  ListView.builder(
                                                                      // primary: true,
                                                                      shrinkWrap: true,
                                                                      physics: const NeverScrollableScrollPhysics(),
                                                                      itemCount: productCla!.attributes[index]!.options.length,
                                                                      itemBuilder: (context, i) {
                                                                        return Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.only(top: h * 0.02),
                                                                              child: Text(
                                                                                translateString(productCla!.attributes[index]!.options[i].nameEn, productCla!.attributes[index]!.options[i].nameAr),
                                                                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: w * 0.05, color: Colors.black),
                                                                              ),
                                                                            ),
                                                                            Radio(
                                                                                activeColor: mainColor,
                                                                                value: productCla!.attributes[index]!.options[i].id,
                                                                                groupValue: att[index],
                                                                                onChanged: (int? value) {
                                                                                  setState(
                                                                                    () {
                                                                                      print(attPrice);
                                                                                      if (productCla!.attributes[index]!.nameEn == attPrice[productCla!.attributes[index]!.nameEn]) {
                                                                                        attPrice.updateAll(((key, value) => productCla!.attributes[index]!.options[i].price));
                                                                                      } else {
                                                                                        attPrice.addAll({
                                                                                          productCla!.attributes[index]!.nameEn: productCla!.attributes[index]!.options[i].price
                                                                                        });
                                                                                      }
                                                                                      optionsPrice[index] = productCla!.attributes[index]!.options[i].price;
                                                                                      optionsQuantity[index] = productCla!.attributes[index]!.options[i].id;
                                                                                      attributesID[index] = productCla!.attributes[index]!.id;
                                                                                      att[index] = productCla!.attributes[index]!.options[i].id;
                                                                                      selectedItem.add(att[index]);
                                                                                      finalPrice += attPrice.values.reduce((sum, element) => sum + element);
                                                                                      checkProductquantity(productId: productCla!.id.toString(), quantity: _counter, attributes: attributesID, options: att, context: context, scaffoldKey: scaffoldKey);
                                                                                      print(optionsPrice);
                                                                                      if (language == 'en') {
                                                                                        des[index] = productCla!.attributes[index]!.options[i].nameEn;
                                                                                      } else {
                                                                                        des[index] = productCla!.attributes[index]!.options[i].nameAr;
                                                                                      }
                                                                                    },
                                                                                  );
                                                                                  Navigator.pop(context);
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
                                                                  productCla!
                                                                      .attributes[
                                                                          index]!
                                                                      .nameEn,
                                                                  productCla!
                                                                      .attributes[
                                                                          index]!
                                                                      .nameAr),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      w * 0.05,
                                                                  fontFamily:
                                                                      'Tajawal',
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            SizedBox(
                                                              width: w * 0.01,
                                                            ),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(w *
                                                                              0.01),
                                                                  color: Colors
                                                                      .black),
                                                              child: Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .keyboard_arrow_down,
                                                                  color:
                                                                      mainColor,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                      if (productCla!.attributes.isNotEmpty ||
                                          productCla!.isClothes! == true)
                                        SizedBox(
                                          height: h * 0.05,
                                        ),
                                      if (productCla!.hasOptions)
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
                                              translate(
                                                  context, 'product', 'des'),
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
                                                ),
                                              ),
                                            ),
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
                                          parseHtmlString(translateString(
                                              productCla!.descriptionEn,
                                              productCla!.descriptionAr)),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: w * 0.03),
                                        ),
                                      ),
                                      SizedBox(
                                        height: h * 0.02,
                                      ),
                                      (productCla!.isOrder! == 1)
                                          ? SizedBox(
                                              height: h * 0.01,
                                            )
                                          : const SizedBox(),
                                      (productCla!.isOrder! == 1)
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
                                                            thickness:
                                                                h * 0.001,
                                                          ))),
                                                  SizedBox(
                                                    width: w * 0.02,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/Group 1090.png",
                                                        color: mainColor,
                                                      ),
                                                      SizedBox(
                                                        width: w * 0.015,
                                                      ),
                                                      Text(
                                                        translateString(
                                                            'Shipping and delivery',
                                                            'الشحن والتوصيل'),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: w * 0.045,
                                                            color: mainColor),
                                                      ),
                                                    ],
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
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox(),
                                      (productCla!.isOrder! == 1)
                                          ? SizedBox(
                                              height: h * 0.04,
                                            )
                                          : const SizedBox(),
                                      (productCla!.isOrder! == 1)
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: w * 0.025),
                                              child: Text(
                                                translateString(
                                                    "This product is on demand \n Delivery time ${productCla!.deliverDays!} working days",
                                                    "هذا المنتج تحت الطلب \n مدة التوصيل ${productCla!.deliverDays!} يوم عمل"),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: w * 0.03),
                                              ),
                                            )
                                          : const SizedBox(),
                                      (productCla!.isOrder! == 1)
                                          ? SizedBox(
                                              height: h * 0.02,
                                            )
                                          : const SizedBox(),
                                      if (productCla!.aboutEn != null)
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
                                                translate(context, 'product',
                                                    'about'),
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
                                      if (productCla!.aboutEn != null)
                                        SizedBox(
                                          height: h * 0.04,
                                        ),
                                      if (productCla!.aboutEn != null)
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: w * 0.025),
                                          child: Text(
                                            translateString(
                                                productCla!.aboutEn!,
                                                productCla!.aboutAr!),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: w * 0.03),
                                          ),
                                        ),
                                      if (productCla!.aboutEn != null)
                                        SizedBox(
                                          height: h * 0.04,
                                        ),
                                      if (productCla!.about.isNotEmpty)
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
                                      if (productCla!.about.isNotEmpty)
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
                                              productCla!.about.length,
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
                                                      productCla!
                                                          .about[index].nameEn,
                                                      productCla!
                                                          .about[index].nameAr),
                                                  style: TextStyle(
                                                      color: mainColor,
                                                      fontSize: w * 0.04),
                                                ),
                                                subtitle: Text(
                                                  translateString(
                                                      productCla!
                                                          .about[index].valueEn,
                                                      productCla!.about[index]
                                                          .valueEn),
                                                  style: TextStyle(
                                                      color: Colors.black,
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
                                      (productCla!.similar.isNotEmpty)
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
                                                            thickness:
                                                                h * 0.001,
                                                          ))),
                                                  SizedBox(
                                                    width: w * 0.02,
                                                  ),
                                                  Text(
                                                    translateString(
                                                        "Similar Product",
                                                        "المنتجات المشابه"),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                            thickness:
                                                                h * 0.001,
                                                          ))),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      (productCla!.similar.isNotEmpty)
                                          ? SizedBox(
                                              height: h * 0.03,
                                            )
                                          : Container(),
                                      (productCla!.similar.isNotEmpty)
                                          ? SimilarProductScreen(
                                              similar: productCla!.similar)
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
                          const ProductRates(),
                          const ProductHelp(),
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
                                      getProductprice(
                                          currency: currency,
                                          productPrice: finalPrice),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: language == 'en'
                                          ? w * 0.05
                                          : w * 0.05),
                                )),
                              ),
                              onTap: () {
                                if (productCla!.quantity != 0) {
                                  if (productCla!.attributes.isNotEmpty) {
                                    if (selectedItem.isNotEmpty) {
                                      show(context);
                                    } else {
                                      final snackBar = SnackBar(
                                        content: Text(
                                          translateString(
                                              'Select product options',
                                              'يجب تحديد الاختيارات اولا'),
                                          style: TextStyle(
                                              fontFamily: 'Tajawal',
                                              fontSize: w * 0.04,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        action: SnackBarAction(
                                          label:
                                              translateString("Undo", "تراجع"),
                                          disabledTextColor: Colors.yellow,
                                          textColor: Colors.yellow,
                                          onPressed: () {},
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  } else if (productCla!.isClothes!) {
                                    if (selectedColor == null ||
                                        selectedSize == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.black,
                                          content: Text(
                                            translateString(
                                                "you should choose color and size",
                                                "يجب اختيار المقاس واللون"),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: w * 0.04,
                                                fontFamily: 'Tajawal'),
                                          ),
                                        ),
                                      );
                                    } else {
                                      show(context);
                                    }
                                  } else {
                                    show(context);
                                  }
                                } else if (productCla!.quantity == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        translateString("Product not available",
                                            "المنتج غير متوفر حاليا "),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w * 0.04,
                                            fontFamily: 'Tajawal'),
                                      ),
                                    ),
                                  );
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
                                        border: Border.all(
                                            color: Colors.grey[400]!),
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
                                        border: Border.all(
                                            color: Colors.grey[400]!),
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
                )
              : Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: mainColor,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Future getProductcolor(
      {required String productId, required String sizeId}) async {
    final String url = domain + "get-colors";
    ColorModel? colorModel;
    print(productId);
    print(sizeId);

    try {
      Response response = await Dio()
          .post(url, data: {"product_id": productId, "size_id": sizeId});
      if (response.data['status'] == 1) {
        colorModel = ColorModel.fromJson(response.data);
      } else if (response.data['status'] == 0) {
        colorModel = ColorModel.fromJson(response.data);
      }
      print(response.data);
      return colorModel;
    } catch (error) {
      print("color product error : " + error.toString());
    }
    return colorModel;
  }
}

// InputBorder form() {
//   return OutlineInputBorder(
//     borderSide: BorderSide(color: mainColor, width: 1.5),
//     borderRadius: BorderRadius.circular(15),
//   );
// }
