// ignore_for_file: non_constant_identifier_names, avoid_print, empty_catches

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import '../lang/change_language.dart';
import 'constants.dart';

class ProductCla {
  int id;
  String nameAr;
  String nameEn;
  String slug;
  bool? isClothes;
  List<AttributesClothes>? attributesClothes;
  String? sellerName;
  String? brandName;
  String descriptionAr;
  String descriptionEn;
  String? aboutAr;
  String? aboutEn;
  String? percentage;
  String image;
  num price;
  num? offerPrice;
  bool isOffer;
  bool isRec;
  bool isBest;
  bool hasOptions;
  int quantity;
  num rating;
  int likes;
  Cat cat;
  List<String> images;
  List<Statement> statements;
  List<Attributes?> attributes;
  List<ProCategory> categories;
  List<About3D> about;
  List<SimilarProduct> similar;
  ProductCla(
      {required this.id,
      this.isClothes,
      this.attributesClothes,
      required this.nameAr,
      required this.similar,
      required this.nameEn,
      required this.sellerName,
      required this.brandName,
      required this.slug,
      required this.descriptionAr,
      required this.descriptionEn,
      required this.percentage,
      required this.image,
      required this.price,
      required this.offerPrice,
      required this.isOffer,
      required this.isRec,
      required this.isBest,
      required this.hasOptions,
      required this.quantity,
      required this.rating,
      required this.likes,
      required this.images,
      required this.cat,
      required this.statements,
      required this.attributes,
      required this.categories,
      required this.aboutAr,
      required this.aboutEn,
      required this.about});
}

class AttributesClothes {
  int? id;
  int? sizeId;
  String? nameEn;
  String? nameAr;

  AttributesClothes({this.id, this.sizeId, this.nameAr, this.nameEn});
}

class SimilarProduct {
  int? id;
  String? nameEn;
  String? nameAr;
  String? image;
  num? regularPrice;
  num? salePrice;
  String? discountPercentage;
  bool? inSale;
  String? imageSrc;
  SimilarProduct(
      {required this.discountPercentage,
      required this.id,
      required this.image,
      required this.imageSrc,
      required this.inSale,
      required this.nameAr,
      required this.nameEn,
      required this.regularPrice,
      required this.salePrice});
}

class ProductsModel {
  String? name, id, img;

  bool? in_sale;

  String? sale_price, regular_price, disPer;
  ProductsModel(
      {this.id,
      this.name,
      this.img,
      this.in_sale,
      this.sale_price,
      this.regular_price,
      this.disPer});
}

class Cat {
  int id;
  String nameAr;
  String nameEn;
  String svg;

  Cat(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.svg});
}

class Statement {
  int id;
  String nameAr;
  String nameEn;
  String valueAr;
  String valueEn;
  Statement(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.valueAr,
      required this.valueEn});
}

class About3D {
  int id;
  String nameAr;
  String nameEn;
  String valueAr;
  String valueEn;
  About3D(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.valueAr,
      required this.valueEn});
}

class Attributes {
  int id;
  String nameAr;
  String nameEn;
  List<OptionsModel> options;
  Attributes(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.options});
}

class OptionsModel {
  int id;
  int valueId;
  int quantity;
  String nameAr;
  String nameEn;
  num price;
  OptionsModel({
    required this.id,
    required this.valueId,
    required this.nameAr,
    required this.nameEn,
    required this.price,
    required this.quantity,
  });
}

class Offer {
  int id;
  String image;
  Offer(this.id, this.image);
}

class Categories {
  int id;
  IconData icon;
  String title;
  Categories(this.id, this.icon, this.title);
}

class ProCategory {
  String nameAr;
  String nameEn;
  int catId;
  ProCategory(
      {required this.nameAr, required this.nameEn, required this.catId});
}

ProductCla? productCla;

Future setProduct(Map e) async {
  try {
    bool inOffer = e['product']['in_sale'];
    bool isClothes = e['product']['is_clothes'];
    List<ProCategory> _proCat = [];
    try {
      e['product']['categories'].forEach((c) {
        _proCat.add(ProCategory(
            nameAr: c['name_ar'] ?? '',
            nameEn: c['name_en'] ?? '',
            catId: c['pivot']['category_id']));
      });
    } catch (e) {
      print('q');
    }
    List<String> _images = [];
    try {
      e['product']['images'].forEach((img) {
        _images.add(imagePath2 + img['src']);
      });
    } catch (e) {
      print('w');
    }
    List<Statement> _statement = [];
    try {
      e['product']['statements'].forEach((s) {
        _statement.add(Statement(
            id: s['id'],
            nameAr: s['name_ar'] ?? '',
            nameEn: s['name_en'] ?? '',
            valueAr: s['value_ar'] ?? '',
            valueEn: s['value_ar'] ?? ''));
      });
    } catch (e) {
      print('e');
    }
    List<Attributes> _att = [];
    List<AttributesClothes> _attClothes = [];

    if (isClothes) {
      try {
        e['product']['attributes_clothes'].forEach((attri) {
          _attClothes.add(
            AttributesClothes(
              id: attri['id'],
              sizeId: attri['size']['id'],
              nameAr: attri['size']['name_ar'],
              nameEn: attri['size']['name_en'],
            ),
          );
        });
      } catch (e) {
        print("......................................" + e.toString());
      }
    } else {
      try {
        e['product']['attributes'].forEach((a) {
          List<OptionsModel> _options = [];
          a['options'].forEach((o) {
            if (o['values'].length == 0) {
            } else {
              _options.add(OptionsModel(
                  valueId: o['values'][0]['id'],
                  id: o['id'],
                  nameAr: o['name_ar'] ?? '',
                  nameEn: o['name_en'] ?? '',
                  price: num.parse(inOffer
                      ? o['values'][0]['sale_price'] ?? "0"
                      : o['values'][0]['regular_price'] ?? "0"),
                  quantity: o['values'][0]['quantity']));
            }
          });

          _att.add(Attributes(
              id: a['id'],
              nameAr: a['name_ar'] ?? '',
              nameEn: a['name_en'] ?? '',
              options: _options));
        });
      } catch (e) {
        print('r');
        print("......................................" + e.toString());
      }
    }

    late Cat _cat;
    try {
      e['product']['categories'].forEach((c) {
        if (c['parent_id'] != 0) {
          _cat = Cat(
              id: c['id'],
              nameAr: c['name_ar'] ?? '',
              nameEn: c['name_en'] ?? '',
              svg: c['src'] + '/' + c['img']);
        }
      });
    } catch (e) {
      print('t');
    }
    List<About3D> _about3d = [];
    List<SimilarProduct> _similarProduct = [];
    try {
      e['product']['kurly'].forEach((s) {
        _about3d.add(About3D(
            id: s['id'],
            nameAr: s['name_ar'] ?? '',
            nameEn: s['name_en'] ?? '',
            valueAr: s['value_ar'] ?? '',
            valueEn: s['value_ar'] ?? ''));
      });
    } catch (e) {
      print('y');
    }
    try {
      e['r_products'].forEach((r) {
        _similarProduct.add(
          SimilarProduct(
            discountPercentage: r['discount_percentage'],
            id: r['id'],
            image: r['img'],
            imageSrc: r['img_src'],
            inSale: r['in_sale'],
            nameAr: r['name_ar'],
            nameEn: r['name_en'],
            regularPrice: r['regular_price'],
            salePrice: r['sale_price'],
          ),
        );
      });
    } catch (e) {
      print(e);
    }
    try {
      productCla = ProductCla(
          id: e['product']['id'],
          nameAr: e['product']['name_ar'],
          nameEn: e['product']['name_en'],
          slug: e['product']['slug'],
          descriptionAr: e['product']['description_ar'],
          descriptionEn: e['product']['description_en'],
          percentage: e['product']['discount_percentage'],
          image: imagePath + e['product']['img'],
          about: _about3d,
          price: num.parse(e['product']['regular_price'].toString()),
          offerPrice: e['product']['sale_price'] == null
              ? null
              : num.parse(e['product']['sale_price'].toString()),
          isOffer: inOffer,
          isRec: e['product']['is_recommended'],
          isBest: e['product']['is_best'],
          hasOptions: e['product']['has_options'],
          sellerName: e['product']['seller_name'],
          brandName: e['product']['brand_name'],
          quantity: e['product']['quantity'],
          aboutAr: e['product']['about_brand_ar'] == null
              ? null
              : parseHtmlString(e['product']['about_brand_ar']),
          rating: num.parse(e['product']['ratings'].toString()),
          aboutEn: e['product']['about_brand_en'] == null
              ? null
              : parseHtmlString(e['product']['about_brand_en']),
          likes: e['product']['likes_count'],
          isClothes: e['product']['is_clothes'],
          attributesClothes: _attClothes,
          images: _images,
          statements: _statement,
          attributes: _att,
          categories: _proCat,
          similar: _similarProduct,
          cat: _cat);
    } catch (e) {}
  } catch (e) {}
}

String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;
  return parsedString;
}

Future<bool> getItem(int id) async {
  final String url = domain + 'get-product/${id.toString()}';
  print("product id :" + id.toString());
  try {
    Response response = await Dio().get(url);
    if (response.data['status'] == 1) {
      await setProduct(response.data['data']);
      return true;
    }
  } catch (e) {
    print(e);
  }
  return false;
}

///////////////////////////////////////////////////////////////////////////////////

getProductprice({required String currency, required num productPrice}) {
  String ratio = prefs.getString("ratio").toString();
  num ratioPrice = num.parse(ratio);
  String price = "";

  if (currency != 'KWD' || currency != 'د.ك') {
    num finalPrice = productPrice / ratioPrice;
    price = finalPrice.toString() + " " + currency;
    return price;
  } else {
    num finalPrice = productPrice;
    price = finalPrice.toString() + " " + currency;
    return finalPrice.toString();
  }
}

/////////////////////////////////////////////////////////////////
bool isavailabe = false;
int itemCount = 0;

Future checkProductClothesQuantity(
    {required int productId,
    required int quantity,
    required int sizeId,
    required int colorId,
    required scaffoldKey}) async {
  final String url = domain + "check-product";

  var attributes = {
    "6": sizeId,
    "7": colorId,
  };

  try {
    Map<String, dynamic> data = {
      "product_id": productId,
      "quantity": quantity,
      "attributes": attributes,
    };
    Response response = await Dio().post(url, data: data);
    print(data);
    if (response.data['status'] == 1) {
      isavailabe = true;
      itemCount = response.data['data'];
      if (response.data['data'] == quantity) {
        final snackBar = SnackBar(
          content: Text(
            translateString(
                'product available quantity is only ${response.data['data']}',
                'هذا المنتج متاح منه فقط ${response.data['data']}'),
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
        ScaffoldMessenger.of(scaffoldKey.currentContext!)
            .showSnackBar(snackBar);
      }
      print(response.data);
    } else if (response.data['status'] == 0) {
      isavailabe = false;
      itemCount = response.data['data'];
      final snackBar = SnackBar(
        content: Text(
          translateString(
              'product amount not available', 'كمية المنتج غير متاحة حاليا '),
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
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(snackBar);
    }
  } catch (e) {
    print("product clothes quantity errro : " + e.toString());
  }
}
