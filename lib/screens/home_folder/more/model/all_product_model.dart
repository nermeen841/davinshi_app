// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:davinshi_app/models/constants.dart';

class AllProductModel {
  int? status;
  int? countItems;
  List<Data>? data;

  AllProductModel({this.status, this.countItems, this.data});

  AllProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    countItems = json['countItems'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }
}

class Data {
  int? id;
  String? nameAr;
  String? nameEn;
  String? img;
  int? isOrder;
  var regularPrice;
  var salePrice;
  String? discountPercentage;
  bool? inSale;
  String? endSale;
  String? imgSrc;

  Data(
      {this.id,
      this.nameAr,
      this.nameEn,
      required this.isOrder,
      this.img,
      this.regularPrice,
      this.salePrice,
      this.discountPercentage,
      this.inSale,
      this.endSale,
      this.imgSrc});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isOrder = json['is_order'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    img = imagePath + json['img'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    discountPercentage = json['discount_percentage'];
    inSale = json['in_sale'];
    endSale = json['end_sale'];
    imgSrc = json['img_src'];
  }
}
