// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/country.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/provider/address.dart';

class AddressInfo extends StatefulWidget {
  final bool isUpdate;
  final bool inCart;
  final AddressClass? address;
  final String? street, country;
  const AddressInfo(this.isUpdate,
      {Key? key, this.street, this.country, this.address, required this.inCart})
      : super(key: key);
  @override
  _AddressInfoState createState() => _AddressInfoState();
}

class _AddressInfoState extends State<AddressInfo> {
  String? verificationId, sms;
  String? areaName;
  late int areaId;
  // Countries _list= countries.firstWhere((e) => e.id==countryId);
  final List<String> _hint = language == 'en'
      ? [
          'Your Title',
          'Name',
          'E-mail (optional)',
          'phone number',
          '',
          'Country',
          'Street',
          'Note (optional)'
        ]
      : [
          'عنوانك',
          'الاسم بالكامل',
          'البريد الاكتروني (اختياري)',
          'رقم الهاتف',
          '',
          'الدولة',
          'اسم الشارع',
          'ملاحظات (اختياري)'
        ];
  final List<FocusNode> _listFocus =
      List<FocusNode>.generate(8, (_) => FocusNode());
  final List<TextEditingController> _listEd =
      List<TextEditingController>.generate(8, (_) => TextEditingController());
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();
  String getText(int index) {
    return _listEd[index].text;
  }

  Future setAddress() async {
    if (login) {
      String url = domain;
      late Map data;
      if (widget.isUpdate) {
        url += 'update-myShipping-address';
        data = {
          "shippingAddress_id": widget.address!.id,
          "title": getText(0),
          "name": getText(1),
          "email": getText(2),
          "phone": getText(3),
          "address_d": getText(5),
          "address": getText(6),
          "note": getText(7),
          "lat_and_long": late.toString() + ',' + longe.toString(),
          "area_id": areaId,
        };
      } else {
        url += 'save-myShipping-address';
        data = {
          "title": getText(0),
          "name": getText(1),
          "email": getText(2),
          "phone": getText(3),
          "address_d": getText(5),
          "address": getText(6),
          "note": getText(7),
          "lat_and_long": late.toString() + ',' + longe.toString(),
          "area_id": areaId,
        };
      }
      try {
        Response response = await Dio().post(
          url,
          data: data,
          options: Options(
            headers: {
              "auth-token": auth,
            },
          ),
        );
        if (response.data['status'] == 1) {
          print(1);
          await Provider.of<AddressProvider>(context, listen: false)
              .getAddress();
          _btnController.success();
          // alertSuccessAddress(context);
          await Future.delayed(const Duration(seconds: 3));
          print(widget.inCart);
          if (widget.inCart) {
            int count = 2;
            Navigator.popUntil(context, (route) => count-- <= 0);
          } else {
            int count = 2;
            Navigator.popUntil(context, (route) => count-- <= 0);
          }
        } else {
          print(2);
          _btnController.error();
          await Future.delayed(const Duration(milliseconds: 700));
          _btnController.stop();
          //setAddress();
        }
      } catch (e) {
        print(3);
        print(e);
        _btnController.error();
        await Future.delayed(const Duration(milliseconds: 1500));
        _btnController.stop();
        //setAddress();
      }
    } else {
      print('as');
      addressGuest = AddressClass(
          id: 0,
          userId: 0,
          areaId: areaId,
          title: getText(0),
          name: getText(1),
          email: getText(2),
          country: getText(5),
          phone1: getText(3),
          note: getText(7),
          address: getText(6),
          lat: late,
          long: longe);
      // _btnController.success();
      // await Future.delayed(Duration(seconds: 2));
      print(addressGuest);
      int count = 2;
      Navigator.popUntil(context, (route) => count-- <= 0);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate) {
      _listEd[0].text = widget.address!.title;
      _listEd[1].text = widget.address!.name;
      _listEd[2].text = widget.address!.email ?? '';
      _listEd[3].text = widget.address!.phone1;
      _listEd[5].text = widget.address!.country;
      _listEd[6].text = widget.address!.address;
      _listEd[7].text = widget.address!.note ?? '';
    } else {
      _listEd[6].text = widget.street ?? '';
      _listEd[5].text = widget.country ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Directionality(
        textDirection: getDirection(),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                translate(context, 'address_info', 'title'),
                style: TextStyle(
                    fontSize: w * 0.05,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              leading: const BackButton(
                color: Colors.black,
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: Center(
              child: SizedBox(
                width: w * 0.9,
                height: h,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: List.generate(_listFocus.length, (index) {
                          return Column(
                            children: [
                              SizedBox(
                                height: h * 0.03,
                              ),
                              if (index != 4)
                                TextFormField(
                                  cursorColor: Colors.black,
                                  controller: _listEd[index],
                                  focusNode: _listFocus[index],
                                  textInputAction: index == 7 || index == 6
                                      ? TextInputAction.newline
                                      : TextInputAction.next,
                                  keyboardType: index == 2
                                      ? TextInputType.emailAddress
                                      : index == 6 || index == 7
                                          ? TextInputType.multiline
                                          : index == 4 || index == 3
                                              ? TextInputType.number
                                              : TextInputType.text,
                                  inputFormatters: index != 2
                                      ? null
                                      : [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r"[0-9 a-z  @ .]")),
                                        ],
                                  maxLines: index == 7 ? 6 : 1,
                                  onEditingComplete: () {
                                    _listFocus[index].unfocus();
                                    if (index < _listEd.length - 1) {
                                      FocusScope.of(context)
                                          .requestFocus(_listFocus[index + 1]);
                                    }
                                  },
                                  validator: (value) {
                                    if (index != 2 && index != 7) {
                                      if (value!.isEmpty) {
                                        return translate(
                                            context, 'validation', 'field');
                                      }
                                    }
                                    if (index == 2) {
                                      if (value != null && value.isNotEmpty) {
                                        if (value.length < 4 ||
                                            !value.endsWith('.com') ||
                                            '@'.allMatches(value).length != 1) {
                                          return translate(context,
                                              'validation', 'valid_email');
                                        }
                                      }
                                    }
                                    if (index == 3 || index == 4) {
                                      if (value!.length != countryNumber) {
                                        return translate(
                                            context, 'validation', 'phone');
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
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                  ),
                                ),
                              if (index == 4)
                                SizedBox(
                                  width: w * 0.9,
                                  child: FormField(
                                    builder: (state) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: w * 0.9,
                                            height: h * 0.09,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: mainColor, width: 1.5),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: w * 0.02),
                                                child: SizedBox(
                                                  width: w * 0.9,
                                                  child: DropdownButton<String>(
                                                    isDense: true,
                                                    isExpanded: true,
                                                    underline: const SizedBox(),
                                                    iconEnabledColor: mainColor,
                                                    iconDisabledColor:
                                                        mainColor,
                                                    iconSize: w * 0.08,
                                                    hint: Text(
                                                      translate(context,
                                                          'inputs', 'area'),
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[400]),
                                                    ),
                                                    items: List.generate(
                                                        allArea.length,
                                                        (index) {
                                                      return DropdownMenuItem(
                                                        value: translateString(
                                                            allArea[index]
                                                                .nameEn,
                                                            allArea[index]
                                                                .nameAr),
                                                        child: Text(
                                                          translateString(
                                                              allArea[index]
                                                                  .nameEn,
                                                              allArea[index]
                                                                  .nameAr),
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            areaName =
                                                                translateString(
                                                                    allArea[index]
                                                                        .nameEn,
                                                                    allArea[index]
                                                                        .nameAr);
                                                            areaId =
                                                                allArea[index]
                                                                    .id;
                                                          });
                                                        },
                                                      );
                                                    }),
                                                    onChanged: (val) {},
                                                    value: areaName,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ), // your widget
                                          SizedBox(
                                            height: h * 0.01,
                                          ),
                                          if (state.errorText != null)
                                            Text(
                                              state.errorText ?? '',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .errorColor,
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                    validator: (val) {
                                      if (areaName == null) {
                                        return translate(
                                            context, 'validation', 'area');
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                            ],
                          );
                        }),
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      RoundedLoadingButton(
                        child: Container(
                          height: h * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: mainColor,
                          ),
                          child: Center(
                            child: Text(
                              translate(context, 'buttons',
                                  !widget.inCart ? 'save_location' : 'cont'),
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
                          if (_formKey.currentState!.validate()) {
                            setAddress();
                          } else {
                            _btnController.error();
                            await Future.delayed(
                                const Duration(milliseconds: 1000));
                            _btnController.stop();
                          }
                        },
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                    ],
                  ),
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
      borderSide: BorderSide(color: mainColor, width: 1.5),
      borderRadius: BorderRadius.circular(15),
    );
  }
}
