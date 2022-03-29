// ignore_for_file: use_key_in_widget_constructors, unnecessary_new, prefer_final_fields, avoid_print

import 'package:davinshi_app/models/country.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
  FocusNode nameFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  int selectedval = 0;
  late int genderType;
  String? daySelected;
  String? monthSelected;
  String? yearSelected;
  TextEditingController userName = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  List radio = [
    translateString("Female", "انثي"),
    translateString("Male", "ذكر"),
  ];

  Future updateUser() async {
    final String url = domain + 'edit-profile';
    try {
      Response response = await Dio().post(
        url,
        data: {
          "name": name.text,
          "surname": userName.text,
          "email": email.text,
          "gender": genderType,
          "birth_day":
              yearSelected! + "/" + monthSelected! + "/" + daySelected!,
        },
        options: Options(
            headers: {'auth-token': auth, "Content-Language": language}),
      );
      print(response.data);
      if (response.data['status'] == 0) {
        String data = '';
        if (language == 'ar') {
          response.data['message'].forEach((e) {
            data += e + '\n';
          });
          print(data);
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
          email: userData['email'],
          userName: userData['surname'],
          image: userData['img'],
          gender: userData['gender'],
        );
        setState(() {
          userName = response.data['user']['name'];
          userEmail = response.data['user']['email'];
          userImage = response.data['user']['img'];
        });
        setUserId(userData['id']);
        _btnController.success();
        await Future.delayed(const Duration(milliseconds: 2500));
        _btnController.stop();
        Navigator.pop(context);
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
          backgroundColor: mainColor,
          appBar: AppBar(
            backgroundColor: mainColor,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            title: Text(
              (language == 'en') ? "update Information" : "تعديل المعلومات",
              style: TextStyle(
                  fontSize: w * 0.05,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: InkWell(
              onTap: (() => Navigator.pop(context)),
              child: Container(
                width: w * 0.05,
                height: h * 0.01,
                margin: EdgeInsets.symmetric(
                    horizontal: w * 0.02, vertical: h * 0.017),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w * 0.01)),
                child: Icon(
                  Icons.arrow_back,
                  color: mainColor,
                ),
              ),
            ),
          ),
          body: Container(
            height: h,
            width: w,
            padding:
                EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.02),
            margin: EdgeInsets.only(top: h * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(w * 0.05),
                topRight: Radius.circular(w * 0.05),
              ),
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: h * 0.007, bottom: h * 0.005),
                  child: SizedBox(
                    width: w * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translateString('Full name', 'الاسم الاول'),
                                  style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontSize: w * 0.04,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: h * 0.01,
                                ),
                                SizedBox(
                                  width: w * 0.4,
                                  height: w * 0.13,
                                  child: TextFormField(
                                    cursorColor: Colors.black,
                                    controller: name,
                                    focusNode: nameFocus,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    onEditingComplete: () {
                                      nameFocus.unfocus();

                                      FocusScope.of(context)
                                          .requestFocus(userNameFocus);
                                    },
                                    decoration: InputDecoration(
                                      focusedBorder: form(),
                                      enabledBorder: form(),
                                      errorBorder: form(),
                                      focusedErrorBorder: form(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translateString('Last name', 'اسم العائلة'),
                                  style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontSize: w * 0.04,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: h * 0.01,
                                ),
                                SizedBox(
                                  width: w * 0.4,
                                  height: w * 0.13,
                                  child: TextFormField(
                                    cursorColor: Colors.black,
                                    controller: userName,
                                    focusNode: userNameFocus,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    onEditingComplete: () {
                                      userNameFocus.unfocus();

                                      FocusScope.of(context)
                                          .requestFocus(emailFocus);
                                    },
                                    decoration: InputDecoration(
                                      focusedBorder: form(),
                                      enabledBorder: form(),
                                      errorBorder: form(),
                                      focusedErrorBorder: form(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: h * 0.05,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              translateString(
                                  'E-mail address', 'البريد الإلكتروني'),
                              style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: h * 0.01,
                            ),
                            SizedBox(
                              height: w * 0.13,
                              child: TextFormField(
                                cursorColor: Colors.black,
                                controller: email,
                                focusNode: emailFocus,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                onEditingComplete: () {
                                  emailFocus.unfocus();

                                  FocusScope.of(context)
                                      .requestFocus(phoneFocus);
                                },
                                decoration: InputDecoration(
                                  focusedBorder: form(),
                                  enabledBorder: form(),
                                  errorBorder: form(),
                                  focusedErrorBorder: form(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: h * 0.05,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: translateString(
                                        'Gender : ', 'النوع : '),
                                    style: TextStyle(
                                        fontFamily: 'Tajawal',
                                        fontSize: w * 0.04,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: translateString(
                                        '( Optional ) ', '( اختياري )'),
                                    style: TextStyle(
                                        fontFamily: 'Tajawal',
                                        fontSize: w * 0.04,
                                        fontWeight: FontWeight.w600,
                                        color: mainColor),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: h * 0.01,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                radio.length,
                                (index) => Row(
                                  children: [
                                    Radio(
                                        value: index,
                                        splashRadius: w * 0.1,
                                        activeColor: mainColor,
                                        groupValue: selectedval,
                                        onChanged: (int? value) {
                                          setState(() {
                                            selectedval = value!;
                                          });
                                          if (selectedval == 0) {
                                            setState(() {
                                              genderType = 2;
                                            });
                                          } else if (selectedval == 1) {
                                            setState(() {
                                              genderType = 1;
                                            });
                                          }
                                        }),
                                    Text(radio[index]),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: h * 0.03,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              translateString('Phone number ', 'رقم الهاتف'),
                              style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: h * 0.01,
                            ),
                            SizedBox(
                              height: w * 0.13,
                              child: TextFormField(
                                cursorColor: Colors.black,
                                controller: phone,
                                focusNode: phoneFocus,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.phone,
                                onEditingComplete: () {
                                  phoneFocus.unfocus();
                                },
                                decoration: InputDecoration(
                                  focusedBorder: form(),
                                  prefixIcon: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: h * 0.02,
                                        horizontal: w * 0.01),
                                    width: w * 0.1,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black45),
                                      borderRadius: (language == 'ar')
                                          ? BorderRadius.only(
                                              topRight:
                                                  Radius.circular(w * 0.02),
                                              bottomRight:
                                                  Radius.circular(w * 0.02),
                                            )
                                          : BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(w * 0.02),
                                              bottomLeft:
                                                  Radius.circular(w * 0.02),
                                            ),
                                    ),
                                    child: Text(
                                      countryCode,
                                      style: TextStyle(
                                          fontFamily: 'Tajawal',
                                          fontSize: w * 0.04,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  enabledBorder: form(),
                                  errorBorder: form(),
                                  focusedErrorBorder: form(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: h * 0.05,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: translateString(
                                        'Choose your birth date : ',
                                        'يرجي تحديد تاريخ ميلادك : '),
                                    style: TextStyle(
                                        fontFamily: 'Tajawal',
                                        fontSize: w * 0.04,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: translateString(
                                        '( Optional )', '( اختياري )'),
                                    style: TextStyle(
                                        fontFamily: 'Tajawal',
                                        fontSize: w * 0.04,
                                        fontWeight: FontWeight.w600,
                                        color: mainColor),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: h * 0.01,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    showDayMenu();
                                  },
                                  child: Container(
                                    width: w * 0.25,
                                    height: h * 0.07,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black),
                                      borderRadius:
                                          BorderRadius.circular(w * 0.01),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        (daySelected == null)
                                            ? Text(
                                                translateString('Day', 'يوم'))
                                            : Text(daySelected!),
                                        const Icon(Icons.arrow_downward)
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showMonthMenu();
                                  },
                                  child: Container(
                                    width: w * 0.25,
                                    height: h * 0.07,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black),
                                      borderRadius:
                                          BorderRadius.circular(w * 0.01),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        (monthSelected == null)
                                            ? Text(
                                                translateString('Month', 'شهر'))
                                            : Text(monthSelected!),
                                        const Icon(Icons.arrow_downward)
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showYearMenu();
                                  },
                                  child: Container(
                                    width: w * 0.25,
                                    height: h * 0.07,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black),
                                      borderRadius:
                                          BorderRadius.circular(w * 0.01),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        (yearSelected == null)
                                            ? Text(
                                                translateString('Year', 'سنة'))
                                            : Text(yearSelected!),
                                        const Icon(Icons.arrow_downward)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: h * 0.04,
                        ),
                        RoundedLoadingButton(
                          child: Container(
                            height: h * 0.08,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(w * 0.02),
                              color: mainColor,
                            ),
                            child: Center(
                              child: Text(
                                translateString(
                                    'update profile', 'تحديث الحساب الشخصي'),
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
                          height: h * 0.03,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }

  InputBorder form() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black54, width: 1),
      borderRadius: BorderRadius.circular(w * 0.02),
    );
  }

  void showDayMenu() async {
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 380, 100, 200),
      items: day.map((String choice) {
        return PopupMenuItem(
          value: choice,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
              setState(() {
                daySelected = choice;
              });
            },
            child: Text(
              choice,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: w * 0.04,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Tajawal'),
            ),
          ),
        );
      }).toList(),
      elevation: 8.0,
    );
  }

  void showMonthMenu() async {
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 380, 100, 200),
      items: month.map((String choice) {
        return PopupMenuItem(
          value: choice,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
              setState(() {
                monthSelected = choice;
              });
            },
            child: Text(
              choice,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: w * 0.04,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Tajawal'),
            ),
          ),
        );
      }).toList(),
      elevation: 8.0,
    );
  }

  void showYearMenu() async {
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 380, 100, 200),
      items: yaer.map((String choice) {
        return PopupMenuItem(
          value: choice,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
              setState(() {
                yearSelected = choice;
              });
            },
            child: Text(
              choice,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: w * 0.04,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Tajawal'),
            ),
          ),
        );
      }).toList(),
      elevation: 8.0,
    );
  }
}
