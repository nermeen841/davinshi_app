import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../lang/change_language.dart';
import '../../../models/bottomnav.dart';
import '../../../models/constants.dart';

class SendDesigneScreen extends StatefulWidget {
  const SendDesigneScreen({Key? key}) : super(key: key);

  @override
  State<SendDesigneScreen> createState() => _SendDesigneScreenState();
}

class _SendDesigneScreenState extends State<SendDesigneScreen> {
  final formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  List<String> hint = language == 'en'
      ? [
          'Full name',
          'E-mail',
          'phone number',
          'designe type',
          'designe description'
        ]
      : [
          'الاسم بالكامل',
          'البريد الاكتروني',
          'رقم الهاتف',
          'نوع التصميم',
          'نبذه عن التصميم'
        ];
  String getText(int index) {
    return listEd[index].text;
  }

  List<FocusNode> listFocus = List<FocusNode>.generate(5, (_) => FocusNode());
  List<TextEditingController> listEd =
      List<TextEditingController>.generate(5, (_) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.03),
          child: Column(
            children: [
              Column(
                children: List.generate(listFocus.length, (index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: h * 0.03,
                      ),
                      TextFormField(
                        cursorColor: Colors.black,
                        controller: listEd[index],
                        focusNode: listFocus[index],
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
                        maxLines: index != 4 ? 1 : 4,
                        onEditingComplete: () {
                          listFocus[index].unfocus();
                          if (index < listEd.length - 1) {
                            FocusScope.of(context)
                                .requestFocus(listFocus[index + 1]);
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
                              return translate(context, 'validation', 'field');
                            }
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          focusedBorder: form(),
                          enabledBorder: form(),
                          errorBorder: form(),
                          focusedErrorBorder: form(),
                          hintText: hint[index],
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(
                height: h * 0.04,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: w * 0.27,
                      height: h * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(w * 0.04),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.cloud_download,
                          color: mainColor,
                          size: w * 0.2,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: w * 0.27,
                      height: h * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(w * 0.04),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.cloud_download,
                          color: mainColor,
                          size: w * 0.2,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: w * 0.27,
                      height: h * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(w * 0.04),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.cloud_download,
                          color: mainColor,
                          size: w * 0.2,
                        ),
                      ),
                    ),
                  ),
                ],
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
                controller: btnController,
                successColor: mainColor,
                color: mainColor,
                disabledColor: mainColor,
                errorColor: Colors.red,
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (formKey.currentState!.validate()) {
                  } else {
                    btnController.error();
                    await Future.delayed(const Duration(seconds: 2));
                    btnController.stop();
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
    );
  }

  InputBorder form() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 1.5),
      borderRadius: BorderRadius.circular(w * 0.03),
    );
  }
}
