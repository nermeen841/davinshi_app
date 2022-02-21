// class Cart{
//   int id;
//   num subTotal;
//   num total;
//   num? shippingPrice;
//   String? note;
//   int? shippingAddressId;
//   List<CartProducts> products;
//   Cart({required this.id, required this.subTotal, required this.total,
//     required this.shippingPrice,required this.products,this.note,this.shippingAddressId});
// }

// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:convert';

import '../dbhelper.dart';

DbHelper dbHelper = DbHelper();

class CartProducts {
  int? id;
  int idp;
  int idc;
  int studentId;
  String image;
  String catSVG;
  String titleAr;
  String titleEn;
  String catNameAr;
  String catNameEn;
  num price;
  int quantity;
  List<int> att;
  List<String> des;
  CartProducts(
      {required this.catSVG,
      required this.idc,
      required this.catNameAr,
      required this.catNameEn,
      required this.id,
      required this.studentId,
      required this.image,
      required this.titleAr,
      required this.titleEn,
      required this.price,
      required this.quantity,
      required this.att,
      required this.des,
      required this.idp});
  Map<String, dynamic> toMap() => {
        'id': id,
        'idp': idp,
        'studentId': studentId,
        'image': image,
        'titleAr': titleAr,
        'titleEn': titleEn,
        'price': price,
        'quantity': quantity,
        'att': jsonEncode(att),
        'des': jsonEncode(des),
        'idc': idc,
        'svg': catSVG,
        'catNameAr': catNameAr,
        'catNameEn': catNameEn
      };
  CartProducts fromMap(Map<String, dynamic> map) {
    return CartProducts(
      id: map['id'],
      studentId: map['studentId'],
      image: map['image'],
      titleAr: map['titleAr'],
      titleEn: map['titleEn'],
      price: map['price'],
      quantity: map['quantity'],
      att: map['att'],
      des: map['des'],
      idp: map['idp'],
      idc: map['idc'],
      catNameAr: map['catNameAr'],
      catNameEn: map['catNameEn'],
      catSVG: map['svg'],
    );
  }

  static List<CartProducts> listFromMap(List<Map<String, dynamic>> list) {
    List<CartProducts> _list = [];
    list.forEach((map) {
      List<int> _int = [];
      jsonDecode(map['att']).forEach((e) {
        _int.add(e);
      });
      List<String> _string = [];
      jsonDecode(map['des']).forEach((e) {
        _string.add(e);
      });
      _list.add(CartProducts(
        id: map['id'],
        studentId: map['studentId'],
        image: map['image'],
        titleAr: map['titleAr'],
        titleEn: map['titleEn'],
        price: map['price'],
        quantity: map['quantity'],
        att: _int,
        des: _string,
        idp: map['idp'],
        idc: map['idc'],
        catNameAr: map['catNameAr'],
        catNameEn: map['catNameEn'],
        catSVG: map['svg'],
      ));
    });
    return _list;
  }
}

int? cartId;

class CartClass {
  String nameAr;
  String nameEn;
  String svg;
  List<CartProducts> cartPro;
  CartClass(
      {required this.nameAr,
      required this.nameEn,
      required this.svg,
      required this.cartPro});
}
