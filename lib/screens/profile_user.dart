// ignore_for_file: use_key_in_widget_constructors, unnecessary_new, prefer_final_fields

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/user.dart';

class ProfileUser extends StatefulWidget {
  @override
  _ProfileUserState createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  List<FocusNode> _listFocus =
      List<FocusNode>.generate(2, (_) => new FocusNode());
  List<TextEditingController> _listEd = List<TextEditingController>.generate(2,
      (_) => new TextEditingController(text: _ == 0 ? user.name : user.email));
  Future updateUser() async {
    final String url = domain + 'edit-profile';
    try {
      Response response = await Dio().post(
        url,
        data: {
          "name": user.name,
          "email": user.email,
        },
        options: Options(headers: {
          'auth-token': auth,
        }),
      );
      if (response.data['status'] == 0) {
        String data = '';
        if (language == 'ar') {
          response.data['message'].forEach((e) {
            data += e + '\n';
          });
        } else {
          response.data['message'].forEach((e) {
            data += e + '\n';
          });
        }
        final snackBar = SnackBar(
          content: Text(data),
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
        _btnController.stop();
      }
      if (response.data['status'] == 1) {
        Map userData = response.data['user'];
        user = UserClass(
            id: userData['id'],
            name: userData['name'],
            phone: userData['phone'],
            email: userData['email']);
        setUserId(userData['id']);
        _btnController.success();
        await Future.delayed(const Duration(milliseconds: 2500));
        navPop(context);
      }
    } catch (e) {
      _btnController.error();
      await Future.delayed(const Duration(milliseconds: 1000));
      _btnController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: getDirection(),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              translate(context, 'profile', 'title'),
              style: TextStyle(
                  fontSize: w * 0.05,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            leading: const BackButton(
              color: Colors.black,
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Center(
            child: Padding(
              padding: EdgeInsets.only(top: h * 0.007, bottom: h * 0.005),
              child: SizedBox(
                width: w * 0.9,
                child: Column(
                  children: [
                    Column(
                      children: List.generate(_listFocus.length, (index) {
                        return Column(
                          children: [
                            SizedBox(
                              height: h * 0.03,
                            ),
                            TextFormField(
                              cursorColor: Colors.black,
                              inputFormatters: index != 1
                                  ? null
                                  : [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r"[0-9 a-z  @ .]")),
                                    ],
                              controller: _listEd[index],
                              focusNode: _listFocus[index],
                              textInputAction: index == 0
                                  ? TextInputAction.next
                                  : TextInputAction.done,
                              keyboardType: index == 1
                                  ? TextInputType.emailAddress
                                  : TextInputType.text,
                              onEditingComplete: () {
                                _listFocus[index].unfocus();
                                if (index < 1) {
                                  FocusScope.of(context)
                                      .requestFocus(_listFocus[index + 1]);
                                }
                              },
                              decoration: InputDecoration(
                                focusedBorder: form(),
                                enabledBorder: form(),
                                errorBorder: form(),
                                focusedErrorBorder: form(),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    RoundedLoadingButton(
                      child: Container(
                        height: h * 0.08,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: mainColor,
                        ),
                        child: Center(
                          child: Text(
                            translate(context, 'buttons', 'send'),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: w * 0.045,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      controller: _btnController,
                      successColor: mainColor,
                      color: mainColor,
                      disabledColor: mainColor,
                      onPressed: () async {
                        updateUser();
                      },
                    ),
                    SizedBox(
                      height: h * 0.08,
                    ),
                    SizedBox(
                      height: h * 0.1,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  InputBorder form() {
    return OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
        borderRadius: BorderRadius.circular(25));
  }
}
