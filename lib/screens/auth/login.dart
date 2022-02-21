// ignore_for_file: avoid_print, unnecessary_string_interpolations

import 'package:davinshi_app/screens/auth/sign_upScreen.dart';
import 'package:flutter/material.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/cart.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/home_item.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/provider/AuthenticationProvider.dart';
import 'package:davinshi_app/provider/cart_provider.dart';
import 'package:davinshi_app/provider/home.dart';
import 'package:davinshi_app/screens/home_folder/home_page.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'confirm_phone.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  bool select = true;
  TextEditingController editingController1 = TextEditingController();
  TextEditingController editingController2 = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    print([3, Navigator.canPop(context)]);
    return PreferredSize(
        preferredSize: Size(w, h),
        child: Stack(children: [
          Container(
            width: w,
            height: h,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/icons/Mask Group 30.png"),
                    fit: BoxFit.fill)),
          ),
          Form(
              key: _formKey,
              child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Container(
                          width: w,
                          height: h,
                          padding: EdgeInsets.only(top: h * 0.07),
                          child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Center(
                                      child: Image.asset(
                                    "assets/KONOZ-ICON.png",
                                    // "assets/icons/ابيض.png",
                                    width: w * 0.6,
                                    height: h * 0.2,
                                    fit: BoxFit.contain,
                                  )),
                                  SizedBox(
                                    height: h * 0.05,
                                  ),
                                  Container(
                                    height: h * 0.07,
                                    width: w * 0.65,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: Colors.white),
                                      color: Colors.black38,
                                    ),
                                    child: Center(
                                      child: Text(
                                        translate(context, 'buttons', 'login'),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w * 0.06,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: h * 0.05,
                                  ),
                                  SizedBox(
                                    width: w,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: w * 0.05),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: h * 0.06,
                                          ),
                                          Text(
                                            translate(
                                                context, 'buttons', 'login'),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: w * 0.05),
                                          ),
                                          SizedBox(
                                            height: h * 0.01,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: w * 0.03,
                                                right: w * 0.03),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      spreadRadius: 3,
                                                      offset:
                                                          const Offset(0, 3),
                                                      blurRadius: 3)
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        w * 0.08)),
                                            child: TextFormField(
                                              controller: editingController1,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              textAlign: TextAlign.start,
                                              cursorColor: Colors.black,
                                              textInputAction:
                                                  TextInputAction.next,
                                              focusNode: focusNode1,
                                              onEditingComplete: () {
                                                focusNode1.unfocus();
                                                FocusScope.of(context)
                                                    .requestFocus(focusNode2);
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              translate(
                                                                  context,
                                                                  'validation',
                                                                  'field'))));
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                focusedErrorBorder:
                                                    InputBorder.none,
                                                errorStyle: const TextStyle(
                                                    color: Colors.white),
                                                hintText: translate(
                                                    context, 'inputs', 'phone'),
                                                hintStyle: const TextStyle(
                                                    color: Colors.black45),
                                                labelStyle: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),

                                          SizedBox(
                                            height: h * 0.06,
                                          ),
                                          Text(
                                            translate(
                                                context, 'inputs', 'pass'),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: w * 0.05),
                                          ),
                                          SizedBox(
                                            height: h * 0.01,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: w * 0.03,
                                                right: w * 0.03),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      spreadRadius: 3,
                                                      offset:
                                                          const Offset(0, 3),
                                                      blurRadius: 3)
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        w * 0.08)),
                                            child: TextFormField(
                                              controller: editingController2,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                              textAlign: TextAlign.start,
                                              obscureText: (isVisible == true)
                                                  ? false
                                                  : true,
                                              cursorColor: Colors.black,
                                              textInputAction:
                                                  TextInputAction.next,
                                              focusNode: focusNode2,
                                              onEditingComplete: () {
                                                focusNode2.unfocus();
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              translate(
                                                                  context,
                                                                  'validation',
                                                                  'field'))));
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                  suffixIcon: InkWell(
                                                    child: (isVisible == true)
                                                        ? const Icon(
                                                            Icons
                                                                .visibility_outlined,
                                                            color: Colors.black,
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .visibility_off_outlined,
                                                            color: Colors.black,
                                                          ),
                                                    onTap: () {
                                                      setState(() {
                                                        isVisible = true;
                                                      });
                                                    },
                                                  ),
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  focusedErrorBorder:
                                                      InputBorder.none,
                                                  errorStyle: const TextStyle(
                                                      color: Colors.white),
                                                  hintText: translate(context,
                                                      'inputs', 'pass'),
                                                  hintStyle: const TextStyle(
                                                      color: Colors.black45),
                                                  fillColor: Colors.white),
                                            ),
                                          ),
                                          SizedBox(
                                            height: h * 0.05,
                                          ),
                                          InkWell(
                                            child: Text(
                                              translate(
                                                  context, 'login', 'reset'),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: w * 0.035,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onTap: () async {
                                              navP(context,
                                                  const ConfirmPhone());
                                            },
                                          ),
                                          SizedBox(
                                            height: h * 0.05,
                                          ),
                                          RoundedLoadingButton(
                                            controller: _btnController,
                                            child: SizedBox(
                                              width: w * 0.9,
                                              height: h * 0.07,
                                              child: Center(
                                                  child: Text(
                                                translate(context, 'buttons',
                                                    'login'),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: w * 0.07,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ),
                                            successColor: Colors.black,
                                            color: Colors.black,
                                            borderRadius: w * 0.07,
                                            height: h * 0.07,
                                            disabledColor: Colors.black,
                                            errorColor: Colors.black,
                                            valueColor: mainColor,
                                            onPressed: () async {
                                              FocusScope.of(context).unfocus();
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                AuthenticationProvider.userLogin(
                                                        email:
                                                            editingController1
                                                                .text,
                                                        password:
                                                            editingController2
                                                                .text
                                                                .toString(),
                                                        context: context)
                                                    .then((value) async {
                                                  if (value == true) {
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Home()),
                                                            (route) => false);
                                                  } else {
                                                    _btnController.error();
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 2));
                                                    _btnController.stop();
                                                  }
                                                }).catchError((error) {
                                                  print(
                                                      "login error ----------" +
                                                          error.toString());
                                                });
                                              } else {
                                                _btnController.error();
                                                await Future.delayed(
                                                    const Duration(seconds: 2));
                                                _btnController.stop();
                                              }
                                            },
                                          ),
                                          SizedBox(
                                            height: h * 0.03,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                child: Text(
                                                  translate(context, 'login',
                                                      'guest'),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: w * 0.045,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                onTap: () async {
                                                  dialog(context);
                                                  dbHelper.deleteAll();
                                                  Provider.of<BottomProvider>(
                                                          context,
                                                          listen: false)
                                                      .setIndex(0);
                                                  Provider.of<CartProvider>(
                                                          context,
                                                          listen: false)
                                                      .clearAll();
                                                  addressGuest = null;
                                                  await getHomeItems();
                                                  cartId = null;
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Home()),
                                                      (route) => false);
                                                  // navPRRU(context,Home());
                                                },
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: h * 0.01,
                                          ),
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceBetween,
                                          //   children: [
                                          // SizedBox(
                                          //   child: Row(
                                          //     children: [
                                          // Checkbox(
                                          //   value: select,
                                          //   activeColor: Colors.white,
                                          //   focusColor: Colors.white,
                                          //   overlayColor:
                                          //       MaterialStateProperty.all<
                                          //           Color>(Colors.white),
                                          //   checkColor: mainColor,
                                          //   fillColor: MaterialStateProperty
                                          //       .all<Color>(Colors.white),
                                          //   onChanged: (val) {
                                          //     print(val);
                                          //     setState(() {
                                          //       select = !select;
                                          //     });
                                          //   },
                                          // ),
                                          // SizedBox(
                                          //   width: w * 0.01,
                                          // ),
                                          // Text(
                                          //   translate(context, 'login',
                                          //       'remember'),
                                          //   style: TextStyle(
                                          //     color: Colors.white,
                                          //     fontSize: w * 0.035,
                                          //     fontWeight: FontWeight.bold,
                                          //   ),
                                          // ),
                                          //     ],
                                          //   ),
                                          // ),
                                          //   ],
                                          // ),
                                          SizedBox(
                                            height: h * 0.05,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                translate(context, 'login',
                                                    'have_not'),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: w * 0.035,
                                                ),
                                              ),
                                              InkWell(
                                                child: Text(
                                                  translate(context, 'login',
                                                      'register'),
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
                                          SizedBox(
                                            height: h * 0.02,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ]),
                          )))))
        ]));
  }
}
