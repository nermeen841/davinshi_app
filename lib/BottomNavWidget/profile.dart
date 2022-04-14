// ignore_for_file: empty_catches, deprecated_member_use, avoid_print
import 'dart:io';
import 'package:davinshi_app/screens/about%20multi/about_multi.dart';
import 'package:davinshi_app/screens/auth/login.dart';
import 'package:davinshi_app/screens/designes/designe.dart';
import 'package:davinshi_app/screens/update_profile/profile_setting.dart';
import 'package:davinshi_app/screens/update_profile/user_lang.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:davinshi_app/screens/cart/orders.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/screens/about.dart';
import 'package:davinshi_app/screens/address/address.dart';
import 'package:davinshi_app/screens/auth/country.dart';
import 'package:davinshi_app/screens/contac_us.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

import '../provider/best_item.dart';
import '../provider/fav_pro.dart';
import '../provider/home.dart';
import '../provider/new_item.dart';
import '../provider/offer_item.dart';
import '../provider/recommended_item.dart';
import '../provider/social.dart';
import '../screens/home_folder/home_page.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final RoundedLoadingButtonController controller =
      RoundedLoadingButtonController();
  double ratingValue = 0;
  final InAppReview inAppReview = InAppReview.instance;
  final List<Tile> tile = login
      ? [
          Tile(
              nameAr: 'عناويني',
              nameEn: 'My address',
              image: 'assets/icons/FeatherIconSet-Feather_Maps-map-pin.png',
              className: Address()),
          Tile(
              nameAr: 'اللغة',
              nameEn: 'Language',
              image: 'assets/images/Group 1088.png',
              className: const UserLanguageScreen()),
          Tile(
              nameAr: 'الدول',
              nameEn: 'Country',
              image: 'assets/images/Group 1101.png',
              className: Country(2)),
          Tile(
              nameAr: 'تصاميمكم',
              nameEn: 'Your Designe',
              image: 'assets/images/ي77.png',
              className: const DesigneScreen()),
          Tile(
              nameAr: 'تواصل معنا',
              nameEn: 'Contact us',
              image: 'assets/images/Group 1098.png',
              className: ContactUs()),
          Tile(
              nameAr: 'حول مالتي',
              nameEn: 'About Multi',
              image: 'assets/images/Group 1095.png',
              className: const AboutMultiScreen()),
          Tile(
              nameAr: 'المساعدة',
              nameEn: 'Information',
              keyApi: 'information',
              image: 'assets/images/Group 1099.png',
              className: AboutUs('Information')),
          Tile(
            nameAr: 'تقييم التطبيق',
            nameEn: 'App rate',
            keyApi: 'question',
            image: 'assets/images/Group 1097.png',
            className: const SizedBox(),
          ),
          Tile(
            nameAr: 'تسجيل خروج',
            nameEn: 'Sign out',
            image: 'assets/icons/FeatherIconSet-Feather_Controls-upload.png',
            className: const SizedBox(),
          ),
        ]
      : [
          Tile(
              nameAr: 'اللغة',
              nameEn: 'Language',
              image: 'assets/images/Group 1088.png',
              className: const UserLanguageScreen()),
          Tile(
              nameAr: 'الدول',
              nameEn: 'Country',
              image: 'assets/images/Group 1101.png',
              className: Country(2)),
          Tile(
              nameAr: 'تصاميمكم',
              nameEn: 'Your Designe',
              image: 'assets/images/ي77.png',
              className: const DesigneScreen()),
          Tile(
              nameAr: 'تواصل معنا',
              nameEn: 'Contact us',
              image: 'assets/images/Group 1098.png',
              className: ContactUs()),
          Tile(
              nameAr: 'حول مالتي',
              nameEn: 'About Multi',
              image: 'assets/images/Group 1095.png',
              className: const AboutMultiScreen()),
          Tile(
              nameAr: 'المساعدة',
              nameEn: 'Information',
              keyApi: 'information',
              image: 'assets/images/Group 1099.png',
              className: AboutUs('Information')),
          Tile(
            nameAr: 'تقييم التطبيق',
            nameEn: 'App rate',
            keyApi: 'question',
            image: 'assets/images/Group 1097.png',
            className: const SizedBox(),
          ),
        ];

  Future<bool> logOutUser() async {
    final String url = domain + 'logout';
    try {
      await Dio().post(
        url,
        options: Options(headers: {"auth-token": auth}),
      );
      return true;
    } catch (e) {}
    return false;
  }

  Future getProfile() async {
    final String url = domain + 'profile';
    try {
      Response response = await Dio().get(
        url,
        options: Options(headers: {"auth-token": auth}),
      );
      print(response.data);
      if (response.statusCode == 200 && response.data['name'] is String) {
        Map userData = response.data;
        user = UserClass(
          id: userData['id'],
          name: userData['name'],
          phone: userData['phone'],
          email: userData['email'],
          userName: userData['surname'],
          image: userData['img'],
          gender: userData['gender'],
          birthday: userData['birth_day'],
        );
        setUserId(userData['id']);
        setState(() {
          userName = response.data['name'];
          userEmail = response.data['email'];
          userImage = response.data['img'];
          userPhone = response.data['phone'];
          gender = response.data['gender'];
          familyName = response.data['surname'];
          birthday = response.data['birth_day'];
        });
      } else {
        Map userData = response.data;
        user = UserClass(
          id: userData['id'],
          name: userData['name'],
          phone: userData['phone'],
          email: userData['email'],
          userName: userData['surname'],
          image: userData['img'],
          gender: userData['gender'],
          birthday: userData['birth_day'],
        );
        setUserId(userData['id']);
        setState(() {
          userName = response.data['name'];
          userEmail = response.data['email'];
          userImage = response.data['user']['img'];
        });
      }
    } catch (e) {}
  }

  late File image;
  String image1 = "";

  Future getImage() async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image1 = pickedFile.path;
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Directionality(
        textDirection: getDirection(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: h * 0.2,
                    color: mainColor,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: h * 0.13, left: w * 0.02, right: w * 0.02),
                    child: Container(
                      width: double.infinity,
                      height: h * 0.28,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(w * 0.05),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                offset: const Offset(0, 3),
                                blurRadius: 3,
                                spreadRadius: 3)
                          ]),
                      child: Padding(
                        padding: EdgeInsets.only(top: h * 0.13),
                        child: Column(
                          children: [
                            if (userName != null)
                              Center(
                                child: Text(
                                  userName!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: w * 0.05,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            if (userName == null)
                              InkWell(
                                onTap: () => Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Country(1)),
                                    (route) => false),
                                child: Center(
                                  child: Text(
                                    isLeft() ? 'Login' : 'تسجيل دخول',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: w * 0.06,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: h * 0.02,
                            ),
                            Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (login) {
                                        navP(context, const Orders());
                                      } else {
                                        final snackBar = SnackBar(
                                          content: Text(translate(
                                              context, 'snack_bar', 'login')),
                                          action: SnackBarAction(
                                            label: translate(
                                                context, 'buttons', 'login'),
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
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: h * 0.035,
                                          child: Image.asset(
                                            'assets/images/Group 1102.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        SizedBox(
                                          height: h * 0.01,
                                        ),
                                        Text(
                                          (language == 'en')
                                              ? 'My Orders'
                                              : 'طلباتي',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: w * 0.04,
                                              fontFamily: 'Tajawal',
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (login) {
                                        Provider.of<NewItemProvider>(context,
                                                listen: false)
                                            .getItems();
                                        Provider.of<FavItemProvider>(context,
                                                listen: false)
                                            .getItems();
                                        Provider.of<BestItemProvider>(context,
                                                listen: false)
                                            .getItems();
                                        Provider.of<OfferItemProvider>(context,
                                                listen: false)
                                            .getItems();
                                        Provider.of<ReItemProvider>(context,
                                                listen: false)
                                            .getItems();
                                        Provider.of<BottomProvider>(context,
                                                listen: false)
                                            .setIndex(1);
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) => Home())),
                                            (route) => false);
                                      } else {
                                        final snackBar = SnackBar(
                                          content: Text(translate(
                                              context, 'snack_bar', 'login')),
                                          action: SnackBarAction(
                                            label: translate(
                                                context, 'buttons', 'login'),
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
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: h * 0.035,
                                          child: Image.asset(
                                            'assets/images/Group 1103.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        SizedBox(
                                          height: h * 0.01,
                                        ),
                                        Text(
                                          (language == 'en')
                                              ? 'My favourite'
                                              : 'مفضلتي',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: w * 0.04,
                                              fontFamily: 'Tajawal',
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      if (login) {
                                        getProfile();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: ((context) =>
                                                ProfileSettingScreen()),
                                          ),
                                        );
                                      } else {
                                        final snackBar = SnackBar(
                                          content: Text(translate(
                                              context, 'snack_bar', 'login')),
                                          action: SnackBarAction(
                                            label: translate(
                                                context, 'buttons', 'login'),
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
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: h * 0.035,
                                          child: Image.asset(
                                            'assets/images/Group 1104.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        SizedBox(
                                          height: h * 0.01,
                                        ),
                                        Text(
                                          (language == 'en')
                                              ? 'Update profile'
                                              : 'تحديث الحساب',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: w * 0.04,
                                              fontFamily: 'Tajawal',
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.05),
                    child: Center(
                      child: CircleAvatar(
                        child: (userImage == null)
                            ? InkWell(
                                onTap: () async {
                                  if (login) {
                                    await getImage();
                                    updateProfileImage(
                                            context: context, image: image1)
                                        .then((value) {
                                      getProfile();
                                    });
                                  } else {
                                    final snackBar = SnackBar(
                                      content: Text(translate(
                                          context, 'snack_bar', 'login')),
                                      action: SnackBarAction(
                                        label: translate(
                                            context, 'buttons', 'login'),
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
                                child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Center(
                                      child: Icon(
                                        Icons.insert_photo_outlined,
                                        size: w * 0.15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    radius: w * 0.13),
                              )
                            : InkWell(
                                onTap: () async {
                                  if (login) {
                                    await getImage();
                                    updateProfileImage(
                                            context: context, image: image1)
                                        .then((value) {
                                      getProfile();
                                    });
                                  } else {
                                    final snackBar = SnackBar(
                                      content: Text(translate(
                                          context, 'snack_bar', 'login')),
                                      action: SnackBarAction(
                                        label: translate(
                                            context, 'buttons', 'login'),
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
                                child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(
                                        "https://davinshi.net/" + userImage!),
                                    radius: w * 0.13),
                              ),
                        backgroundColor: mainColor,
                        radius: w * 0.15,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: h * 0.01,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(tile.length, (i) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: h * 0.02),
                        child: Column(
                          children: [
                            ListTile(
                              leading: SizedBox(
                                width: w * 0.07,
                                height: w * 0.07,
                                child: Image.asset(
                                  tile[i].image,
                                  fit: BoxFit.contain,
                                  color: Colors.black,
                                ),
                              ),
                              trailing: (prefs
                                          .getString('language_code')
                                          .toString() ==
                                      'en')
                                  ? const Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.black,
                                    )
                                  : const Icon(
                                      Icons.keyboard_arrow_left,
                                      color: Colors.black,
                                    ),
                              title: Text(
                                isLeft() ? tile[i].nameEn : tile[i].nameAr,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: w * 0.05,
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () async {
                                if (tile[i].nameEn == 'Edit Profile') {
                                  getProfile();
                                } else if (tile[i].nameEn == 'My address') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Address()));
                                } else if (tile[i].nameEn == 'Sign out') {
                                  dialog(context);
                                  prefs.setBool('login', false);
                                  userName = null;
                                  await prefs.setString('userName', 'Guest');
                                  prefs.setInt('id', 0);
                                  prefs.setString('auth', '');
                                  setUserId(0);
                                  setAuth('');
                                  setLogin(false);
                                  await prefs.setBool('login', false);
                                  logOutUser();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Country(1)),
                                      (route) => false);
                                } else if (tile[i].nameEn == 'Your Designe') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const DesigneScreen()));
                                } else if (tile[i].nameEn == 'Language') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const UserLanguageScreen()));
                                } else if (tile[i].nameEn == 'Country') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Country(2)));
                                } else if (tile[i].nameEn == 'App rate') {
                                  if (Platform.isAndroid) {
                                    showRequestDialog();
                                  } else {
                                    inAppReview.openStoreListing(
                                        appStoreId: '');
                                  }
                                } else if (tile[i].nameEn == 'Share App') {
                                  // navPRRU(context, const Country(1));
                                } else if (tile[i].nameEn == 'About Multi') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AboutMultiScreen()));
                                } else if (tile[i].nameEn == 'Contact us') {
                                  SocialIcons().getSocialIcons().then((value) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ContactUs()));
                                  });
                                } else {
                                  if (tile[i].keyApi != null) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => AboutUs(
                                                  isLeft()
                                                      ? tile[i].nameEn
                                                      : tile[i].nameAr,
                                                  apiKey: tile[i].keyApi,
                                                )));
                                  }
                                }
                              },
                            ),
                            Divider(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(''),
            content: Text(translate(context, 'home', 'ok_mess')),
            actions: [
              RaisedButton(
                color: mainColor,
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  translate(context, 'home', 'no'),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              RaisedButton(
                color: mainColor,
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  translate(context, 'home', 'yes'),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> showAppRatingDialog({
    required BuildContext context,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.clear,
                      color: mainColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                Center(
                  child: Text(translate(context, 'alert', 'title')),
                ),
                SizedBox(
                  height: h * 0.03,
                ),
                SimpleStarRating(
                  starCount: 5,
                  rating: ratingValue,
                  allowHalfRating: true,
                  size: w * 0.08,
                  isReadOnly: false,
                  onRated: (rate) {
                    setState(() {
                      ratingValue = rate!;
                    });
                  },
                  spacing: 10,
                ),
                // if (login)
                SizedBox(
                  height: h * 0.03,
                ),
                // if (login)
                TextFormField(
                  cursorColor: Colors.black,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    focusedBorder: form2(),
                    enabledBorder: form2(),
                    errorBorder: form2(),
                    focusedErrorBorder: form2(),
                    hintText: translate(context, 'alert', 'app_rate'),
                    hintStyle: const TextStyle(color: Colors.grey),
                    errorMaxLines: 1,
                    errorStyle: TextStyle(fontSize: w * 0.03),
                  ),
                  onChanged: (val) {},
                ),
                // if (login)
                SizedBox(
                  height: h * 0.03,
                ),
                // if (login)
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
                  controller: controller,
                  successColor: mainColor,
                  color: mainColor,
                  disabledColor: mainColor,
                  onPressed: () async {
                    if (login) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      // saveRate();
                    } else {
                      final snackBar = SnackBar(
                        content: Text(translate(context, 'snack_bar', 'login')),
                        action: SnackBarAction(
                          label: translate(context, 'buttons', 'login'),
                          disabledTextColor: Colors.yellow,
                          textColor: Colors.yellow,
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()),
                                (route) => false);
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      controller.error();
                      Future.delayed(const Duration(seconds: 1));
                      controller.stop();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showRequestDialog() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview().then((value) {
        inAppReview.openStoreListing(
          appStoreId: "com.konoz.konoz",
        );
      }).catchError((err) {
        error(context);
      });
    }
  }

  InputBorder form2() {
    return UnderlineInputBorder(
      borderSide: BorderSide(color: (Colors.grey[350]!), width: 1),
      borderRadius: BorderRadius.circular(25),
    );
  }
}

class Tile {
  String nameAr;
  String nameEn;
  String image;
  String? keyApi;
  Widget className;
  Tile(
      {required this.nameAr,
      this.keyApi,
      required this.nameEn,
      required this.image,
      required this.className});
}
