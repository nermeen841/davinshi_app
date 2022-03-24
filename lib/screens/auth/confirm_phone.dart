// ignore_for_file: body_might_complete_normally_nullable

import 'package:davinshi_app/screens/auth/sign_upScreen.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/country.dart';
import 'package:davinshi_app/screens/auth/reset_pass.dart';

class ConfirmPhone extends StatefulWidget {
  const ConfirmPhone({Key? key}) : super(key: key);

  @override
  _ConfirmPhoneState createState() => _ConfirmPhoneState();
}

class _ConfirmPhoneState extends State<ConfirmPhone> {
  final _formKey = GlobalKey<FormState>();
  late int id;
  String? verificationId;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final TextEditingController _controller = TextEditingController();
  Future verifyPhone() async {
    String url = domain;
    try {
      url = url + 'check-phone';
      Response response = await Dio().post(url, data: {
        'phone': _controller.text,
      });
      if (response.data['status'] == 0) {
        final snackBar = SnackBar(
          content: Text(translate(context, 'snack_bar', 'phone')),
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
        Map userData = response.data['data'];
        id = userData['id'];
        fireSms(context, _controller.text, _btnController);
      }
    } catch (e) {
      _btnController.error();
      await Future.delayed(const Duration(milliseconds: 700));
      _btnController.stop();
    }
  }

  Future fireSms(context, String phone,
      RoundedLoadingButtonController _btnController) async {
    final TextEditingController sms = TextEditingController();
    try {
      String ph = countryCode + phone;
      Future<PhoneVerificationFailed?> verificationFailed(
          FirebaseAuthException authException) async {
        _btnController.error();
        await Future.delayed(const Duration(milliseconds: 1000));
        _btnController.stop();
        showBar(context, translate(context, 'fire_base', 'error1'));
      }

      Future<PhoneCodeAutoRetrievalTimeout?> autoTimeout(String varId) async {
        verificationId = varId;
        _btnController.stop();
      }

      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: ph,
          timeout: const Duration(seconds: 90),
          verificationCompleted: (AuthCredential credential) async {
            try {
              var result =
                  await FirebaseAuth.instance.signInWithCredential(credential);
              var ha = result.user;
              if (ha != null) {
                _btnController.stop();
                navPR(context, ResetPass(id: id));
              }
            } catch (e) {
              _btnController.error();
              await Future.delayed(const Duration(milliseconds: 1000));
              _btnController.stop();
              showBar(context, translate(context, 'fire_base', 'error2'));
            }
          },
          verificationFailed: verificationFailed,
          codeSent: (String verificationId, [int? forceResendingToken]) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) {
                  return AlertDialog(
                    title: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                      ),
                    ),
                    titlePadding: const EdgeInsets.only(left: 0, bottom: 0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    content: SizedBox(
                      height: h * 30 / 100,
                      child: Column(
                        children: <Widget>[
                          Align(
                            child: Text(
                              translate(context, 'sms', 'title'),
                              style: TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: w * 5 / 100),
                            ),
                            alignment: Alignment.center,
                          ),
                          SizedBox(
                            height: h * 2 / 100,
                          ),
                          Directionality(
                            textDirection: getDirection(),
                            child: TextField(
                              controller: sms,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: mainColor,
                                ),
                                border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10)),
                                hintText: translate(context, 'sms', 'hint'),
                                contentPadding: EdgeInsets.zero,
                                // prefixIcon: Icon(
                                //   Icons.mail,
                                //   color: mainColor,
                                // ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(
                            height: h * 1.5 / 100,
                          ),
                          InkWell(
                            child: Container(
                              width: w * 30 / 100,
                              height: h * 6 / 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.black),
                              child: Center(
                                child: Text(
                                  translate(context, 'buttons', 'send'),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: w * 4.5 / 100,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            onTap: () async {
                              if (sms.text != '') {
                                try {
                                  FocusScope.of(context).unfocus();
                                  AuthCredential credential =
                                      PhoneAuthProvider.credential(
                                          verificationId: verificationId,
                                          smsCode: sms.text);
                                  var result = await FirebaseAuth.instance
                                      .signInWithCredential(credential);
                                  var ha = result.user;
                                  if (ha != null) {
                                    sms.text = '';
                                    _btnController.stop();
                                    Navigator.pop(dialogContext);
                                    navPR(context, ResetPass(id: id));
                                  }
                                } catch (e) {
                                  customError(
                                      context,
                                      translate(
                                          context, 'fire_base', 'error2'));
                                  // Navigator.pop(dialogContext);
                                  _btnController.error();
                                  await Future.delayed(
                                      const Duration(milliseconds: 1000));
                                  _btnController.stop();
                                  // showBar(context, 'رمز التحقق غير صحيح', 'Verification code is wrong','العربية');
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    contentPadding: EdgeInsets.only(
                        top: 0,
                        right: w * 2 / 100,
                        left: w * 2 / 100,
                        bottom: 0),
                  );
                }).then((value) {
              _btnController.reset();
            });
          },
          codeAutoRetrievalTimeout: autoTimeout);
    } catch (e) {
      // showBar(context, e, e);
      _btnController.error();
      await Future.delayed(const Duration(milliseconds: 1000));
      _btnController.stop();
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                ),
                content: SizedBox(
                    height: h * 0.5,
                    width: h / 3.5,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [Text(e.toString())],
                      ),
                    )),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(w, h),
      child: Stack(
        children: [
          Stack(
            children: [
              Container(
                width: w,
                height: h,
                decoration: BoxDecoration(
                  color: mainColor,
                  image: const DecorationImage(
                      image: AssetImage("assets/images/143.png"),
                      fit: BoxFit.contain),
                ),
              ),
              Container(
                width: w,
                height: h,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/Rectangle.png"),
                        fit: BoxFit.fill)),
              ),
            ],
          ),
          Form(
            key: _formKey,
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Directionality(
                  textDirection: getDirection(),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Center(
                      child: ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: h * 0.01, horizontal: w * 0.02),
                            child: Align(
                              alignment: (language == 'en')
                                  ? Alignment.topLeft
                                  : Alignment.topRight,
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  width: w * 0.09,
                                  height: h * 0.04,
                                  color: Colors.white,
                                  child: Center(
                                    child: (language == 'en')
                                        ? const Icon(
                                            Icons.arrow_back,
                                            color: Colors.black,
                                          )
                                        : const Icon(
                                            Icons.arrow_forward,
                                            color: Colors.black,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: w * 0.05, right: w * 0.05, top: h * 0.3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: h * 0.07,
                                  width: w * 0.8,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(w * 0.07),
                                    color: Colors.white,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: w * 0.05,
                                        vertical: h * 0.005),
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(w * 0.07)),
                                    child: Center(
                                      child: Text(
                                        translate(
                                            context, 'reset_pass', 'title'),
                                        style: TextStyle(
                                            fontSize: w * 0.05,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: h * 0.04,
                                ),
                                Text(
                                  translate(
                                      context, 'reset_pass', 'sub_title1'),
                                  style: TextStyle(
                                      fontSize: w * 0.05,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  translate(
                                      context, 'reset_pass', 'sub_title2'),
                                  style: TextStyle(
                                      fontSize: w * 0.05,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: h * 0.05,
                                ),
                                TextFormField(
                                  controller: _controller,
                                  cursorColor: Colors.black,
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(translate(context,
                                                  'validation', 'field'))));
                                    }
                                    if (value.length != countryNumber) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(translate(context,
                                                  'validation', 'phone'))));
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      focusedBorder: form(),
                                      enabledBorder: form(),
                                      errorBorder: form(),
                                      focusedErrorBorder: form(),
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText:
                                          translate(context, 'inputs', 'phone'),
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      errorMaxLines: 1,
                                      errorStyle:
                                          TextStyle(fontSize: w * 0.03)),
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(
                                  height: h * 0.06,
                                ),
                                RoundedLoadingButton(
                                  child: Container(
                                    height: h * 0.08,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(w * 0.08),
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
                                  successColor: Colors.black,
                                  color: Colors.black,
                                  disabledColor: Colors.black,
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState!.validate()) {
                                      // fireSms(context, _controller.text, _btnController);
                                      verifyPhone();
                                    } else {
                                      _btnController.error();
                                      await Future.delayed(
                                          const Duration(milliseconds: 1000));
                                      _btnController.stop();
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: h * 0.05,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      translate(context, 'login', 'have_not'),
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
                                        translate(context, 'login', 'register'),
                                        style: TextStyle(
                                          color: mainColor,
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onTap: () {
                                        navP(context, SignupScreen());
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  InputBorder form() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: (Colors.black54), width: 1),
      borderRadius: BorderRadius.circular(w * 0.08),
    );
  }
}
