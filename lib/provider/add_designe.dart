// ignore_for_file: avoid_print
import 'package:davinshi_app/models/constants.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../models/user.dart';

Future addDesigne(
    {required String name,
    required String email,
    required RoundedLoadingButtonController controller,
    required String phone,
    required String designeName,
    required context,
    required List<String> images,
    required String note}) async {
  final String url = domain + "designs/request";

  FormData formData = FormData.fromMap({
    "user_name": name,
    "email": email,
    "phone": phone,
    "design_name": designeName,
    "note": note,
    "image[]": [
      await MultipartFile.fromFile(
        images[0],
      ),
      await MultipartFile.fromFile(images[1]),
      await MultipartFile.fromFile(images[2]),
    ]
  });
  try {
    dio.Response response = await dio.Dio().post(
      url,
      data: formData,
      options: dio.Options(headers: {"auth-token": auth}),
    );
    print(response.data);
    if (response.data['status'] == 1) {
      controller.success();
      await Future.delayed(const Duration(seconds: 1));
      controller.stop();
      Navigator.pop(context);
    } else {
      controller.error();
      await Future.delayed(const Duration(seconds: 1));
      controller.stop();
    }
  } catch (e) {
    controller.error();
    await Future.delayed(const Duration(seconds: 1));
    controller.stop();
    print("errrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr:   " + e.toString());
  }
}
