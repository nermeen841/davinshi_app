// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:davinshi_app/models/constants.dart';

class SaveOrderModel {
  int? statuse;
  Order? order;
  SaveOrderModel({this.statuse, this.order});

  SaveOrderModel.fromJson(Map<String, dynamic> json) {
    statuse = json['status'];
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }
}

class Order {
  int? id;
  int? productCount;
  var orderPrice;
  var shippingPrice;
  var totalPrice;
  var discount;
  var invoiceId;
  var invoicelink;
  String? createdAt;
  String? paymentMethod;
  List<ProductsData>? productsData;
  ShippingAddress? shippingAddress;
  Order(
      {this.id,
      this.shippingAddress,
      this.productCount,
      this.createdAt,
      this.discount,
      this.invoiceId,
      this.invoicelink,
      this.orderPrice,
      this.paymentMethod,
      this.productsData,
      this.shippingPrice,
      this.totalPrice});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productCount = json['products_count'];
    orderPrice = json['order_price'];
    shippingPrice = json['shipping_price'];
    totalPrice = json['total_price'];
    paymentMethod = json['payment_method'];
    createdAt = json['created_at'];
    discount = json['discount'];
    invoiceId = json['invoice_id'];
    invoicelink = json['invoice_link'];
    if (json['products'] != null) {
      productsData = <ProductsData>[];
      json['products'].forEach((v) {
        productsData!.add(ProductsData.fromJson(v));
      });
    }
    shippingAddress = json['shipping_address'] != null
        ? ShippingAddress.fromJson(json['shipping_address'])
        : null;
  }
}

class ProductsData {
  int? id;
  String? image;
  String? nameAr;
  String? nameEn;
  String? descriptionEn;
  String? descriptionAr;
  var productPrice;
  var salePrice;
  int? quantity;
  bool? isoffer;

  ProductsData(
      {this.id,
      this.image,
      this.nameAr,
      this.nameEn,
      this.productPrice,
      this.salePrice,
      this.quantity,
      this.isoffer});
  ProductsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = imagePath + json['img'];
    nameAr = json['name_ar'];
    nameAr = json['name_ar'];
    descriptionEn = json['description_en'];
    descriptionAr = json['description_ar'];
    productPrice = json['pivot']['regular_price'];
    salePrice = json['pivot']['sale_price'];
    quantity = json['pivot']['quantity'];
    isoffer = json['in_sale'];

  }
}

class ShippingAddress {
  int? id;
  String? title;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? addressD;
  String? countryEn;
  String? countryAr;
  String? araeEn;
  String? araeAr;

  ShippingAddress(
      {this.id,
      this.address,
      this.email,
      this.phone,
      this.name,
      this.title,
      this.addressD,
      this.araeAr,
      this.araeEn,
      this.countryEn,
      this.countryAr});
  ShippingAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    addressD = json['address_d'];
    araeEn = json['area']['name_en'];
    araeAr = json['area']['name_ar'];
    countryEn = json['area']['country']['name_en'];
    countryAr = json['area']['country']['name_ar'];
  }
}
