// ignore_for_file: avoid_print

import 'package:davinshi_app/provider/student_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:davinshi_app/models/constants.dart';
import 'new_item.dart';

class StudentItemProvider extends ChangeNotifier {
  List<Item> items = [];
  List<Item> offers = [];
  StudentClass? studentClass;
  int pageIndex = 1;
  bool finish = false;
  bool isLoading = false;
  String sort = "";
  List sorts = [
    "All",
    'Low price',
    'High price',
    'New',
  ];

  List sortsAr = [
    "الكل",
    'الأحدث',
    'الأقل سعر',
    'الأعلي سعر',
  ];
  List<String> apiSort = ["", "bestSeller", "lowestPrice", "highestPrice"];
  void clearList() {
    sort = "";
    items.clear();
    offers.clear();
    studentClass = StudentClass();
    pageIndex = 1;
  }

  void sortList(int index, String id) {
    if (index == 0) {
      // items.clear();
      getItems(id);
    } else if (index == 1) {
      // items.clear();
      getItems(id);
    } else {
      // items.clear();
      getItems(id);
    }
    sort = apiSort[index];
    notifyListeners();
  }

  setItemsProvider(Map map) {
    List list = map['products'];
    List _offers = map['offers'];

    if (list.isEmpty && _offers.isEmpty) {
      finish = true;
      notifyListeners();
    } else {
      for (var e in list) {
        Item _item = Item(
            id: e['id'],
            isOrder: e['is_order'],
            finalPrice: e['in_sale']
                ? num.parse(e['sale_price'].toString())
                : num.parse(e['regular_price'].toString()),
            image: imagePath + e['img'],
            nameEn: e['name_en'],
            nameAr: e['name_ar'],
            disPer: e['discount_percentage'],
            isSale: e['in_sale'],
            price: num.parse(e['regular_price'].toString()),
            salePrice: num.parse(e['sale_price'].toString()));
        items.add(_item);
      }
      for (var e in _offers) {
        Item _item = Item(
            id: e['id'],
            isOrder: e['is_order'],
            finalPrice: e['in_sale']
                ? num.parse(e['sale_price'].toString())
                : num.parse(e['regular_price'].toString()),
            image: imagePath + e['img'],
            nameEn: e['name_en'],
            nameAr: e['name_ar'],
            disPer: e['discount_percentage'],
            isSale: e['in_sale'],
            price: num.parse(e['regular_price'].toString()),
            salePrice: num.parse(e['sale_price'].toString()));
        items.add(_item);
      }
      pageIndex++;
      isLoading = true;
      notifyListeners();
    }
  }

  Future<StudentClass> getItems(id) async {
    final String url = domain +
        'get-products-student?student_id=$id&page=$pageIndex&sort=$sort';

    try {
      Response response = await Dio(BaseOptions(
        connectTimeout: 5000,
        receiveTimeout: 3000,
        followRedirects: false,
        validateStatus: (status) => true,
      )).get(url);
      if (response.data['status'] == 1) {
        studentClass = StudentClass(
            id: response.data['data']['brand']['id'],
            name: response.data['data']['brand']['name'],
            email: response.data['data']['brand']['email'],
            phone: response.data['data']['brand']['phone'],
            image: response.data['data']['brand']['img'] == null
                ? null
                : response.data['data']['brand']['img_src'] +
                    '/' +
                    response.data['data']['brand']['img'],
            cover: response.data['data']['brand']['cover'] == null
                ? null
                : response.data['data']['brand']['img_src'] +
                    '/' +
                    response.data['data']['brand']['cover'],
            facebook: response.data['data']['brand']['facebook'],
            twitter: response.data['data']['brand']['twitter'],
            instagram: response.data['data']['brand']['instagram'],
            linkedin: response.data['data']['brand']['linkedin']);
        notifyListeners();
        setItemsProvider(response.data['data']);

        return studentClass!;
      }
      if (response.statusCode != 200) {
        await Future.delayed(const Duration(milliseconds: 700));
        getItems(id);
      }
    } catch (e) {
      print(e);
      isLoading = true;
      await Future.delayed(const Duration(milliseconds: 700));
      getItems(id);
    }
    notifyListeners();
    return studentClass!;
  }
}
