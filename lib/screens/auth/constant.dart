// ignore_for_file: avoid_print, body_might_complete_normally_nullable

import 'dart:async';
import 'package:davinshi_app/screens/auth/sign_upScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/cart.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/country.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/provider/cart_provider.dart';
import 'package:davinshi_app/provider/home.dart';
import 'package:davinshi_app/screens/home_folder/home_page.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

Future fireSms(context, String phone,
    RoundedLoadingButtonController _btnController) async {
  counter = 60;
  final TextEditingController sms = TextEditingController();
  try {
    String ph = countryCode + phone;
    Future<PhoneVerificationFailed?> verificationFailed(
        FirebaseAuthException authException) async {
      checkRe = false;
      await Future.delayed(const Duration(milliseconds: 1000));
      _btnController.stop();
      showBar(context, translate(context, 'fire_base', 'error1'));
    }

    Future<PhoneCodeAutoRetrievalTimeout?> autoTimeout(String varId) async {
      finishSms = true;
      checkRe = false;
      verificationId = varId;
      _btnController.stop();
    }

    print("phone: $ph");
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: ph,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          try {
            var result =
                await FirebaseAuth.instance.signInWithCredential(credential);
            var ha = result.user;
            if (ha != null) {
              await prefs.setBool('login', true);
              setLogin(true);
              Navigator.pop(context, 'ok');
              timer.cancel();
              Provider.of<CartProvider>(context, listen: false).clearAll();
              cartId = null;
              Provider.of<BottomProvider>(context, listen: false).setIndex(0);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (route) => false);
              print("successsssssssssssssssssssssssssssssssssssssssss");
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
          checkRe = false;
          finishSms = false;
          if (dialogSms) {
            dialogSms = false;
            navPop(context);
          }
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) {
                final _formKey2 = GlobalKey<FormState>();
                _btnController.stop();
                return Form(
                  key: _formKey2,
                  child: AlertDialog(
                    title: Align(
                      alignment:
                          isLeft() ? Alignment.topLeft : Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          timer.cancel();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    titlePadding:
                        const EdgeInsets.only(left: 0, bottom: 0, right: 0),
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
                            child: TextFormField(
                              controller: sms,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10)),
                                hintText: translate(context, 'sms', 'hint'),
                                contentPadding: EdgeInsets.zero,
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: mainColor,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return translate(
                                      context, 'validation', 'field');
                                }
                                if (makeError) {
                                  return translate(context, 'sms', 'in');
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: h * 1.5 / 100,
                          ),
                          StatefulBuilder(
                            builder: (context2, setState3) {
                              if (counter == 60) {
                                timer = Timer.periodic(
                                    const Duration(seconds: 1), (e) {
                                  if (e.isActive) {
                                    setState3(() {
                                      counter--;
                                    });
                                  }
                                  if (counter == 0) {
                                    e.cancel();
                                  }
                                });
                              }
                              return SizedBox(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    InkWell(
                                      child: RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: translate(
                                                  context, 'sms', 're'),
                                              style: TextStyle(
                                                  color: mainColor,
                                                  fontSize: w * 0.035)),
                                          TextSpan(
                                              text: counter.toString(),
                                              style: const TextStyle(
                                                  color: Colors.black)),
                                        ]),
                                      ),
                                      onTap: () {
                                        if (counter == 0) {
                                          if (!checkRe) {
                                            checkRe = true;
                                            timer.cancel();
                                            dialogSms = true;
                                            fireSms(
                                                context, phone, _btnController);
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
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
                                  border: Border.all(color: Colors.black)),
                              child: Center(
                                child: Text(
                                  translate(context, 'buttons', 'send'),
                                  style: TextStyle(
                                      color: mainColor,
                                      fontSize: w * 4.5 / 100,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            onTap: () async {
                              if (_formKey2.currentState!.validate()) {
                                try {
                                  FocusScope.of(context).unfocus();
                                  AuthCredential credential =
                                      PhoneAuthProvider.credential(
                                          verificationId: verificationId,
                                          smsCode: sms.text);
                                  final User? user = (await FirebaseAuth
                                          .instance
                                          .signInWithCredential(credential))
                                      .user;
                                  if (user != null || user?.uid != '') {
                                    await prefs.setBool('login', true);
                                    setLogin(true);
                                    Navigator.pop(context, 'ok');
                                    timer.cancel();
                                    Provider.of<CartProvider>(context,
                                            listen: false)
                                        .clearAll();
                                    cartId = null;
                                    Provider.of<BottomProvider>(context,
                                            listen: false)
                                        .setIndex(0);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Home()),
                                        (route) => false);
                                    print("user access code successsssssss");
                                  }
                                } catch (e) {
                                  print("firebase errrrrroooor : " +
                                      e.toString());
                                  makeError = true;
                                  if (_formKey2.currentState!.validate()) {
                                    print('hamza2');
                                  }
                                  makeError = false;
                                  print('hamza3');
                                }
                              } else {
                                print('hamza4');
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
                  ),
                );
              }).then((value) {
            if (value == null) {
              _btnController.reset();
            }
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
