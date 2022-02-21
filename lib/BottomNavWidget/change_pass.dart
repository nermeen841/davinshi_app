// ignore_for_file: use_key_in_widget_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/user.dart';

class ChangePass extends StatefulWidget {
  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _oldPass = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();
  String? oldPass, newPass, confirmPass;
  bool _visibility1 = true;
  bool _visibility2 = true;
  bool _visibility3 = true;
  Future updatePass() async {
    final String url = domain + 'change-password';
    try {
      Response response = await Dio().post(
        url,
        data: {
          "old_password": oldPass,
          "new_password": newPass,
        },
        options: Options(headers: {"auth-token": auth}),
      );
      if (response.data['status'] == 0) {
        String data = '';
        if (response.data['message'] is String) {
          data = response.data['message'];
        } else {
          if (language == 'en') {
            response.data['message'].forEach((e) {
              data += e + '\n';
            });
          } else {
            response.data['message'].forEach((e) {
              data += e + '\n';
            });
          }
        }
        _btnController.stop();
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
      }
      if (response.data['status'] == 1 && response.statusCode == 200) {
        _btnController.success();
        await Future.delayed(const Duration(milliseconds: 2500));
        navPop(context);
      } else {
        _btnController.error();
        await Future.delayed(const Duration(milliseconds: 1000));
        _btnController.stop();
      }
    } catch (e) {
      _btnController.error();
      await Future.delayed(const Duration(milliseconds: 1000));
      _btnController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: _formKey,
        child: Directionality(
          textDirection: getDirection(),
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(
                  translate(context, 'change_pass', 'title'),
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
                    height: h,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: h * 0.03,
                          ),
                          TextFormField(
                            cursorColor: Colors.black,
                            obscureText: _visibility1,
                            textInputAction: TextInputAction.next,
                            focusNode: _oldPass,
                            onEditingComplete: () {
                              _oldPass.unfocus();
                              FocusScope.of(context).requestFocus(_passFocus);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return translate(
                                    context, 'validation', 'old_pass');
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              focusedBorder: form(),
                              enabledBorder: form(),
                              errorBorder: form(),
                              fillColor: Colors.grey[200],
                              filled: true,
                              focusedErrorBorder: form(),
                              hintText:
                                  translate(context, 'inputs', 'old_pass'),
                              hintStyle: const TextStyle(color: Colors.grey),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              errorMaxLines: 1,
                              errorStyle: TextStyle(fontSize: w * 0.03),
                              suffixIcon: IconButton(
                                icon: !_visibility1
                                    ? Icon(
                                        Icons.visibility,
                                        color: mainColor,
                                      )
                                    : Icon(
                                        Icons.visibility_off,
                                        color: mainColor,
                                      ),
                                onPressed: () {
                                  setState(() {
                                    _visibility1 = !_visibility1;
                                  });
                                },
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (val) {
                              setState(() {
                                oldPass = val;
                              });
                            },
                          ),
                          SizedBox(
                            height: h * 0.03,
                          ),
                          TextFormField(
                            cursorColor: Colors.black,
                            obscureText: _visibility2,
                            textInputAction: TextInputAction.next,
                            focusNode: _passFocus,
                            onEditingComplete: () {
                              _passFocus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_confirmFocus);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return translate(
                                    context, 'validation', 'new_pass');
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              focusedBorder: form(),
                              enabledBorder: form(),
                              errorBorder: form(),
                              fillColor: Colors.grey[200],
                              filled: true,
                              focusedErrorBorder: form(),
                              hintText:
                                  translate(context, 'inputs', 'new_pass'),
                              hintStyle: const TextStyle(color: Colors.grey),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              errorMaxLines: 1,
                              errorStyle: TextStyle(fontSize: w * 0.03),
                              suffixIcon: IconButton(
                                icon: !_visibility2
                                    ? Icon(
                                        Icons.visibility,
                                        color: mainColor,
                                      )
                                    : Icon(
                                        Icons.visibility_off,
                                        color: mainColor,
                                      ),
                                onPressed: () {
                                  setState(() {
                                    _visibility2 = !_visibility2;
                                  });
                                },
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (val) {
                              setState(() {
                                newPass = val;
                              });
                            },
                          ),
                          SizedBox(
                            height: h * 0.03,
                          ),
                          TextFormField(
                            cursorColor: Colors.black,
                            obscureText: _visibility3,
                            textInputAction: TextInputAction.done,
                            focusNode: _confirmFocus,
                            onEditingComplete: () {
                              _confirmFocus.unfocus();
                            },
                            validator: (value) {
                              if (value != newPass) {
                                return translate(
                                    context, 'validation', 'confirm_pass');
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              focusedBorder: form(),
                              enabledBorder: form(),
                              errorBorder: form(),
                              focusedErrorBorder: form(),
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText:
                                  translate(context, 'inputs', 'confirm_pass'),
                              hintStyle: const TextStyle(color: Colors.grey),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              errorMaxLines: 1,
                              errorStyle: TextStyle(fontSize: w * 0.03),
                              suffixIcon: IconButton(
                                icon: !_visibility3
                                    ? Icon(
                                        Icons.visibility,
                                        color: mainColor,
                                      )
                                    : Icon(
                                        Icons.visibility_off,
                                        color: mainColor,
                                      ),
                                onPressed: () {
                                  setState(() {
                                    _visibility3 = !_visibility3;
                                  });
                                },
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (val) {
                              if (val == newPass) {
                                setState(() {
                                  confirmPass = val;
                                });
                              }
                            },
                          ),
                          SizedBox(
                            height: h * 0.1,
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
                                  translate(context, 'buttons', 'save'),
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
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (_formKey.currentState!.validate()) {
                                updatePass();
                              } else {
                                _btnController.error();
                                await Future.delayed(
                                    const Duration(milliseconds: 1000));
                                _btnController.stop();
                              }
                            },
                          ),
                          SizedBox(
                            height: h * 0.1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }

  InputBorder form() {
    return OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
        borderRadius: BorderRadius.circular(25));
  }
}
