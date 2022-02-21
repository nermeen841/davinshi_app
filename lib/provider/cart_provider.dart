import 'package:flutter/cupertino.dart';
import 'package:davinshi_app/models/cart.dart';
import 'package:davinshi_app/models/products_cla.dart';

class CartProvider extends ChangeNotifier {
  List<CartProducts> items = [];
  List<int> idp = []; //list for students id
  List<int> ids = []; //list for students id
  List<int> idc = []; //list for categories id
  num subTotal = 0.0;
  num delivery = 0.0;
  num total = 0.0;
  String idProducts = '';
  String quan = '';
  String st = '';
  String op = '';
  List<CartClass> cart = [];
  List<Cat> _cat = [];
  Future setItems() async {
    items = await dbHelper.allProducts();
    var sub = 0.0;
    idProducts = '';
    quan = '';
    st = '';
    op = '';
    cart.clear();
    ids.clear();
    idp.clear();
    _cat.clear();
    idc.clear();
    for (var e in items) {
      cartId = e.studentId;
      sub += num.parse((e.price * e.quantity).toStringAsFixed(2));
      idp.add(e.idp);
      ids.add(e.studentId);
      if (!idc.contains(e.idc)) {
        idc.add(e.idc);
        _cat.add(Cat(
            id: e.idc,
            nameAr: e.catNameAr,
            nameEn: e.catNameEn,
            svg: e.catSVG));
      }
    }
    for (int i = 0; i < _cat.length; i++) {
      List<CartProducts> cartPro =
          items.where((element) => element.idc == _cat[i].id).toList();
      cart.add(
        CartClass(
            nameAr: _cat[i].nameAr,
            nameEn: _cat[i].nameEn,
            svg: _cat[i].svg,
            cartPro: cartPro),
      );
    }
    subTotal = sub;
    total = subTotal + delivery;
    for (int i = 0; i < idp.length; i++) {
      idProducts += idp[i].toString() + ',';
    }
    if (idProducts.endsWith(',')) {
      idProducts = idProducts.substring(0, idProducts.length - 1);
    }
    for (int i = 0; i < items.length; i++) {
      quan +=
          items[i].idp.toString() + '=>' + items[i].quantity.toString() + ',';
    }
    if (quan.endsWith(',')) {
      quan = quan.substring(0, quan.length - 1);
    }
    for (int i = 0; i < items.length; i++) {
      if (items[i].studentId != 0) {
        st += items[i].studentId.toString() + '=>' + items[i].idp.toString();
        if (i != items.length - 1) {
          st += ',';
        }
      }
    }
    if (st.endsWith(',')) {
      st = st.substring(0, st.length - 1);
    }
    for (int i = 0; i < items.length; i++) {
      if (items[i].att.isNotEmpty) {
        op += items[i].idp.toString() + '=>';
      }
      for (int q = 0; q < items[i].att.length; q++) {
        if (items[i].att[q] != 0) {
          op += items[i].att[q].toString() + ',';
        }
      }
    }
    if (op.endsWith(',')) {
      op = op.substring(0, op.length - 1);
    }
    notifyListeners();
  }

  void clearAll() {
    cartId = null;
    items = [];
    idp = [];
    ids = [];
    idc = [];
    subTotal = 0.0;
    delivery = 0.0;
    total = 0.0;
    idProducts = '';
    quan = '';
    st = '';
    op = '';
    cart = [];
    _cat = [];
    notifyListeners();
  }
}
