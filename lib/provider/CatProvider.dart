// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:davinshi_app/models/cat.dart';
import 'package:davinshi_app/models/constants.dart';

class CatProvider extends ChangeNotifier {
  Future<List<Category>> getParentCat() async {
    List<Category> categoryList = [];
    final String url = domain + 'get-parent-categories';
    Response response = await Dio().get(
      url,
      options: Options(headers: {
        'Content-language': prefs.getString('language_code').toString().isEmpty
            ? 'en'
            : prefs.getString('language_code').toString()
      }),
    );
    if (response.data['status'] == 1) {
      await setCat(response.data['data']).then((value) {});
      for (var data in response.data['data']) {
        var thisList = Category(
          nameEn: data['name_en'].toString(),
          nameAr: data['name_ar'].toString(),
          image: imagePathCat + data['img'].toString(),
          id: data['id'],
          subCategories: List<SubCategories>.from(
              data["sub_categories"].map((x) => SubCategories.fromJson(x))),
        );
        categoryList.add(thisList);
      }
    }
    return categoryList;
  }

  List<Category> categories = [];
  List<SubCategories> sub = [];
  List<SubCategories> allSub = [];
  Future setCat(List _cat) async {
    categories = [];
    allSub.clear();
    for (var e in _cat) {
      List<SubCategories> _subCat = [];
      e['sub_categories'].forEach((q) {
        _subCat.add(SubCategories(
            image: q['src'] + '/' + q['img'],
            nameEn: q['name_en'],
            id: q['id'],
            nameAr: q['name_ar']));
      });
      allSub.addAll(_subCat);
      categories.add(Category(
          image: e['src'] + '/' + e['img'],
          nameEn: e['name_en'],
          id: e['id'],
          nameAr: e['name_ar'],
          subCategories: _subCat));
    }
    sub = allSub;
  }
}
