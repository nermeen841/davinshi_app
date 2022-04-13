// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:badges/badges.dart';
import 'package:davinshi_app/elements/newtwork_image.dart';
import 'package:davinshi_app/screens/sub_categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:davinshi_app/provider/CatProvider.dart';
import 'package:provider/provider.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/provider/cart_provider.dart';
import 'package:davinshi_app/screens/cart/cart.dart';

class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  int selected = -1;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    CartProvider cart = Provider.of<CartProvider>(context, listen: true);
    CatProvider catProvider = Provider.of<CatProvider>(context, listen: true);
    catProvider.getParentCat().then((value) {});
    catProvider = Provider.of<CatProvider>(context, listen: false);

    return DefaultTabController(
      length: 2,
      child: Directionality(
        textDirection: getDirection(),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              translate(context, 'page_three', 'title'),
              style: TextStyle(color: Colors.white, fontSize: w * 0.04),
            ),
            centerTitle: true,
            backgroundColor: mainColor,
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
          ),
          body: SizedBox(
            width: w,
            height: h,
            child: ListView.builder(
                itemCount: catProvider.categories.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      print(catProvider.categories[index].subCategories.length);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SubCategoriesScreen(
                              subcategoriesList: catProvider
                                  .categories[index].subCategories)));
                    },
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: h * 0.02,
                            bottom: h * 0.05,
                            left: w * 0.02,
                            right: w * 0.02),
                        child: SizedBox(
                            width: w,
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: w * 2.5 / 100,
                                ),
                                // Icon(Icons.menu,color: Colors.black,size: w*0.06,),
                                Container(
                                  width: w,
                                  height: h * 0.3,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(w * 0.05)),
                                  // child: Image.network(categories[i].image,fit: BoxFit.cover,),
                                  child: catProvider.categories[index].image
                                          .contains('.svg')
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(w * 0.05),
                                          child: SvgPicture.network(catProvider
                                              .categories[index].image),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(w * 0.05),
                                          child: ImageeNetworkWidget(
                                            fit: BoxFit.cover,
                                            width: w,
                                            height: h * 0.3,
                                            image: catProvider
                                                .categories[index].image,
                                            // fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: h * 0.24),
                                  child: Container(
                                    height: h * 0.06,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(w * 0.05),
                                          bottomRight:
                                              Radius.circular(w * 0.05),
                                        )),
                                    child: Center(
                                      child: Text(
                                        translateString(
                                            catProvider
                                                .categories[index].nameEn,
                                            catProvider
                                                .categories[index].nameAr),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w * 0.05,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ))),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
