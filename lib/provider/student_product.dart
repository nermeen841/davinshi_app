// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:davinshi_app/models/constants.dart';
import 'new_item.dart';

class StudentItemProvider extends ChangeNotifier {
  List<Item> items = [];
  List<Item> offers = [];
  int pageIndex = 1;
  bool finish = false;
  String? sort;
  List sorts = [
    'Low price',
    'High price',
    'New',
  ];

  List sortsAr = [
    'سعر أقل',
    'سعر أعلي',
    'جديد',
  ];
  List<String> apiSort = ["highestPrice", "lowestPrice", "bestSeller"];
  void clearList() {
    sort = null;
    items.clear();
    offers.clear();
    pageIndex = 1;
  }

  void sortList(int index, String id) {
    if (index == 0) {
      items.clear();
      getItems(id);
    } else if (index == 1) {
      items.clear();
      getItems(id);
    } else {
      items.clear();
      getItems(id);
    }
    sort = apiSort[index];
    notifyListeners();
  }

  void setItemsProvider(Map map) {
    List list = map['products'];
    List _offers = map['offers'];
    if (list.isEmpty && _offers.isEmpty) {
      finish = true;
      notifyListeners();
    } else {
      for (var e in list) {
        Item _item = Item(
            id: e['id'],
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

      notifyListeners();
    }
  }

  Future getItems(id) async {
    final String url = domain +
        'get-products-student?student_id=${id.toString()}&page=$pageIndex&sort=$sort';
    try {
      Response response = await Dio().get(url);
      if (response.data['status'] == 1) {
        setItemsProvider(response.data['data']);
      }
      if (response.statusCode != 200) {
        await Future.delayed(const Duration(milliseconds: 700));
        getItems(id);
      }
    } catch (e) {
      print(e);
      await Future.delayed(const Duration(milliseconds: 700));
      getItems(id);
    }
  }
}
