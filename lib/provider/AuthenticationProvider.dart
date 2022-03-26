// ignore_for_file: avoid_print, unnecessary_string_interpolations, file_names
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/cart.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/fav.dart';
import 'package:davinshi_app/models/home_item.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/provider/address.dart';
import 'package:davinshi_app/provider/cart_provider.dart';
import 'package:davinshi_app/provider/home.dart';
import 'package:davinshi_app/screens/auth/constant.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

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
    if (response.statusCode == 200 && response.data['user'] != null) {
      print(response.data);
      Map userData = response.data['user'];
      user = UserClass(
          id: userData['id'],
          name: userData['name'],
          phone: userData['phone'],
          email: userData['email'] ?? "");
      Provider.of<AddressProvider>(context, listen: false).getAddress();
      setUserId(userData['id']);
      setLogin(true);
      setAuth(response.data['access_token']);
      dbHelper.deleteAll();
      Provider.of<CartProvider>(context, listen: false).clearAll();
      await prefs.setBool('login', true);
      await prefs.setInt('id', userData['id']);
      await prefs.setString('auth', response.data['access_token']);
      await prefs.setString('userName', userData['name']);
      userName = userData['name'];
      userEmail = userData['email'];
      await getHomeItems();
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
    try {
      var response = await http.post(
        Uri.parse(url),
        body: data,
        headers: {
          'Content-language': "$lang",
        },
      );

      var userData = json.decode(response.body);
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
        try {
          user = UserClass(
              id: userData['data']['user']['id'],
              name: userData['data']['user']['name'],
              phone: userData['data']['user']['phone'],
              email: userData['data']['user']['email'] ?? '');
          await prefs.setInt('id', userData['data']['user']['id']);
          await prefs.setString('auth', userData['data']['token'].toString());
          userName = userData['data']['user']['name'];
          userEmail = userData['data']['user']['email'];
          await getHomeItems();
          setUserId(userData['data']['user']['id']);
          dbHelper.deleteAll();
          fireSms(context, phone.text, controller);
        } catch (e) {
          print("register errrrrooooooooooooooooorrrr" + e.toString());
        }
      }
    } catch (error) {
      print(error.toString());
    }
  }
}
