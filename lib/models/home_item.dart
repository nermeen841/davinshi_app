// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:davinshi_app/provider/new_item.dart';
import 'package:davinshi_app/provider/student_provider.dart';
import 'cat.dart';
import 'constants.dart';

List<Item> offerEnd = [];
List<Item> newItem = [];
List<Item> bestItem = [];
List<Item> reItem = [];
List<Item> bestDis = [];
List<Item> bestPrice = [];
List<Item> topLikes = [];
List<Item> topRate = [];
List<IconHome> icons = [];
List<HomeInfo> homeInfo = [];
List<Slider> slider = [];
List<Ads> ads = [];
List<SubCategories> subCat = [];

List<StudentClass> stu = [];

class HomeInfo {
  String title;
  HomeInfo({required this.title});
}

class IconHome {
  String image;
  String link;
  IconHome({required this.image, required this.link});
}

class Slider {
  int id;
  String image;
  String link;
  bool type;
  bool inApp;
  Slider(
      {required this.id,
      required this.image,
      required this.link,
      required this.type,
      required this.inApp});
}

class Ads {
  int id;
  int position;
  String image;
  String link;
  bool type;
  bool inApp;

  Ads(
      {required this.id,
      required this.position,
      required this.image,
      required this.link,
      required this.type,
      required this.inApp});
}

List<Ads> getAds(int _ads) {
  if (ads.isEmpty) {
    return [];
  }
  // print("${ads.length}");
  return ads.where((element) => element.position == _ads).toList();
}

void setAllItems(Map data) {
  slider.clear();
  ads.clear();
  homeInfo.clear();
  icons.clear();
  topRate.clear();
  topLikes.clear();
  offerEnd.clear();
  newItem.clear();
  bestItem.clear();
  reItem.clear();
  bestDis.clear();
  bestPrice.clear();
  subCat.clear();
  stu.clear();

  data['categories'].forEach((e) {
    List _s = e['sub_categories'];
    if (_s.isNotEmpty) {
      SubCategories _su = SubCategories(
          image: _s[0]['src'] + '/' + _s[0]['img'],
          nameEn: _s[0]['name_en'],
          id: _s[0]['id'],
          nameAr: _s[0]['name_ar']);
      subCat.add(_su);
    }
  });

  data['brands']['data'].forEach((e) {
    StudentClass _st = StudentClass(
        id: e['id'],
        name: e['name'],
        email: e['email'],
        phone: e['phone'],
        date: e['date'],
        university: e['university'],
        major: e['major'],
        image: e['img_src'] + '/' + e['img'],
        cover: e['img_src'] + '/' + e['cover'],
        facebook: e['facebook'],
        instagram: e['instagram'],
        linkedin: e['linkedin'],
        twitter: e['twitter']);
    stu.add(_st);
  });

  data['sliders'].forEach((e) {
    Slider _slider = Slider(
        id: e['id'],
        image: e['src'] + '/' + e['img'],
        link: e['link'],
        type: e['type'] == 'product' ? true : false,
        inApp: checkBool(e['in_app']));
    slider.add(_slider);
  });

  data['icons'].forEach((e) {
    IconHome _icon =
        IconHome(image: e['src'] + '/' + e['img'], link: e['link']);
    icons.add(_icon);
  });
  data['informations'].forEach((e) {
    HomeInfo _info = HomeInfo(title: e['title']);
    homeInfo.add(_info);
  });
  data['offerEndingSoon'].forEach((e) {
    Item _item = setItem(e);
    offerEnd.add(_item);
  });
  data['topLikes'].forEach((e) {
    Item _item = setItem(e);
    topLikes.add(_item);
  });
  data['topRating'].forEach((e) {
    Item _item = setItem(e);
    topRate.add(_item);
  });
  data['newProducts'].forEach((e) {
    Item _item = setItem(e);
    newItem.add(_item);
  });
  data['bestProducts'].forEach((e) {
    Item _item = setItem(e);
    bestItem.add(_item);
  });
  data['recommendedProducts'].forEach((e) {
    Item _item = setItem(e);
    reItem.add(_item);
  });
  data['bestDiscount'].forEach((e) {
    Item _item = setItem(e);
    bestDis.add(_item);
  });
  data['bestPrice'].forEach((e) {
    Item _item = setItem(e);
    bestPrice.add(_item);
  });
  data['ads'].forEach((e) {
    print(e['src'] + '/' + e['img']);
    Ads _ads = Ads(
        id: e['id'],
        image: e['src'] + '/' + e['img'],
        link: e['link'],
        position: e['position'],
        type: e['type'] == 'product' ? true : false,
        inApp: checkBool(e['in_app']));
    ads.add(_ads);
  });
}

Future getHomeItems() async {
  final String url = domain + 'get-home-products';
  try {
    Response response = await Dio().get(
      url,
      options: Options(headers: {
        'Content-language': prefs.getString('language_code').toString().isEmpty
            ? 'en'
            : prefs.getString('language_code').toString()
      }),
    );
    if (response.data['status'] == 1) {
      // print("\n\nhomeItemsResponse:${response.data.toString()}");
      setAllItems(response.data['data']);
    }
    if (response.statusCode != 200) {
      await Future.delayed(const Duration(milliseconds: 700));
      getHomeItems();
    }
  } catch (e) {
    print(e);
    await Future.delayed(const Duration(milliseconds: 700));
    getHomeItems();
  }
}

Item setItem(Map e) {
  return Item(
      id: e['id'],
      image: imagePath + e['img'],
      nameEn: e['name_en'],
      nameAr: e['name_ar'],
      disPer: e['discount_percentage'],
      isSale: e['in_sale'],
      price: num.parse(e['regular_price'].toString()),
      salePrice: num.parse(e['sale_price'].toString()),
      finalPrice: e['in_sale']
          ? num.parse(e['sale_price'].toString())
          : num.parse(e['regular_price'].toString()));
}

bool checkPosition(int position) {
  for (var e in ads) {
    if (e.position == position) {
      return true;
    }
  }
  return false;
}

bool checkBool(var val) {
  if (val is bool) {
    return val;
  } else {
    if (val == 1) {
      return true;
    } else {
      return false;
    }
  }
}

Ads getAdsPosition(int position) {
  return ads.firstWhere((e) => e.position == position);
}
