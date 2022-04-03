// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:flutter/material.dart';
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
  final String url = domain + 'designs/save-rating';
  final int ratingValue = rating.toInt();
  try {
    dio.Response response = await dio.Dio().post(
      url,
      data: {
        "design_id": designeID,
        "rating": ratingValue,
        'comment': comment,
      },
      options: dio.Options(headers: {"auth-token": auth}),
    );
    if (response.statusCode == 200 && response.data['status'] == 1) {
      alertSuccessData(context, translate(context, 'home', 'review'));
      controller.success();
      await Future.delayed(const Duration(milliseconds: 2500));
    } else {
      controller.error();
      await Future.delayed(const Duration(milliseconds: 2500));
      controller.stop();
    }
  } catch (e) {
    print("errrrrrrrrrrrrrrrro ratiiiiiiiiiiiiiiiiiiing : " + e.toString());
    controller.error();
    await Future.delayed(const Duration(milliseconds: 2500));
    controller.stop();
  }
}
////////////////////////////////////////////////////////////////////////////////////////////

Future editDesigneRating(
    {required RoundedLoadingButtonController controller,
    required double rating,
    required context,
    required String comment,
    required String ratingId}) async {
  final String url = domain + 'designs/edit-rating';
  final int ratingValue = rating.toInt();
  try {
    dio.Response response = await dio.Dio().post(
      url,
      data: {
        "rating_id": ratingId,
        "rating": ratingValue,
        'comment': comment,
      },
      options: dio.Options(headers: {"auth-token": auth}),
    );
    print(response.data);
    if (response.statusCode == 200 && response.data['status'] == 1) {
      alertSuccessData(context, translate(context, 'home', 'review'));
      controller.success();
      await Future.delayed(const Duration(milliseconds: 2500));
    } else {
      controller.error();
      await Future.delayed(const Duration(milliseconds: 2500));
      controller.stop();
      final snackBar = SnackBar(
        content: Text(translateString(
            "please enter your rate", 'من فضلك قم بادخال تقييمك')),
        action: SnackBarAction(
          label: translateString('Undo', 'تراجع'),
          disabledTextColor: Colors.yellow,
          textColor: Colors.yellow,
          onPressed: () => navPop(context),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  } catch (e) {
    print("errrrrrrrrrrrrrrrro ratiiiiiiiiiiiiiiiiiiing : " + e.toString());
    controller.error();
    await Future.delayed(const Duration(milliseconds: 2500));
    controller.stop();
  }
}

//////////////////////////////////////////////////////////////////////////////////

Future deleteDesigneRating({required String ratingId, required context}) async {
  final String url = domain + 'designs/delete-rating';

  try {
    dio.Response response = await dio.Dio().post(
      url,
      data: {
        "rating_id": ratingId,
      },
      options: dio.Options(headers: {"auth-token": auth}),
    );
    print(response.data);
    if (response.statusCode == 200 && response.data['status'] == 1) {
    } else {
      final snackBar = SnackBar(
        content: Text(translateString(
            "you can't delete this comment", 'لا يمكنك حذف هذا التقييم')),
        action: SnackBarAction(
          label: translateString('Undo', 'تراجع'),
          disabledTextColor: Colors.yellow,
          textColor: Colors.yellow,
          onPressed: () => navPop(context),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  } catch (e) {
    print("errrrrrrrrrrrrrrrro ratiiiiiiiiiiiiiiiiiiing : " + e.toString());
    error(context);
  }
}
