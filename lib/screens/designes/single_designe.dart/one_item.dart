import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/screens/designes/single_designe.dart/all_rates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

class SingleDesigneScreen extends StatefulWidget {
  const SingleDesigneScreen({Key? key}) : super(key: key);

  @override
  State<SingleDesigneScreen> createState() => _SingleDesigneScreenState();
}

class _SingleDesigneScreenState extends State<SingleDesigneScreen> {
  String lang = '';
  double ratingVal = 0;
  final formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  TextEditingController comment = TextEditingController();

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language_code').toString();
    });
  }

  @override
  void initState() {
    getLang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Text(
          (lang == 'en') ? "Designer name" : "اسم المصمم",
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
            margin:
                EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.017),
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
      body: Directionality(
        textDirection: getDirection(),
        child: Container(
          height: h,
          width: w,
          padding:
              EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.05),
          margin: EdgeInsets.only(top: h * 0.04),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(w * 0.05),
              topRight: Radius.circular(w * 0.05),
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: h * 0.3,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Swiper(
                          pagination: SwiperPagination(
                              builder: DotSwiperPaginationBuilder(
                                  color: mainColor.withOpacity(0.3),
                                  activeColor: mainColor),
                              alignment: Alignment.bottomCenter),
                          itemBuilder: (BuildContext context, int i) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(w * 0.05),
                                border: Border.all(color: mainColor),
                                image: const DecorationImage(
                                  image:
                                      AssetImage("assets/images/asset-3.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                          itemCount: 3,
                          autoplay: true,
                          autoplayDelay: 5000,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: h * 0.03, horizontal: w * 0.02),
                          child: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AllRatesScreen())),
                            child: Align(
                              alignment: (lang == 'ar')
                                  ? Alignment.topLeft
                                  : Alignment.topRight,
                              child: Container(
                                height: h * 0.04,
                                width: w * 0.2,
                                decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius:
                                        BorderRadius.circular(w * 0.01)),
                                child: Center(
                                  child: Text(
                                    "50 + تقييم",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Tajawal',
                                        fontSize: w * 0.03,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  SizedBox(
                    width: w * 0.8,
                    child: Text(
                      "تصميم فستان عصري بالوان متناسقة مناسب للأعمار من 20 الي 35",
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: w * 0.04,
                          color: const Color(0xff040300),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.05,
                  ),
                  Center(
                    child: Text(
                      (lang == 'en') ? "Rate designe" : "اترك تقييمك",
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: w * 0.05,
                          color: const Color(0xff040300),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  Center(
                    child: SimpleStarRating(
                      isReadOnly: false,
                      starCount: 5,
                      rating: ratingVal,
                      size: w * 0.1,
                      allowHalfRating: true,
                      filledIcon: Icon(
                        Icons.star,
                        color: mainColor,
                        size: w * 0.1,
                      ),
                      onRated: (value) {
                        setState(() {
                          ratingVal = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: h * 0.03,
                  ),
                  Center(
                    child: Text(
                      (lang == 'en') ? "Write comment" : "اترك تعليق من فضلك",
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: w * 0.05,
                          color: const Color(0xff040300),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    cursorColor: Colors.grey,
                    controller: comment,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                        hintText: '',
                        hintStyle: TextStyle(
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        border: form(),
                        focusedBorder: form(),
                        errorBorder: form(),
                        enabledBorder: form(),
                        disabledBorder: form(),
                        floatingLabelBehavior: FloatingLabelBehavior.never),
                  ),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  RoundedLoadingButton(
                    borderRadius: w * 0.03,
                    child: SizedBox(
                      width: w * 0.6,
                      height: h * 0.07,
                      child: Center(
                          child: Text(
                        translate(context, 'buttons', 'send'),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: w * 0.05,
                            fontFamily: 'Tajawal'),
                      )),
                    ),
                    controller: btnController,
                    successColor: mainColor,
                    color: mainColor,
                    disabledColor: mainColor,
                    errorColor: Colors.red,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                      } else {
                        btnController.error();
                        await Future.delayed(const Duration(seconds: 2));
                        btnController.stop();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputBorder form() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.5),
      borderRadius: BorderRadius.circular(w * 0.03),
    );
  }
}
