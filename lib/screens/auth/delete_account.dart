import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/provider/AuthenticationProvider.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../models/bottomnav.dart';

class DeleteAccountScreen extends StatefulWidget {
  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _oldPass = FocusNode();
  String? _oldPassword;
  bool _visibility1 = true;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                translateString("Delete Account", "تاكيد حذف الحساب"),
                style: TextStyle(
                    fontSize: w * 0.05,
                    fontFamily: (language == 'en') ? 'Nunito' : 'Almarai',
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              leading: BackButton(
                color: mainColor,
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.only(top: h * 0.007, bottom: h * 0.005),
                child: SizedBox(
                  width: w * 0.9,
                  height: h,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: h * 0.03,
                        ),
                        TextFormField(
                          cursorColor: Colors.black,
                          obscureText: _visibility1,
                          textInputAction: TextInputAction.next,
                          focusNode: _oldPass,
                          onEditingComplete: () {
                            _oldPass.unfocus();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'enter old password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: form(),
                            enabledBorder: form(),
                            errorBorder: form(),
                            fillColor: Colors.grey[200],
                            filled: true,
                            focusedErrorBorder: form(),
                            hintText:
                                translateString("password", "كلمة المرور"),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily:
                                  (language == 'en') ? 'Nunito' : 'Almarai',
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            errorMaxLines: 1,
                            errorStyle: TextStyle(fontSize: w * 0.03),
                            suffixIcon: IconButton(
                              icon: !_visibility1
                                  ? Icon(
                                      Icons.visibility,
                                      color: mainColor,
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                      color: mainColor,
                                    ),
                              onPressed: () {
                                setState(() {
                                  _visibility1 = !_visibility1;
                                });
                              },
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (val) {
                            setState(() {
                              _oldPassword = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: h * 0.03,
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
                                translateString("Send", "إرسال"),
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
                            print(_oldPassword.toString());
                            if (_formKey.currentState!.validate()) {
                              AuthenticationProvider().deleteAccount(
                                  context: context,
                                  controller: _btnController,
                                  password: _oldPassword.toString());
                            } else {
                              _btnController.error();
                              await Future.delayed(
                                  const Duration(milliseconds: 1000));
                              _btnController.stop();
                            }
                          },
                        ),
                        SizedBox(
                          height: h * 0.1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }

  InputBorder form() {
    return OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
        borderRadius: BorderRadius.circular(25));
  }
}
