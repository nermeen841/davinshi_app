// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:badges/badges.dart';
import 'package:davinshi_app/screens/subcategory_product.dart';
import 'package:flutter/material.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/cat.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/provider/cart_provider.dart';
import 'package:davinshi_app/screens/cart/cart.dart';
import 'package:provider/provider.dart';

class SubCategoriesScreen extends StatefulWidget {
  List<SubCategories> subcategoriesList;
  SubCategoriesScreen({required this.subcategoriesList});
  @override
  _SubCategoriesScreenState createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen>
    with SingleTickerProviderStateMixin {
  int selectedSubCat = 0;
  String subCatId = "0";
  var currency = (prefs.getString('language_code').toString() == 'en')
      ? prefs.getString('currencyEn').toString()
      : prefs.getString('currencyAr').toString();
  TabController? tabController;

  @override
  void initState() {
    if (widget.subcategoriesList.isNotEmpty) {
      setState(() {
        subCatId = widget.subcategoriesList.first.id.toString();
        tabController =
            TabController(length: widget.subcategoriesList.length, vsync: this);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    CartProvider cart = Provider.of<CartProvider>(context, listen: true);
    return Directionality(
      textDirection: getDirection(),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              translate(context, 'multiple', 'title'),
              style: TextStyle(color: Colors.white, fontSize: w * 0.04),
            ),
            centerTitle: true,
            backgroundColor: mainColor,
            leading: const BackButton(
              color: Colors.white,
            ),
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: w * 0.01),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  // child: Icon(Icons.search,color: Colors.white,size: w*0.05,),
                  child: Badge(
                    badgeColor: const Color(0xffFF0921),
                    child: IconButton(
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.zero,
                      focusColor: Colors.white,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Cart()));
                      },
                    ),
                    animationDuration: const Duration(
                      seconds: 2,
                    ),
                    badgeContent: Text(
                      cart.items.length.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: w * 0.03,
                      ),
                    ),
                    position: BadgePosition.topStart(start: w * 0.007),
                  ),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size(w, h * 0.06),
              child: Container(
                height: h * 0.06 + 10,
                padding: const EdgeInsets.only(top: 10),
                color: Colors.white,
                child: TabBar(
                  isScrollable: true,
                  controller: tabController,
                  indicatorColor: Colors.brown.withOpacity(0.8),
                  indicatorWeight: w * 0.01,
                  labelColor: mainColor,
                  unselectedLabelColor: Colors.black45,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: TextStyle(
                      color: mainColor,
                      fontFamily: 'Tajawal',
                      fontSize: w * 0.045),
                  unselectedLabelStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Tajawal',
                      fontSize: w * 0.045),
                  tabs: List.generate(
                    widget.subcategoriesList.length,
                    (index) => Text(
                      prefs.getString('language_code').toString() == 'en'
                          ? widget.subcategoriesList[index].nameEn
                          : widget.subcategoriesList[index].nameAr,
                    ),
                  ),
                ),

            
              ),
            ),
          ),
          body: Padding(
              padding: isLeft()
                  ? EdgeInsets.only(left: w * 0.025)
                  : EdgeInsets.only(right: w * 0.025),
              child: TabBarView(
                controller: tabController,
                children: List.generate(
                  widget.subcategoriesList.length,
                  (index) => SubCategoryProductsList(
                    subcatId: widget.subcategoriesList[index].id.toString(),
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
