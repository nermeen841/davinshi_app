// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:davinshi_app/provider/address.dart';

import 'constants.dart';

class UserClass {
  int id;
  String name;
  String phone;
  String email;
  UserClass(
      {required this.name,
      required this.phone,
      required this.id,
      required this.email});
}

late UserClass user;
int userId = 0;
late String auth;
bool login = false;
void setLogin(bool val) {
  login = val;
}

String? userName;
String? userEmail;
AddressClass? addressGuest;
void setUserId(int _id) {
  userId = _id;
}

void setAuth(String token) {
  auth = token;
}

Future getUserId() async {
  final String url = domain + 'get_user_id/${userId.toString()}';
  try {
    Response response = await Dio().get(url);
    if (response.data['status'] == 1) {
      Map userData = response.data['user'];
      user = UserClass(
          id: userData['id'],
          name: userData['name'],
          phone: userData['phone'],
          email: userData['email']);
    }
  } catch (e) {
    print(e);
  }
}
