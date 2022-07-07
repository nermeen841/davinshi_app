// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:davinshi_app/models/constants.dart';
import 'new_item.dart';

class BrandData {
  String? brandName;
  String? brandImage;
  String? brandemail;
  String? brandphone;
  String? brandfacebook;
  String? brandtwitter;
  String? brandinstagram;
  String? brandlinkedin;
  int? brandId;
  BrandData(
      {this.brandId,
      this.brandImage,
      this.brandName,
      this.brandemail,
      this.brandfacebook,
      this.brandinstagram,
      this.brandlinkedin,
      this.brandphone,
      this.brandtwitter});
}

class StudentItemProvider extends ChangeNotifier {
  List<Item> items = [];
  List<Item> offers = [];
  BrandData? brandData;
  // StudentClass? studentClass;
  // String? brandName;
  // String? brandImage;
  // String? brandemail;
  // String? brandphone;
  // String? brandfacebook;
  // String? brandtwitter;
  // String? brandinstagram;
  // String? brandlinkedin;

  int? brandId;
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
    brandData = BrandData();
    // brandName = null;
    // brandImage = null;
    // brandemail = null;
    // brandphone = null;
    // brandfacebook = null;
    // brandtwitter = null;
    // brandinstagram = null;
    // brandlinkedin = null;
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
    if (map.containsKey("brand")) {
      brandData = BrandData(
          brandId: map['brand']['id'],
          brandName: map['brand']['name'],
          brandemail: map['brand']['email'],
          brandphone: map['brand']['phone'],
          brandImage: map['brand']['img'] == null
              ? null
              : map['brand']['img_src'] + '/' + map['brand']['img'],
          brandfacebook: map['brand']['facebook'],
          brandtwitter: map['brand']['twitter'],
          brandinstagram: map['brand']['instagram'],
          brandlinkedin: map['brand']['linkedin']);
      notifyListeners();
    }

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
      isLoading = true;
      pageIndex++;

      notifyListeners();
    }
  }

  getItems(id) async {
    final String url = domain + 'get-products-student';

    try {
      Response response = await Dio().get(
        url,
        queryParameters: {"student_id": id, "page": pageIndex, "sort": sort},
      );

      print(response.statusCode);
      if (response.data['status'] == 1) {
        await setItemsProvider(response.data['data']);
      } else if (response.data['status'] == 0) {
        await setItemsProvider(response.data['data']);
      }
      if (response.statusCode != 200) {
        await Future.delayed(const Duration(milliseconds: 700));
        getItems(id);
      }
    } catch (e) {
      isLoading = true;
      await Future.delayed(const Duration(milliseconds: 700));
      getItems(id);
    }
    notifyListeners();
  }
}
