import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:davinshi_app/models/cat.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/products_cla.dart';

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
    // print("getParentCatResponse:  "+response.data.toString());
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
        // print("img: ${imagePath+data['img'].toString()}");
        // print("img: ${imagePath2+data['img'].toString()}");
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

  Future<List<ProductsModel>> getProducts(String catID) async {
    List<ProductsModel> productList = [];
    final String url = domain + 'get-new-products/${catID.toString()}?page=1';
    Response response = await Dio().get(
      url,
      options: Options(headers: {
        'Content-language': prefs.getString('language_code').toString().isEmpty
            ? 'en'
            : prefs.getString('language_code').toString()
      }),
    );
    // print("url: $url");
    // print("getProductsResponse:  "+response.data.toString()+"\n\n");
    if (response.data['status'] == 1) {
      for (var data in response.data['data']['products']) {
        var thisList = ProductsModel(
          id: data['id'].toString(),
          img: imagePath + data['img'],
          name: data['name_ar'].toString(),
          sale_price: data['sale_price'].toString(),
          regular_price: data['regular_price'].toString(),
          disPer: data['discount_percentage'].toString(),
          in_sale: data['in_sale'].toString() == "true" ? true : false,
        );
        // print("img: ${imagePath+data['img'].toString()}");
        // print("img: ${imagePath2+data['img'].toString()}");
        productList.add(thisList);
      }
    }
    return productList;
  }
}
