// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/home_item.dart';

import 'new_item.dart';

class NewPackageItemProvider extends ChangeNotifier {
  List<Item> items = [];
  int pageIndex = 1;
  Ads? ads;
  bool finish = false;
  String? sort;
  List sorts = [
    'Low price',
    'High price',
    'New',
  ];
  void clearList() {
    sort = null;
    items.clear();
    pageIndex = 1;
  }

  void sortList(int index) {
    if (index == 0) {
      items.sort((a, b) {
        return a.finalPrice.compareTo(b.finalPrice);
      });
    } else if (index == 1) {
      items.sort((a, b) {
        return b.finalPrice.compareTo(a.finalPrice);
      });
    } else {
      items.sort((a, b) {
        return a.id.compareTo(b.id);
      });
    }
    sort = sorts[index];
    notifyListeners();
  }

  void setItemsProvider(List list, String subCatID) {
    if (list.isEmpty || list == []) {
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
      pageIndex++;
      notifyListeners();
    }
  }

  Future getItems(id) async {
    final String url =
        domain + 'get-new-products/${id.toString()}?page=$pageIndex';
    try {
      Response response = await Dio().get(url);
      if (response.data['status'] == 1) {
        if (response.data['data']['ads'] != null) {
          Map e = response.data['data']['ads'];
          ads = Ads(
              id: e['id'],
              image: e['src'] + '/' + e['img'],
              link: e['link'],
              position: e['position'],
              type: e['type'] == 'product' ? true : false,
              inApp: checkBool(e['in_app']));
        } else {
          ads = null;
        }
        setItemsProvider(response.data['data']['products'],
            response.data['data']['category']['id'].toString());
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

class BestPackageItemProvider extends ChangeNotifier {
  List<Item> items = [];
  int pageIndex = 1;
  Ads? ads;
  bool finish = false;
  String? sort;
  List sorts = [
    'Low price',
    'High price',
    'New',
  ];
  void clearList() {
    sort = null;
    items.clear();
    pageIndex = 1;
  }

  void sortList(int index) {
    if (index == 0) {
      items.sort((a, b) {
        return a.finalPrice.compareTo(b.finalPrice);
      });
    } else if (index == 1) {
      items.sort((a, b) {
        return b.finalPrice.compareTo(a.finalPrice);
      });
    } else {
      items.sort((a, b) {
        return a.id.compareTo(b.id);
      });
    }
    sort = sorts[index];
    notifyListeners();
  }

  void setItemsProvider(List list) {
    if (list.isEmpty || list == []) {
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
      pageIndex++;
      notifyListeners();
    }
  }

  Future getItems(id) async {
    final String url =
        domain + 'get-best-products/${id.toString()}?page=$pageIndex';
    try {
      Response response = await Dio().get(url);

      if (response.data['status'] == 1) {
        if (response.data['data']['ads'] != null) {
          Map e = response.data['data']['ads'];
          ads = Ads(
              id: e['id'],
              image: e['src'] + '/' + e['img'],
              link: e['link'],
              position: e['position'],
              type: e['type'] == 'product' ? true : false,
              inApp: checkBool(e['in_app']));
        } else {
          ads = null;
        }
        setItemsProvider(response.data['data']['products']);
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

class RePackageItemProvider extends ChangeNotifier {
  List<Item> items = [];
  Ads? ads;
  int pageIndex = 1;
  bool finish = false;
  String? sort;
  List sorts = [
    'Low price',
    'High price',
    'New',
  ];
  void clearList() {
    sort = null;
    items.clear();
    pageIndex = 1;
  }

  void sortList(int index) {
    if (index == 0) {
      items.sort((a, b) {
        return a.finalPrice.compareTo(b.finalPrice);
      });
    } else if (index == 1) {
      items.sort((a, b) {
        return b.finalPrice.compareTo(a.finalPrice);
      });
    } else {
      items.sort((a, b) {
        return a.id.compareTo(b.id);
      });
    }
    sort = sorts[index];
    notifyListeners();
  }

  void setItemsProvider(List list, String subCatID) {
    print("\n ${subCatID.toString()}");
    if (list.isEmpty || list == []) {
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
      pageIndex++;
      notifyListeners();
    }
  }

  Future getItems(id) async {
    final String url =
        domain + 'get-new-products/${id.toString()}?page=$pageIndex';
    try {
      Response response = await Dio().get(url);
      print(response.data.toString());
      if (response.data['status'] == 1) {
        if (response.data['data']['ads'] != null) {
          Map e = response.data['data']['ads'];
          ads = Ads(
              id: e['id'],
              image: e['src'] + '/' + e['img'],
              link: e['link'],
              position: e['position'],
              type: e['type'] == 'product' ? true : false,
              inApp: checkBool(
                e['in_app'],
              ));
        } else {
          ads = null;
        }
        setItemsProvider(response.data['data']['products'],
            response.data['data']['category']['id'].toString());
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
