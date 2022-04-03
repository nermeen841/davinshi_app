// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables
import 'package:davinshi_app/lang/change_language.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:davinshi_app/provider/address.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class UserClass {
  int id;
  String name;
  String phone;
  String email;
  String? userName;
  String? image;
  int? gender;
  UserClass(
      {required this.name,
      required this.phone,
      required this.userName,
      required this.gender,
      required this.image,
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
String? userPhone;
var gender;
String? familyName;
String? userImage;
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
        email: userData['email'],
        userName: userData['surname'],
        image: userData['img'],
        gender: userData['gender'],
      );
    }
  } catch (e) {
    print(e);
  }
}

List<String> month = [
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "10",
  "11",
  "12",
];
List<String> day = [
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "10",
  "11",
  "12",
  "13",
  "14",
  "15",
  "16",
  "17",
  "18",
  "19",
  "20",
  "21",
  "22",
  "23",
  "24",
  "25",
  "26",
  "27",
  "28",
  "29",
  "30",
];

List<String> yaer = [
  "1980",
  "1981",
  "1982",
  "1983",
  "1984",
  "1985",
  "1986",
  "1987",
  "1988",
  "1989",
  "1990",
  "1991",
  "1992",
  "1993",
  "1994",
  "1995",
  "1996",
  "1997",
  "1998",
  "1999",
  "2000",
];
//////////////////////////////////////////////////////////////////////////////////////

Future updateProfileImage({
  required context,
  required String image,
}) async {
  final String url = domain + "update-image";

  FormData formData = FormData.fromMap({
    "image": await MultipartFile.fromFile(
      image,
    ),
  });
  try {
    dio.Response response = await dio.Dio().post(
      url,
      data: formData,
      options: dio.Options(
          headers: {"auth-token": auth, "Content-Language": language}),
    );
    print(response.data);
    if (response.data['status'] == 1) {
      final snackBar = SnackBar(
        content: Text(translateString("Profile Image updated successfully",
            "تم تحديث الصورة الشخصية بنجاح")),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content: Text(translateString("Failed to update profile image",
            "يرجي المحاولة مرة اخري في وقت لاحق")),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  } catch (e) {
    error(context);

    print("errrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr:   " + e.toString());
  }
}
