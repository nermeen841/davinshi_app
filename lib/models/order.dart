// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/provider/address.dart';
import 'constants.dart';

class OrderClass {
  int id;
  int userId;
  int addressId;
  String date;
  String orderStatus;
  String titleEn;
  String titleAr;
  String image;
  String? note;
  num subTotal;
  num total;
  num delivery;
  num dis;
  List<OrderItems> items;
  AddressClass? userAddress;
  OrderClass(
      {required this.note,
      required this.addressId,
      required this.id,
      required this.userId,
      required this.subTotal,
      required this.total,
      required this.delivery,
      required this.items,
      required this.date,
      required this.orderStatus,
      required this.dis,
      required this.titleEn,
      required this.titleAr,
      required this.image,
      required this.userAddress});
}

class OrderItems {
  int id;
  String titleAr;
  String titleEn;
  String desAr;
  String desEn;
  String image;
  int quantity;
  num price;
  OrderItems(
      {required this.desAr,
      required this.desEn,
      required this.id,
      required this.titleAr,
      required this.titleEn,
      required this.image,
      required this.quantity,
      required this.price});
}

List<OrderClass> orders = [];
Future setOrder(List list) async {
  orders.clear();
  list.forEach((e) {
    List<OrderItems> _items = [];
    e['products'].forEach((i) {
      String desAr = '';
      String desEn = '';
      List att = jsonDecode(i['pivot']['attributes']);
      att.forEach((at) {
        desAr += at['name_ar'] + ',';
        desEn += at['name_en'] + ',';
      });
      if (desAr.endsWith(',')) {
        desAr = desAr.substring(0, desAr.length - 1);
        desEn = desEn.substring(0, desEn.length - 1);
      }
      _items.add(OrderItems(
          id: i['id'],
          titleAr: i['name_ar'],
          titleEn: i['name_en'],
          image: imagePath + i['img'],
          desAr: desAr,
          desEn: desEn,
          quantity: i['pivot']['quantity'],
          price: num.parse(i['pivot']['regular_price'].toString())));
    });
    String date = e['created_at'];
    date = date.split('.').first.replaceAll('T', ' ');
    orders.add(OrderClass(
        userAddress: null,
        note: e['note'],
        addressId: e['shipping_address_id'],
        id: e['id'],
        userId: e['user_id'],
        subTotal: e['order_price'],
        total: e['total_price'],
        delivery: e['shipping_price'],
        items: _items,
        date: date,
        orderStatus: e['status'],
        dis: e['discount'],
        titleEn: _items[0].titleEn,
        titleAr: _items[0].titleAr,
        image: _items[0].image));
  });
}

// OrderClass getOrderId(int id){
//   return orders.firstWhere((e) => e.id==id);
// }
Future updateOrder(int id, Map e) async {
  Map ad = e['shipping_address'];
  OrderClass _order = orders.firstWhere((e) => e.id == id);
  AddressClass _address = AddressClass(
      id: ad['id'],
      userId: ad['user_id'],
      areaId: ad['area_id'],
      title: ad['title'],
      name: ad['name'],
      email: ad['email'],
      country: ad['address_d'] ?? '',
      phone1: ad['phone'],
      note: ad['note'],
      address: ad['address'],
      lat: 0.0,
      long: 0.0);
  _order.userAddress = _address;
}

Future<bool> getOrders() async {
  final String url = domain + 'get-orders';
  try {
    Response response = await Dio().post(
      url,
      options: Options(headers: {"auth-token": auth}),
    );
    if (response.data['status'] == 1) {
      await setOrder(response.data['orders']);
      return true;
    }
    if (response.statusCode != 200) {}
  } catch (e) {
    print('e');
    print(e);
  }
  return false;
}

Future<bool> getOrder(id) async {
  final String url = domain + 'get-order';
  try {
    Response response = await Dio().post(
      url,
      data: {"id": id},
      options: Options(headers: {"auth-token": auth}),
    );
    if (response.data['status'] == 1) {
      await updateOrder(id, response.data['order']);
      return true;
    }
    if (response.statusCode != 200) {}
  } catch (e) {
    print('e');
    print(e);
  }
  return false;
}
