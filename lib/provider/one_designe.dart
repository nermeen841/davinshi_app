// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../lang/change_language.dart';
import '../models/single_designe.dart';

class OneDesigne extends ChangeNotifier {
  static OneItemModel? oneItemModel;
  Future getoneDesigne({required String id}) async {
    try {
      var response = await http.get(Uri.parse(domain + "designs/$id"));
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        oneItemModel = OneItemModel.fromJson(data);

        return oneItemModel;
      }
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  //////////////////////////////////////////////////////////////////////////////

}

Future addRate(
    {required RoundedLoadingButtonController controller,
    required double rating,
    required context,
    required String comment,
    required String designeID}) async {
  final String url = domain + 'save-rating';
  try {
    dio.Response response = await dio.Dio().post(
      url,
      data: {
        "design_id": designeID,
        "rating": rating,
        'comment': comment,
      },
      options: dio.Options(headers: {"auth-token": auth}),
    );
    if (response.statusCode == 200 && response.data['status'] == 1) {
      alertSuccessData(context, translate(context, 'home', 'review'));
      controller.success();
      await Future.delayed(const Duration(milliseconds: 2500));
      controller.stop();
    } else {
      controller.error();
      await Future.delayed(const Duration(milliseconds: 2500));
      controller.stop();
    }
  } catch (e) {
    print(e.toString());
    controller.error();
    await Future.delayed(const Duration(milliseconds: 2500));
    controller.stop();
  }
}
