// ignore_for_file: empty_catches, file_names

import 'package:dio/dio.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/info.dart';

class AboutProvider {
  static Future<bool> getInfo(title) async {
    final String url = domain + 'infos?type=$title';
    try {
      Response response = await Dio().get(
        url,
        options: Options(headers: {
          'Content-language':
              prefs.getString('language_code').toString().isEmpty
                  ? 'en'
                  : prefs.getString('language_code').toString()
        }),
      );
      if (response.statusCode == 200 && response.data['status'] == 1) {
        setInfo(response.data['data']);
        return true;
      }
      if (response.statusCode == 200 && response.data['status'] == 0) {
        setInfo([]);
        return true;
      }
    } catch (e) {}
    return false;
  }
}
