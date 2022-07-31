// ignore_for_file: avoid_print, unnecessary_string_interpolations, file_names
import 'dart:convert';

import 'package:davinshi_app/models/home_item.dart';
import 'package:davinshi_app/provider/notification.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/cart.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/fav.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/provider/address.dart';
import 'package:davinshi_app/provider/cart_provider.dart';
import 'package:davinshi_app/provider/home.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../screens/auth/country.dart';
import '../screens/home_folder/home_page.dart';

class AuthenticationProvider {
  static Future<bool> userLogin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    final String url = domain + 'login';
    Response response = await Dio().post(
      url,
      options: Options(headers: {
        'Content-language': prefs.getString('language_code').toString().isEmpty
            ? 'en'
            : prefs.getString('language_code').toString()
      }),
      data: {
        'email': email.toString(),
        'password': password.toString(),
      },
    );
    print(response.data);
    if (response.statusCode == 200 && response.data['user'] != null) {
      print(response.data);
      notificationToken();
      Map userData = response.data['user'];
      user = UserClass(
        id: userData['id'],
        name: userData['name'],
        phone: userData['phone'],
        email: userData['email'] ?? "",
        userName: userData['surname'],
        image: userData['img'],
        gender: userData['gender'],
        birthday: userData['birth_day'],
      );
      Provider.of<AddressProvider>(context, listen: false).getAddress();
      setUserId(userData['id']);
      setLogin(true);
      setAuth(response.data['access_token']);
      dbHelper.deleteAll();
      Provider.of<CartProvider>(context, listen: false).clearAll();
      await HomeProvider().getHomeItems();
      await prefs.setBool('login', true);
      await prefs.setInt('id', userData['id']);
      await prefs.setString('auth', response.data['access_token']);
      await prefs.setString('userName', userData['name']);
      userName = userData['name'];
      userEmail = userData['email'];
      userPhone = userData['phone'];
      gender = userData['gender'];
      familyName = userData['surname'];

      // Provider.of<HomeProvider>(context, listen: false).getHomeItems();
      await dbHelper.deleteAll();
      await Provider.of<CartProvider>(context, listen: false).setItems();
      getLikes();
      Provider.of<BottomProvider>(context, listen: false).setIndex(0);
      cartId = null;
      return true;
    } else {
      if (response.statusCode == 200 && response.data['status'] == 0) {
        final snackBar = SnackBar(
          content: Text(response.data['message']),
          action: SnackBarAction(
            label: translate(context, 'snack_bar', 'undo'),
            disabledTextColor: Colors.yellow,
            textColor: Colors.yellow,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      return false;
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////////
  static Future register(
      {required BuildContext context,
      required TextEditingController name,
      required TextEditingController email,
      required TextEditingController phone,
      required TextEditingController password,
      required TextEditingController confirmPassword,
      required RoundedLoadingButtonController controller}) async {
    final String url = domain + 'register';
    final String lang = prefs.getString('language_code') ?? 'en';

    Map<String, dynamic> data = {
      'name': name.text,
      'email': email.text,
      'password': password.text,
      'password_confirmation': confirmPassword.text,
      'phone': phone.text,
    };
    print(data);
    try {
      var response = await http.post(
        Uri.parse(url),
        body: data,
        headers: {
          'Content-language': "$lang",
        },
      );

      var userData = json.decode(response.body);
      print(userData);
      String datamess = '';
      if (userData['status'] == 0) {
        controller.error();
        await Future.delayed(const Duration(seconds: 1));
        controller.stop();
        userData['message'].forEach((e) {
          datamess += e + '\n';
        });

        final snackBar = SnackBar(
          content: Text(datamess),
          action: SnackBarAction(
            label: translate(context, 'snack_bar', 'undo'),
            disabledTextColor: Colors.yellow,
            textColor: Colors.yellow,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      if (response.statusCode == 200) {
        notificationToken();
        try {
          user = UserClass(
            id: userData['data']['user']['id'],
            name: userData['data']['user']['name'],
            phone: userData['data']['user']['phone'],
            email: userData['data']['user']['email'] ?? '',
            userName: userData['data']['user']['surname'],
            image: userData['data']['user']['img'],
            gender: userData['data']['user']['gender'],
            birthday: userData['data']['user']['birth_day'],
          );
          userName = userData['data']['user']['name'];
          userEmail = userData['data']['user']['email'];
          userPhone = userData['data']['user']['phone'];
          gender = userData['data']['user']['gender'];
          familyName = userData['data']['user']['surname'];
          await prefs.setInt('id', userData['data']['user']['id']);
          await prefs.setString('auth', userData['data']['token'].toString());
          setAuth(userData['data']['token']);
          await HomeProvider().getHomeItems();
          setUserId(userData['data']['user']['id']);
          dbHelper.deleteAll();
          await prefs.setBool('login', true);
          setLogin(true);
          Provider.of<CartProvider>(context, listen: false).clearAll();
          cartId = null;
          Provider.of<BottomProvider>(context, listen: false).setIndex(0);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              (route) => false);
        } catch (e) {
          print("register errrrrooooooooooooooooorrrr" + e.toString());
        }
      }
    } catch (error) {
      print(error.toString());
    }
  }

  /////////////////////////////////////////////////////////////////////////
  bool isDeleted = false;
  Future<bool> deleteUserAccount({String? appversion}) async {
    final String url = domain + "active-remove-account";
    try {
      Response response = await Dio().post(
        url,
        data: {"app_version": appversion},
        options: Options(
          headers: {
            "auth-token": prefs.getString('auth') ?? "",
          },
        ),
      );
      print(response.data);
      if (response.data['status'] == 1) {
        isDeleted = response.data['message'];
        return isDeleted;
      }
    } catch (e) {
      print(e.toString());
    }
    return isDeleted;
  }

///////////////////////////////////////////////////////

  String? messageSuccess;
  Future deleteAccount(
      {required String password,
      required context,
      required RoundedLoadingButtonController controller}) async {
    final String url = domain + "remove-account";
    try {
      Map<String, dynamic> body = {"password": password};
      var response = await http.post(
        Uri.parse(url),
        body: body,
        headers: {
          "auth-token": prefs.getString('auth') ?? "",
        },
      );
      var data = jsonDecode(response.body);
      if (data['status'] == 1) {
        controller.success();
        await Future.delayed(const Duration(milliseconds: 1000));
        controller.stop();
        print(data);

        prefs.setBool('login', false);
        userName = null;
        await prefs.setString('userName', 'Guest');
        prefs.setInt('id', 0);
        prefs.setString('auth', '');
        setUserId(0);
        setAuth('');
        setLogin(false);
        await prefs.setBool('login', false);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Country(1)),
            (route) => false);

        return messageSuccess;
      } else {
        controller.error();
        await Future.delayed(const Duration(milliseconds: 1000));
        controller.stop();
      }
    } catch (e) {
      print(e.toString());
      controller.error();
      await Future.delayed(const Duration(milliseconds: 1000));
      controller.stop();
    }
    return messageSuccess;
  }
}
