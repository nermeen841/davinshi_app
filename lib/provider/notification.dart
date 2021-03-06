// ignore_for_file: avoid_print, unused_local_variable

import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/notification_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

void notificationToken() async {
  final String url = domain + "notifications/save_token";
  print(prefs.getString('token').toString());
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

      if (response.data['status'] == 1) {
        for (var item in response.data['data']) {
          if (item['is_reads'] == true) {
            isRead[item['id']] = true;
          } else {
            isRead[item['id']] = false;
          }
        }
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

  int notificationCount = 0;
  Future<int> getNotificationcount() async {
    final String url = domain + "notifications/count";
    try {
      Response response = await Dio().post(
        url,
        data: {"fcm_token": prefs.getString('token').toString()},
        options: Options(
          headers: {
            "auth-token": prefs.getString('auth') ?? "",
          },
        ),
      );

      if (response.data['status'] == 1) {
        notificationCount = response.data['data'];
        notifyListeners();

        return notificationCount;
      } else if (response.data['status'] == 0) {
        notifyListeners();
        return notificationCount;
      }
      notifyListeners();
    } catch (e) {
      print("get notification count error data : \n " + e.toString());
    }

    return notificationCount;
  }

  Map<int, bool> isRead = {};
  Future changeNotificationStatuse({required int notificationId}) async {
    final String url = domain + "notifications/show";
    try {
      Response response = await Dio().post(
        url,
        data: {"notification_id": notificationId},
        options: Options(
          headers: {
            "auth-token": prefs.getString('auth') ?? "",
          },
        ),
      );

      if (response.data['status'] == 1) {
        isRead[notificationId] = true;
        notifyListeners();

        return isRead[notificationId]!;
      } else if (response.data['status'] == 0) {
        isRead[notificationId] = false;
        notifyListeners();
        return isRead[notificationId]!;
      }
      notifyListeners();
    } catch (e) {
      print("get notification count error data : \n " + e.toString());
    }

    return isRead[notificationId]!;
  }
}
