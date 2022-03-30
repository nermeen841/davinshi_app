// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'constants.dart';

class ProductCla {
  int id;
  String nameAr;
  String nameEn;
  String slug;
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
  List<Attributes> attributes;
  List<ProCategory> categories;
  List<About3D> about;
  ProductCla(
      {required this.id,
      required this.nameAr,
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
  String nameAr;
  String nameEn;
  num price;
  OptionsModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.price,
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

late ProductCla productCla;

Future setProduct(Map e) async {
  try {
    bool inOffer = e['in_sale'];
    List<ProCategory> _proCat = [];
    try {
      e['categories'].forEach((c) {
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
      e['images'].forEach((img) {
        _images.add(imagePath2 + img['src']);
      });
    } catch (e) {
      print('w');
    }
    List<Statement> _statement = [];
    try {
      e['statements'].forEach((s) {
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
    try {
      e['attributes'].forEach((a) {
        List<OptionsModel> _options = [];
        a['options'].forEach((o) {
          if (o['values'].length == 0) {
          } else {
            _options.add(OptionsModel(
                id: o['values'][0]['id'],
                nameAr: o['name_ar'] ?? '',
                nameEn: o['name_en'] ?? '',
                price: num.parse(inOffer
                    ? o['values'][0]['sale_price']
                    : o['values'][0]['regular_price'])));
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
    }
    late Cat _cat;
    try {
      e['categories'].forEach((c) {
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
    try {
      e['kurly'].forEach((s) {
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
      productCla = ProductCla(
          id: e['id'],
          nameAr: e['name_ar'],
          nameEn: e['name_en'],
          slug: e['slug'],
          descriptionAr: e['description_ar'],
          descriptionEn: e['description_en'],
          percentage: e['discount_percentage'],
          image: imagePath + e['img'],
          about: _about3d,
          price: num.parse(e['regular_price'].toString()),
          offerPrice: e['sale_price'] == null
              ? null
              : num.parse(e['sale_price'].toString()),
          isOffer: inOffer,
          isRec: e['is_recommended'],
          isBest: e['is_best'],
          hasOptions: e['has_options'],
          sellerName: e['seller_name'],
          brandName: e['brand_name'],
          quantity: e['quantity'],
          aboutAr: e['about_brand_ar'] == null
              ? null
              : parseHtmlString(e['about_brand_ar']),
          rating: num.parse(e['ratings'].toString()),
          aboutEn: e['about_brand_en'] == null
              ? null
              : parseHtmlString(e['about_brand_en']),
          likes: e['likes_count'],
          images: _images,
          statements: _statement,
          attributes: _att,
          categories: _proCat,
          cat: _cat);
    } catch (e) {
      print('u');
    }
  } catch (e) {
    print('fuck');
    print(e);
  }
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
    print('e');
    print(e);
  }
  return false;
}
