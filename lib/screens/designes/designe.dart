import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/screens/designes/componnent/all_designes.dart';
import 'package:davinshi_app/screens/designes/componnent/send_designe.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/constants.dart';
import '../../provider/best_item.dart';
import '../../provider/fav_pro.dart';
import '../../provider/new_item.dart';
import '../../provider/offer_item.dart';
import '../../provider/recommended_item.dart';

class DesigneScreen extends StatefulWidget {
  const DesigneScreen({Key? key}) : super(key: key);

  @override
  State<DesigneScreen> createState() => _DesigneScreenState();
}

class _DesigneScreenState extends State<DesigneScreen> {
  String lang = '';

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language_code').toString();
    });
  }

  late PageController pageController;
  List<String> contText = [
    "Designe",
    "Send Designe",
  ];

  List<String> contTextAr = [
    "تصاميمكم",
    "أرسل تصاميمك",
  ];

  bool isTapped = true;
  int currentIndex = 0;
  List<Widget> screens = [
    const AllDesignes(),
    const SendDesigneScreen(),
  ];

  @override
  void initState() {
    getLang();
    pageController = PageController(initialPage: currentIndex);
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
        title: (currentIndex == 1)
            ? Text(
                translateString("Our clients' designs", "تصاميم عملائنا"),
                style: TextStyle(
                    fontSize: w * 0.05,
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.bold),
              )
            : Text(
                translateString("Designe", "التصاميم"),
                style: TextStyle(
                    fontSize: w * 0.05,
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.bold),
              ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Provider.of<NewItemProvider>(context, listen: false).getItems();
            Provider.of<FavItemProvider>(context, listen: false).getItems();
            Provider.of<BestItemProvider>(context, listen: false).getItems();
            Provider.of<OfferItemProvider>(context, listen: false).getItems();
            Provider.of<ReItemProvider>(context, listen: false).getItems();
            Navigator.pop(context);
          },
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
        child: Stack(
          children: [
            Container(
              height: h,
              width: w,
              padding: EdgeInsets.only(
                  top: h * 0.07,
                  left: w * 0.02,
                  right: w * 0.02,
                  bottom: h * 0.02),
              margin: EdgeInsets.only(top: h * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(w * 0.05),
                  topRight: Radius.circular(w * 0.05),
                ),
              ),
              child: PageView.builder(
                  itemCount: contText.length,
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return screens[index];
                  }),
            ),
            Padding(
              padding: EdgeInsets.only(top: h * 0.015),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    contText.length, (index) => buildDot(index: index)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 40,
      width: currentIndex == index ? 150 : 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(w * 0.03),
          border: Border.all(
              color: currentIndex == index ? mainColor : Colors.black),
          color: Colors.white),
      child: InkWell(
          onTap: () {
            pageController.animateToPage(index,
                duration: const Duration(microseconds: 500),
                curve: Curves.fastOutSlowIn);
          },
          child: Center(
            child: Text(
              (lang == 'en') ? contText[index] : contTextAr[index],
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Tajawal',
                  fontSize: w * 0.04,
                  color: (currentIndex == index) ? mainColor : Colors.black),
            ),
          )),
    );
  }
}
