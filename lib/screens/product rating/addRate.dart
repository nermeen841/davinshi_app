// ignore_for_file: file_names, avoid_print

import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:simple_star_rating/simple_star_rating.dart';
import 'package:dio/dio.dart' as dio;
import '../../lang/change_language.dart';
import '../../models/constants.dart';

class AddRateScreen extends StatefulWidget {
  final String productId;
  const AddRateScreen({Key? key, required this.productId}) : super(key: key);

  @override
  State<AddRateScreen> createState() => _AddRateScreenState();
}

class _AddRateScreenState extends State<AddRateScreen> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  double stars = 5.0;
  String rating = '';
  Future saveRate() async {
    final String url = domain + 'save-rating';
    try {
      dio.Response response = await dio.Dio().post(
        url,
        data: {
          "product_id": widget.productId,
          "rating": stars,
          'comment': rating,
        },
        options: dio.Options(headers: {"auth-token": auth}),
      );
      if (response.statusCode == 200) {
        //getRates();
        alertSuccessData(context, translate(context, 'home', 'review'));
        _btnController.success();
        await Future.delayed(const Duration(milliseconds: 2500));
        _btnController.stop();
      } else {
        _btnController.error();
        await Future.delayed(const Duration(milliseconds: 2500));
        _btnController.stop();
      }
    } catch (e) {
      print(e);
      _btnController.error();
      await Future.delayed(const Duration(milliseconds: 2500));
      _btnController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0.0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: h * 0.2, horizontal: w * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Directionality(
                textDirection: getDirection(),
                child: SimpleStarRating(
                  starCount: 5,
                  rating: 5,
                  allowHalfRating: true,
                  size: w * 0.08,
                  isReadOnly: false,
                  onRated: (rate) {
                    setState(() {
                      stars = rate!;
                    });
                  },
                  spacing: 10,
                ),
              ),

              SizedBox(
                height: h * 0.03,
              ),

              TextFormField(
                cursorColor: Colors.black,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  focusedBorder: form2(),
                  enabledBorder: form2(),
                  errorBorder: form2(),
                  focusedErrorBorder: form2(),
                  hintText: translate(context, 'inputs', 'comment'),
                  hintStyle: const TextStyle(color: Colors.grey),
                  errorMaxLines: 1,
                  errorStyle: TextStyle(fontSize: w * 0.03),
                ),
                onChanged: (val) {
                  setState(() {
                    rating = val;
                  });
                },
              ),

              SizedBox(
                height: h * 0.03,
              ),

              RoundedLoadingButton(
                borderRadius: 15,
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
                  FocusScope.of(context).requestFocus(FocusNode());
                  saveRate();
                },
              ),

              // if (login)
              SizedBox(
                height: h * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputBorder form2() {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: (Colors.grey[350]!), width: 1),
      borderRadius: BorderRadius.circular(25),
    );
  }
}
