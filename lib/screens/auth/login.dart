// ignore_for_file: avoid_print, unnecessary_string_interpolations

import 'package:davinshi_app/screens/auth/sign_upScreen.dart';
import 'package:flutter/material.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/cart.dart';
import 'package:davinshi_app/models/constants.dart';
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
                    image: AssetImage("assets/images/Bitmap-1.png"),
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
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/Rectangle.png"),
                                  fit: BoxFit.fill)),
                          padding: EdgeInsets.only(top: h * 0.07),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: w * 0.02),
                                  child: Align(
                                    alignment: (language == 'en')
                                        ? Alignment.topRight
                                        : Alignment.topLeft,
                                    child: Container(
                                      width: w * 0.09,
                                      height: h * 0.04,
                                      color: Colors.white,
                                      child: const Center(
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: h * 0.03,
                                      ),
                                      Center(
                                          child: Image.asset(
                                        "assets/images/multi-app.png",
                                        width: w * 0.6,
                                        height: h * 0.2,
                                        fit: BoxFit.contain,
                                      )),
                                      Center(
                                        child: Container(
                                          height: h * 0.07,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: w * 0.09),
                                          decoration: BoxDecoration(
                                              color: mainColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      w * 0.08),
                                              border: Border.all(
                                                  color: Colors.white)),
                                          child: Center(
                                            child: Text(
                                              translate(
                                                  context, 'buttons', 'login'),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: w * 0.07,
                                                  fontFamily: 'Tajawal',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
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
                                                translate(context, 'buttons',
                                                    'login'),
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xff0F0101),
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
                                                          offset: const Offset(
                                                              0, 3),
                                                          blurRadius: 3)
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            w * 0.08)),
                                                child: TextFormField(
                                                  controller:
                                                      editingController1,
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
                                                        .requestFocus(
                                                            focusNode2);
                                                  },
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      ScaffoldMessenger.of(
                                                              context)
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
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    focusedErrorBorder:
                                                        InputBorder.none,
                                                    errorStyle: const TextStyle(
                                                        color: Colors.white),
                                                    hintText: translate(context,
                                                        'inputs', 'phone'),
                                                    hintStyle: const TextStyle(
                                                        color: Colors.black45),
                                                    labelStyle: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: h * 0.03,
                                              ),
                                              Text(
                                                translate(
                                                    context, 'inputs', 'pass'),
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xff0F0101),
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
                                                          offset: const Offset(
                                                              0, 3),
                                                          blurRadius: 3)
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            w * 0.08)),
                                                child: TextFormField(
                                                  controller:
                                                      editingController2,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  textAlign: TextAlign.start,
                                                  obscureText:
                                                      (isVisible == true)
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
                                                      ScaffoldMessenger.of(
                                                              context)
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
                                                        child:
                                                            (isVisible == true)
                                                                ? const Icon(
                                                                    Icons
                                                                        .visibility_outlined,
                                                                    color: Colors
                                                                        .black,
                                                                  )
                                                                : const Icon(
                                                                    Icons
                                                                        .visibility_off_outlined,
                                                                    color: Colors
                                                                        .black,
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
                                                      errorBorder:
                                                          InputBorder.none,
                                                      focusedErrorBorder:
                                                          InputBorder.none,
                                                      errorStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white),
                                                      hintText: translate(
                                                          context,
                                                          'inputs',
                                                          'pass'),
                                                      hintStyle:
                                                          const TextStyle(
                                                              color: Colors
                                                                  .black45),
                                                      fillColor: Colors.white),
                                                ),
                                              ),
                                              SizedBox(
                                                height: h * 0.02,
                                              ),
                                              InkWell(
                                                child: Text(
                                                  translate(context, 'login',
                                                      'reset'),
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xff0C0101),
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
                                                height: h * 0.03,
                                              ),
                                              RoundedLoadingButton(
                                                controller: _btnController,
                                                child: SizedBox(
                                                  width: w * 0.9,
                                                  height: h * 0.07,
                                                  child: Center(
                                                      child: Text(
                                                    translate(context,
                                                        'buttons', 'login'),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: w * 0.07,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                                ),
                                                successColor:
                                                    const Color(0xff302E2E),
                                                color: const Color(0xff302E2E),
                                                borderRadius: w * 0.07,
                                                height: h * 0.07,
                                                disabledColor: Colors.white,
                                                errorColor: Colors.white,
                                                valueColor: Colors.white,
                                                onPressed: () async {
                                                  FocusScope.of(context)
                                                      .unfocus();
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
                                                        Navigator.pushAndRemoveUntil(
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
                                                                seconds: 1));
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
                                                        const Duration(
                                                            seconds: 2));
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
                                                      translate(context,
                                                          'login', 'guest'),
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: w * 0.045,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    onTap: () async {
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

                                                      cartId = null;
                                                      Navigator.pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
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
                                                      translate(context,
                                                          'login', 'register'),
                                                      style: TextStyle(
                                                        color: mainColor,
                                                        fontSize: w * 0.035,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      navP(context,
                                                          SignupScreen());
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
                              ],
                            ),
                          )))))
        ]));
  }
}
