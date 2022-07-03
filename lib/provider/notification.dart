// ignore_for_file: avoid_print, unused_local_variable

import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/notification_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

void notificationToken() async {
  final String url = domain + "notifications/save_token";

  try {
    Response response = await Dio().post(
      url,
      data: {"fcm_token": prefs.getString('token').toString()},
      options: Options(
        headers: {"auth-token": prefs.getString('auth') ?? ""},
      ),
    );
    print(response.data);
  } catch (e) {
    print(e.toString());
  }
}

class NotificationProvider extends ChangeNotifier {
  NotificationModel? notificationModel;
  bool waitingData = false;
  getNotification() async {
    final String url = domain + "notifications";
    try {
      Response response = await Dio().post(
        url,
        data: {"fcm_token": prefs.getString('token').toString()},
        options: Options(
          headers: {
            'Content-language':
                prefs.getString('language_code').toString().isEmpty
                    ? 'en'
                    : prefs.getString('language_code').toString(),
            "auth-token": prefs.getString('auth') ?? "",
          },
        ),
      );
      print(response.data);
      if (response.data['status'] == 1) {
        waitingData = true;
        notificationModel = NotificationModel.fromJson(response.data);
        notifyListeners();
        return notificationModel!;
      } else if (response.data['status'] == 0) {
        waitingData = true;
        notificationModel = NotificationModel.fromJson(response.data);
        notifyListeners();
        return notificationModel!;
      }
      notifyListeners();
    } catch (e) {
      print("get notification error data : \n " + e.toString());
    }
  }
}
