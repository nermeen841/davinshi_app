// ignore_for_file: prefer_final_fields, avoid_print, use_key_in_widget_constructors

import 'package:davinshi_app/provider/social.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  List<String> _hint = language == 'en'
      ? ['Full name', 'E-mail', 'phone number', 'Title', 'Message']
      : [
          'الاسم بالكامل',
          'البريد الاكتروني',
          'رقم الهاتف',
          'العنوان',
          'المحتوى'
        ];
  String getText(int index) {
    return _listEd[index].text;
  }

  Future register() async {
    final String url = domain +
        'contact?name=${getText(0)}&email=${getText(1)}&phone=${getText(2)}&title=${getText(3)}&message=${getText(4)}';
    try {
      Response response = await Dio().post(url);
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
      if (response.statusCode == 200) {
        _btnController.stop();
        alertSuccessData(context, translate(context, 'contact_us', 'success'));
      }
    } catch (e) {
      print('e');
      print(e);
      _btnController.error();
      await Future.delayed(const Duration(seconds: 2));
      _btnController.stop();
    }
  }

  List<FocusNode> _listFocus = List<FocusNode>.generate(5, (_) => FocusNode());
  List<TextEditingController> _listEd =
      List<TextEditingController>.generate(5, (_) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    Provider.of<SocialIcons>(context, listen: false).getSocialIcons();
    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          backgroundColor: mainColor,
          appBar: AppBar(
            backgroundColor: mainColor,
            systemOverlayStyle: st,
            automaticallyImplyLeading: false,
            title: Text(
              translate(context, 'page_five', 'contacts'),
              style: TextStyle(
                  fontSize: w * 0.05,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
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
            centerTitle: true,
            elevation: 0,
          ),
          body: Container(
            width: double.infinity,
            height: h,
            margin: EdgeInsets.only(top: h * 0.02),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(w * 0.07),
                topRight: Radius.circular(w * 0.07),
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.05, vertical: h * 0.02),
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
                              controller: _listEd[index],
                              focusNode: _listFocus[index],
                              textInputAction: index == 4
                                  ? TextInputAction.newline
                                  : TextInputAction.next,
                              keyboardType: index == 1
                                  ? TextInputType.emailAddress
                                  : index == 4
                                      ? TextInputType.multiline
                                      : TextInputType.text,
                              inputFormatters: index != 1
                                  ? null
                                  : [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r"[0-9 a-z  @ .]")),
                                    ],
                              maxLines: index != 4 ? 1 : 6,
                              onEditingComplete: () {
                                _listFocus[index].unfocus();
                                if (index < _listEd.length - 1) {
                                  FocusScope.of(context)
                                      .requestFocus(_listFocus[index + 1]);
                                }
                              },
                              validator: (value) {
                                if (index == 1) {
                                  if (value!.length < 4 ||
                                      !value.endsWith('.com') ||
                                      '@'.allMatches(value).length != 1) {
                                    return translate(
                                        context, 'validation', 'valid_email');
                                  }
                                }
                                if (index != 1) {
                                  if (value!.isEmpty) {
                                    return translate(
                                        context, 'validation', 'field');
                                  }
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                focusedBorder: form(),
                                enabledBorder: form(),
                                errorBorder: form(),
                                focusedErrorBorder: form(),
                                hintText: _hint[index],
                                hintStyle: TextStyle(color: Colors.grey[400]),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    SizedBox(
                      height: h * .04,
                    ),
                    Center(
                      child: Text(
                        (language == 'en')
                            ? "Contact us thruogh Social media"
                            : "تواصل عن طريق السوشيال ميديا",
                        style: TextStyle(
                            color: mainColor,
                            fontFamily: 'Tajawal',
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: h * .04,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        SocialIcons.socialModel!.data!.length,
                        (index) => InkWell(
                          onTap: () async {
                            if (SocialIcons.socialModel!.data![index].title! ==
                                'whatsapp') {
                              await launch(
                                  "whatsapp://send?phone=${SocialIcons.socialModel!.data![index].link!}&text=");
                            } else if (SocialIcons
                                    .socialModel!.data![index].title! ==
                                'phone') {
                              await launch(
                                  'tel:${SocialIcons.socialModel!.data![index].link!}');
                            } else {
                              await launch(
                                  SocialIcons.socialModel!.data![index].link!);
                            }
                          },
                          child: CircleAvatar(
                            radius: w * 0.06,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                                SocialIcons.socialModel!.data![index].src! +
                                    '/' +
                                    SocialIcons.socialModel!.data![index].img!),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h * .04,
                    ),
                    RoundedLoadingButton(
                      child: SizedBox(
                        width: w * 0.9,
                        height: h * 0.07,
                        child: Center(
                            child: Text(
                          translate(context, 'buttons', 'send'),
                          style: TextStyle(
                              color: Colors.white, fontSize: w * 0.05),
                        )),
                      ),
                      controller: _btnController,
                      successColor: mainColor,
                      color: mainColor,
                      disabledColor: mainColor,
                      errorColor: Colors.red,
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (_formKey.currentState!.validate()) {
                          register();
                        } else {
                          _btnController.error();
                          await Future.delayed(const Duration(seconds: 2));
                          _btnController.stop();
                        }
                      },
                    ),
                    SizedBox(
                      height: h * .05,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputBorder form() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 1.5),
      borderRadius: BorderRadius.circular(w * 0.03),
    );
  }
}
