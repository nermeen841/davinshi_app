import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/screens/designes/single_designe.dart/all_rates.dart';
import 'package:davinshi_app/screens/designes/single_designe.dart/show_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

import '../../../provider/one_designe.dart';
import '../../auth/login.dart';

class SingleDesigneScreen extends StatefulWidget {
  final String designID;
  const SingleDesigneScreen({Key? key, required this.designID})
      : super(key: key);

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
    Provider.of<OneDesigne>(context, listen: false)
        .getoneDesigne(id: widget.designID);
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
          child: (OneDesigne.oneItemModel!.data!.isNotEmpty)
              ? SingleChildScrollView(
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
                              (OneDesigne.oneItemModel!.data![0].images!
                                      .isNotEmpty)
                                  ? Swiper(
                                      pagination: SwiperPagination(
                                          builder: DotSwiperPaginationBuilder(
                                              color: mainColor.withOpacity(0.3),
                                              activeColor: mainColor),
                                          alignment: Alignment.bottomCenter),
                                      itemBuilder:
                                          (BuildContext context, int i) {
                                        return InkWell(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShowDesigneImage(
                                                          images: OneDesigne
                                                              .oneItemModel!
                                                              .data![0]
                                                              .images!))),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      w * 0.05),
                                              border:
                                                  Border.all(color: mainColor),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    "https://davinshi.net/" +
                                                        OneDesigne
                                                            .oneItemModel!
                                                            .data![0]
                                                            .images![i]
                                                            .src!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: OneDesigne.oneItemModel!
                                          .data![0].images!.length,
                                      autoplay: true,
                                      autoplayDelay: 5000,
                                    )
                                  : Container(
                                      width: double.infinity,
                                      height: h * 0.3,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/logo_multi.png"),
                                            fit: BoxFit.contain),
                                        borderRadius:
                                            BorderRadius.circular(w * 0.05),
                                        border: Border.all(color: mainColor),
                                      ),
                                    ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: h * 0.03, horizontal: w * 0.02),
                                child: Align(
                                  alignment: (lang == 'ar')
                                      ? Alignment.topLeft
                                      : Alignment.topRight,
                                  child: (OneDesigne.oneItemModel!.data![0]
                                              .countRate !=
                                          null)
                                      ? InkWell(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AllRatesScreen(
                                                        designeID: OneDesigne
                                                            .oneItemModel!
                                                            .data![0]
                                                            .id
                                                            .toString(),
                                                      ))),
                                          child: Container(
                                            height: h * 0.04,
                                            width: w * 0.2,
                                            decoration: BoxDecoration(
                                                color: mainColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        w * 0.01)),
                                            child: Center(
                                              child: Text(
                                                "${OneDesigne.oneItemModel!.data![0].countRate.toString().substring(0, 1).toString()} + تقييم",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Tajawal',
                                                    fontSize: w * 0.03,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
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
                            "${OneDesigne.oneItemModel!.data![0].note}",
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
                            (lang == 'en')
                                ? "Write comment"
                                : "اترك تعليق من فضلك",
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never),
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
                            if (login) {
                              addRate(
                                  controller: btnController,
                                  rating: ratingVal,
                                  comment: comment.text,
                                  context: context,
                                  designeID: OneDesigne
                                      .oneItemModel!.data![0].id
                                      .toString());
                            } else {
                              btnController.error();
                              await Future.delayed(const Duration(seconds: 1));
                              btnController.stop();
                              final snackBar = SnackBar(
                                content: Text(
                                    translate(context, 'snack_bar', 'login')),
                                action: SnackBarAction(
                                  label: translate(context, 'buttons', 'login'),
                                  disabledTextColor: Colors.yellow,
                                  textColor: Colors.yellow,
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Login()),
                                        (route) => false);
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: mainColor,
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
