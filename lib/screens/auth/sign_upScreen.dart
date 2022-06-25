// ignore_for_file: use_key_in_widget_constructors, file_names

import 'dart:async';

import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/provider/AuthenticationProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'login.dart';

final _formKey = GlobalKey<FormState>();
final RoundedLoadingButtonController _btnController =
    RoundedLoadingButtonController();

late Timer timer;
int counter = 60;
bool dialogSms = false, makeError = false, finishSms = true, checkRe = false;
// ignore: unused_field
bool visibility1 = true, visibility2 = true, check = true;
FocusNode focusNode1 = FocusNode();
FocusNode focusNode2 = FocusNode();
FocusNode focusNode3 = FocusNode();
FocusNode focusNode4 = FocusNode();
FocusNode focusNode5 = FocusNode();

TextEditingController name = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController phone = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController confirmPassword = TextEditingController();

String? verificationId;

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final List<String> hint = (language == 'en')
      ? [
          'Name',
          'E-mail ( optional )',
          'phone number',
          'password',
          'confirm password'
        ]
      : [
          'الاسم بالكامل',
          ' ( اختياري ) البريد الاكتروني',
          'رقم الهاتف',
          'كلمة المرور',
          'تاكيد كلمة المرور'
        ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: mainColor,
            body: SizedBox(
              child: SingleChildScrollView(
                primary: true,
                child: Column(
                  children: [
                    SizedBox(
                      height: h * 0.07,
                    ),
                    Padding(
                      padding: (prefs.getString('language_code') == 'en')
                          ? EdgeInsets.only(
                              left: w * 0.3,
                            )
                          : EdgeInsets.only(right: w * 0.3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(
                            child: Text(
                              translate(context, 'login', 'register'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: w * 0.06,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          InkWell(
                            onTap: () => navPop(context),
                            child: (prefs.getString('language_code') == 'en')
                                ? const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                    size: 30,
                                  )
                                : const Icon(
                                    Icons.keyboard_arrow_left,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Container(
                      width: w,
                      height: h,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: h * 0.02,
                            ),
                            Text(
                              hint[0],
                              style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            nametextFormField(),
                            Text(
                              hint[1],
                              style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            emailtextFormField(),
                            Text(
                              hint[2],
                              style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            phoneFormField(),
                            Text(
                              hint[3],
                              style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            passwordTextFormField(),
                            Text(
                              hint[4],
                              style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            confirmpasswordTextFormField(),
                            RoundedLoadingButton(
                              controller: _btnController,
                              child: Center(
                                  child: Text(
                                translate(context, 'buttons', 'register'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: w * 0.05,
                                    fontWeight: FontWeight.bold),
                              )),
                              successColor: Colors.white,
                              color: const Color(0xff302E2E),
                              borderRadius: w * 0.07,
                              height: h * 0.06,
                              disabledColor: Colors.black,
                              errorColor: Colors.red,
                              valueColor: Colors.white,
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (FirebaseAuth.instance.currentUser != null) {
                                  FirebaseAuth.instance.signOut();
                                }
                                if (finishSms) {
                                  if (_formKey.currentState!.validate()) {
                                    await AuthenticationProvider.register(
                                        context: context,
                                        controller: _btnController,
                                        confirmPassword: confirmPassword,
                                        email: email,
                                        name: name,
                                        password: password,
                                        phone: phone);
                                  } else {
                                    _btnController.error();
                                    await Future.delayed(
                                        const Duration(seconds: 2));
                                    _btnController.stop();
                                  }
                                } else {
                                  final snackBar = SnackBar(
                                    content:
                                        Text(translate(context, 'sms', 'wait')),
                                    action: SnackBarAction(
                                      label: translate(
                                          context, 'snack_bar', 'undo'),
                                      disabledTextColor: Colors.yellow,
                                      textColor: Colors.yellow,
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                      },
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  _btnController.stop();
                                }
                              },
                            ),
                            SizedBox(
                              height: h * 0.03,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  translate(context, 'login', 'have_account'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: w * 0.035,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: w * 0.01,
                                ),
                                InkWell(
                                  child: Text(
                                    translate(context, 'buttons', 'login'),
                                    style: TextStyle(
                                      color: mainColor,
                                      fontSize: w * 0.035,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Login()));
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              width: w * 0.04,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget nametextFormField() {
    return Padding(
      padding: EdgeInsets.only(bottom: h * 0.04),
      child: Container(
        padding: EdgeInsets.only(left: w * 0.01, right: w * 0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black38),
            borderRadius: BorderRadius.circular(w * 0.08)),
        child: TextFormField(
          controller: name,
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.start,
          cursorColor: Colors.black,
          obscureText: false,
          textInputAction: TextInputAction.next,
          focusNode: focusNode1,
          onEditingComplete: () {
            focusNode1.unfocus();

            FocusScope.of(context).requestFocus(focusNode2);
          },
          decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            errorStyle: const TextStyle(color: Colors.red),
            hintText: hint[0],
            hintStyle: const TextStyle(color: Colors.black45),
            labelStyle: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget emailtextFormField() {
    return Padding(
      padding: EdgeInsets.only(bottom: h * 0.04),
      child: Container(
        padding: EdgeInsets.only(left: w * 0.01, right: w * 0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black38),
            borderRadius: BorderRadius.circular(w * 0.08)),
        child: TextFormField(
          controller: email,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.start,
          cursorColor: Colors.black,
          obscureText: false,
          textInputAction: TextInputAction.next,
          focusNode: focusNode2,
          onEditingComplete: () {
            focusNode2.unfocus();
            FocusScope.of(context).requestFocus(focusNode3);
          },
          validator: (value) {
            if (value!.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(translate(context, 'validation', 'field'))));
            }
            if (!value.contains("@") || !value.contains(".com")) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(translateString('Email address is invalid ',
                      'البريد الإلكتروني غير صحيح'))));
            }
            return null;
          },
          decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            errorStyle: const TextStyle(color: Colors.red),
            hintText: hint[1],
            hintStyle: const TextStyle(color: Colors.black45),
            labelStyle: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget phoneFormField() {
    return Padding(
      padding: EdgeInsets.only(bottom: h * 0.04),
      child: Container(
        padding: EdgeInsets.only(left: w * 0.01, right: w * 0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black38),
            borderRadius: BorderRadius.circular(w * 0.08)),
        child: TextFormField(
          controller: phone,
          keyboardType: TextInputType.phone,
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.start,
          cursorColor: Colors.black,
          obscureText: false,
          textInputAction: TextInputAction.next,
          focusNode: focusNode3,
          onEditingComplete: () {
            focusNode3.unfocus();

            FocusScope.of(context).requestFocus(focusNode4);
          },
          decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            errorStyle: const TextStyle(color: Colors.red),
            hintText: hint[2],
            hintStyle: const TextStyle(color: Colors.black45),
            labelStyle: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  passwordTextFormField() {
    return Padding(
      padding: EdgeInsets.only(bottom: h * 0.04),
      child: Container(
        padding: EdgeInsets.only(left: w * 0.01, right: w * 0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black38),
            borderRadius: BorderRadius.circular(w * 0.08)),
        child: TextFormField(
          controller: password,
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.start,
          cursorColor: Colors.black,
          obscureText: visibility1,
          textInputAction: TextInputAction.next,
          focusNode: focusNode4,
          onEditingComplete: () {
            focusNode4.unfocus();

            FocusScope.of(context).requestFocus(focusNode5);
          },
          decoration: InputDecoration(
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  visibility1 = false;
                });
              },
              child: (visibility1 == true)
                  ? const Icon(
                      Icons.visibility_off_outlined,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.visibility_outlined,
                      color: Colors.black,
                    ),
            ),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            errorStyle: const TextStyle(color: Colors.red),
            hintText: hint[3],
            hintStyle: const TextStyle(color: Colors.black45),
            labelStyle: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget confirmpasswordTextFormField() {
    return Padding(
      padding: EdgeInsets.only(bottom: h * 0.04),
      child: Container(
        padding: EdgeInsets.only(left: w * 0.01, right: w * 0.02),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black38),
            borderRadius: BorderRadius.circular(w * 0.08)),
        child: TextFormField(
          controller: confirmPassword,
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.start,
          cursorColor: Colors.black,
          obscureText: visibility2,
          textInputAction: TextInputAction.done,
          focusNode: focusNode5,
          onEditingComplete: () {
            focusNode5.unfocus();
          },
          // validator: (value) {
          //   if (value!.isEmpty) {
          //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //         content: Text(translate(context, 'validation', 'field'))));
          //     _btnController.error();
          //     Future.delayed(const Duration(seconds: 1));
          //     _btnController.stop();
          //   }

          //   return null;
          // },
          decoration: InputDecoration(
            suffixIcon: InkWell(
              onTap: () {
                setState(() {
                  visibility2 = false;
                });
              },
              child: (visibility2 == true)
                  ? const Icon(
                      Icons.visibility_off_outlined,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.visibility_outlined,
                      color: Colors.black,
                    ),
            ),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            errorStyle: const TextStyle(color: Colors.red),
            hintText: hint[3],
            hintStyle: const TextStyle(color: Colors.black45),
            labelStyle: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}

InputBorder form() {
  return OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.black38, width: 1),
    borderRadius: BorderRadius.circular(w * 0.8),
  );
}
