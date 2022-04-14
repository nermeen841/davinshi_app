// ignore_for_file: avoid_print

import 'package:davinshi_app/models/products_cla.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../lang/change_language.dart';
import '../../models/bottomnav.dart';
import '../../models/constants.dart';

class ProductHelp extends StatefulWidget {
  const ProductHelp({Key? key}) : super(key: key);

  @override
  State<ProductHelp> createState() => _ProductHelpState();
}

class _ProductHelpState extends State<ProductHelp> {
  final RoundedLoadingButtonController _btnController2 =
      RoundedLoadingButtonController();
  final List<String> _hint = language == 'en'
      ? ['Full name', 'E-mail', 'phone number', 'Title', 'Message']
      : [
          'الاسم بالكامل',
          'البريد الاكتروني',
          'رقم الهاتف',
          'العنوان',
          'المحتوى'
        ];
  final List<TextEditingController> _listEd =
      List<TextEditingController>.generate(
          5,
          (_) => _ == 3
              ? language == 'en'
                  ? TextEditingController(
                      text: 'Question about ${productCla!.nameEn}')
                  : TextEditingController(text: 'سوال عن ${productCla!.nameAr}')
              : TextEditingController());
  String getText(int index) {
    return _listEd[index].text;
  }

  final _formKey = GlobalKey<FormState>();
  final List<FocusNode> _listFocus =
      List<FocusNode>.generate(5, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: SizedBox(
          width: w * 0.9,
          child: SingleChildScrollView(
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
                          readOnly: index == 3 ? true : false,
                          controller: _listEd[index],
                          focusNode: _listFocus[index],
                          textInputAction: index == 4
                              ? TextInputAction.newline
                              : TextInputAction.next,
                          keyboardType: index == 1
                              ? TextInputType.emailAddress
                              : index == 4
                                  ? TextInputType.multiline
                                  : (index == 2)
                                      ? TextInputType.phone
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
                RoundedLoadingButton(
                  child: SizedBox(
                    width: w * 0.9,
                    height: h * 0.07,
                    child: Center(
                        child: Text(
                      translate(context, 'buttons', 'send'),
                      style: TextStyle(color: Colors.white, fontSize: w * 0.05),
                    )),
                  ),
                  controller: _btnController2,
                  successColor: mainColor,
                  color: mainColor,
                  disabledColor: mainColor,
                  errorColor: Colors.red,
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (_formKey.currentState!.validate()) {
                      sendReq();
                    } else {
                      _btnController2.error();
                      await Future.delayed(const Duration(seconds: 2));
                      _btnController2.stop();
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
    );
  }

  Future sendReq() async {
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
        _btnController2.stop();
      }
      if (response.statusCode == 200) {
        _btnController2.stop();
        alertSuccessData(context, 'Question Sent');
      }
    } catch (e) {
      print('e');
      print(e);
      _btnController2.error();
      await Future.delayed(const Duration(seconds: 2));
      _btnController2.stop();
    }
  }

  InputBorder form() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: mainColor, width: 1.5),
      borderRadius: BorderRadius.circular(15),
    );
  }
}
