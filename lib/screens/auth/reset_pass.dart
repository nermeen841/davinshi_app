import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';

class ResetPass extends StatefulWidget {
  final int id;
  const ResetPass({Key? key, required this.id}) : super(key: key);
  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final TextEditingController _controller = TextEditingController();
  Future resetPass() async {
    String url = domain;
    try {
      url = url + 'forgot-password';
      Response response = await Dio().post(url, data: {
        'user_id': widget.id,
        'password': _controller.text,
      });
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
      if (response.data['status'] == 1) {
        alertSuccessPass(context);
      }
    } catch (e) {
      _btnController.error();
      await Future.delayed(const Duration(milliseconds: 700));
      _btnController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Directionality(
            textDirection: getDirection(),
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text(
                  translate(context, 'reset_pass', 'title'),
                  style: TextStyle(
                      fontSize: w * 0.05,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                leading: BackButton(
                  color: mainColor,
                ),
                centerTitle: true,
                elevation: 0,
              ),
              body: Padding(
                padding: EdgeInsets.only(left: w * 0.05, right: w * 0.05),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: h * 0.04,
                      ),
                      Text(
                        translate(context, 'reset_pass', 'sub_title3'),
                        style: TextStyle(
                            fontSize: w * 0.035, color: Colors.grey[600]),
                      ),
                      SizedBox(
                        height: h * 0.05,
                      ),
                      TextFormField(
                        controller: _controller,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return translate(context, 'validation', 'field');
                          }
                          if (value.length < 6) {
                            return translate(context, 'validation', 'pass');
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            focusedBorder: form(),
                            enabledBorder: form(),
                            errorBorder: form(),
                            focusedErrorBorder: form(),
                            fillColor: Colors.grey[200],
                            filled: true,
                            hintText: translate(context, 'inputs', 'pass'),
                            hintStyle: const TextStyle(color: Colors.grey),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            errorMaxLines: 1,
                            errorStyle: TextStyle(fontSize: w * 0.03)),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: h * 0.06,
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
                              translate(context, 'buttons', 'send'),
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
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            resetPass();
                          } else {
                            _btnController.error();
                            await Future.delayed(
                                const Duration(milliseconds: 1000));
                            _btnController.stop();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  InputBorder form() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: (Colors.white), width: 1),
      borderRadius: BorderRadius.circular(w * 0.06),
    );
  }
}
