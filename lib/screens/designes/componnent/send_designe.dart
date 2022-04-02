// ignore_for_file: deprecated_member_use, avoid_print

import 'dart:io';

import 'package:davinshi_app/provider/add_designe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
  List<String> images = [];
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
                    onTap: () async {
                      getImage1();
                    },
                    child: Container(
                      width: w * 0.25,
                      height: h * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(w * 0.04),
                      ),
                      child: Center(
                        child: (image1 == null)
                            ? Icon(
                                Icons.cloud_download,
                                color: mainColor,
                                size: w * 0.15,
                              )
                            : Image.file(
                                image1!,
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      getImage2();
                    },
                    child: Container(
                      width: w * 0.25,
                      height: h * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(w * 0.04),
                      ),
                      child: Center(
                        child: (image2 == null)
                            ? Icon(
                                Icons.cloud_download,
                                color: mainColor,
                                size: w * 0.15,
                              )
                            : Image.file(
                                image2!,
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      getImage3();
                    },
                    child: Container(
                      width: w * 0.25,
                      height: h * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(w * 0.04),
                      ),
                      child: Center(
                        child: (image3 == null)
                            ? Icon(
                                Icons.cloud_download,
                                color: mainColor,
                                size: w * 0.15,
                              )
                            : Image.file(
                                image3!,
                                fit: BoxFit.contain,
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
                    addDesigne(
                        context: context,
                        name: listEd[0].text,
                        email: listEd[1].text,
                        controller: btnController,
                        phone: listEd[2].text,
                        designeName: listEd[3].text,
                        images: images,
                        note: listEd[4].text);
                  } else {
                    btnController.error();
                    await Future.delayed(const Duration(seconds: 1));
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

  File? image1;
  File? image2;
  File? image3;
  String imagePath1 = "";
  String imagePath2 = "";
  String imagePath3 = "";

  Future getImage1() async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image1 = File(pickedFile.path);
        imagePath1 = pickedFile.path;
        images.add(imagePath1);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImage2() async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image2 = File(pickedFile.path);
        imagePath2 = pickedFile.path;
        images.add(imagePath2);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImage3() async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image3 = File(pickedFile.path);
        imagePath3 = pickedFile.path;
        images.add(imagePath3);
      } else {
        print('No image selected.');
      }
    });
  }
}
