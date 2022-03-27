// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/social.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

class SocialIcons extends ChangeNotifier {
  static SocialModel? socialModel;
  Future getSocialIcons() async {
    try {
      var response = await http.get(Uri.parse(domain + "icons"));
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        socialModel = SocialModel.fromJson(data);

        return socialModel;
      }
      notifyListeners();
    } catch (e) {
      print("errrrrrrror :" + e.toString());
    }
  }
}
