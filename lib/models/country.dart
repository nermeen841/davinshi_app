// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, prefer_typing_uninitialized_variables

import 'package:dio/dio.dart';

import 'constants.dart';

class Countries {
  int id;
  int number;
  String nameAr;
  String nameEn;
  String code;
  String image;
  String currencyName;
  var currencyRatio;
  String currencyCodeEn;
  String currencyCodeAr;

  List<Area> areas;
  Countries({
    required this.currencyRatio,
    required this.number,
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.code,
    required this.image,
    required this.currencyName,
    required this.areas,
    required this.currencyCodeEn,
    required this.currencyCodeAr,
  });
}

List<Countries> countries = [];
List<Area> allArea = [];
List<int> areasId = [];
void setCountries(List country) {
  countries.clear();
  country.forEach((e) {
    List<Area> _area = [];
    for (var a in e['areas']) {
      _area.add(Area(
          id: a['id'],
          nameAr: a['name_ar'],
          nameEn: a['name_en'],
          price: a['shipping_price']));
      areasId.add(a['id']);
    }
    // allArea.addAll(_area);
    countries.add(Countries(
        number: e['count_number_phone'],
        id: e['id'],
        nameAr: e['name_ar'],
        nameEn: e['name_en'],
        code: e['code_phone'],
        image: e['src'] + '/' + e['flag'],
        currencyName: e['currency']['name'],
        currencyCodeEn: e['currency']['code_en'],
        currencyCodeAr: e['currency']['code_ar'],
        currencyRatio: e['currency']['rate'],
        areas: _area));
  });
  int cId = prefs.getInt('countryId') ?? 0;
  String cCode = prefs.getString('countryKey') ?? '';
  int cNumber = prefs.getInt('countryNumber') ?? 0;
  setCountryId(cId, cCode, cNumber);
}

int countryId = 0;
late String countryCode;
late int countryNumber;
void setCountryId(int id, String code, int _countryNumber) {
  prefs.setInt('countryId', id);
  prefs.setInt('countryNumber', _countryNumber);
  prefs.setString('countryKey', code);
  countryCode = code;
  countryNumber = _countryNumber;
  countryId = id;
  if (id != 0) {
    allArea = countries.firstWhere((element) => element.id == id).areas;
  }
}

class Area {
  int id;
  String nameAr;
  String nameEn;
  num price;
  Area(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.price});
}

num getAreaPrice(int id) {
  num? price;
  for (var e in countries) {
    for (var a in e.areas) {
      if (a.id == id) {
        price = a.price;
      }
    }
  }
  return price ?? 0;
}

Future getCountries() async {
  final String url = domain + 'get-countries';

  print(url);
  try {
    Response response = await Dio().get(url);
    // print(response.data);
    if (response.data['status'] == 1) {
      setCountries(response.data['data']);
    } else {
      print('error');
    }
  } catch (e) {
    print(e);
  }
}
