// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:badges/badges.dart';
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
    CatProvider catProvider = Provider.of<CatProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: showExitPopup,
      child: DefaultTabController(
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
                // automaticallyImplyLeading: false,
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: w * 0.01),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      // child: Icon(Icons.search,color: Colors.white,size: w*0.05,),
                      child: Badge(
                        badgeColor: mainColor,
                        child: IconButton(
                          icon: const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.zero,
                          focusColor: Colors.white,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Cart()));
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
                  // if (login)
                  //   SizedBox(
                  //     width: w * 0.05,
                  //   ),
                  // if (login)
                  //   IconButton(
                  //     icon: const Icon(Icons.location_on_outlined),
                  //     iconSize: w * 0.06,
                  //     color: Colors.white,
                  //     padding: EdgeInsets.zero,
                  //     onPressed: () {
                  //       Navigator.push(context,
                  //           MaterialPageRoute(builder: (ctx) => Address()));
                  //     },
                  //   ),
                  // SizedBox(
                  //   width: w * 0.02,
                  // ),
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
                          print(catProvider
                              .categories[index].subCategories.length);
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
                                                  BorderRadius.circular(
                                                      w * 0.05),
                                              child: SvgPicture.network(
                                                  catProvider
                                                      .categories[index].image),
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      w * 0.05),
                                              child: Image.network(
                                                catProvider
                                                    .categories[index].image,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: h * 0.24),
                                      child: Container(
                                        height: h * 0.06,
                                        color: Colors.white54,
                                        child: Center(
                                          child: Text(
                                            translateString(
                                                catProvider
                                                    .categories[index].nameEn,
                                                catProvider
                                                    .categories[index].nameAr),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: w * 0.05,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ))),
                      );
                      // ExpansionPanelList(
                      //   expandedHeaderPadding:
                      //       const EdgeInsets.only(top: 0, bottom: 0),
                      //   expansionCallback: (i, ex) {
                      //     if (selected == i) {
                      //       setState(() {
                      //         selected = -1;
                      //       });
                      //     } else {
                      //       setState(() {
                      //         selected = i;
                      //       });
                      //     }
                      //   },
                      //   children:
                      //       List.generate(catProvider.categories.length, (i) {
                      //     return ExpansionPanel(
                      //         headerBuilder: (context, bool isExpanded) {
                      //           return InkWell(
                      //             onTap: () {
                      //               if (selected == i) {
                      //                 setState(() {
                      //                   selected = -1;
                      //                 });
                      //               } else {
                      //                 setState(() {
                      //                   selected = i;
                      //                 });
                      //               }
                      //             },
                      //             child: Row(
                      //               mainAxisAlignment: MainAxisAlignment.start,
                      //               children: [
                      //                 SizedBox(
                      //                   width: w * 2.5 / 100,
                      //                 ),
                      //                 // Icon(Icons.menu,color: Colors.black,size: w*0.06,),
                      //                 SizedBox(
                      //                   width: w * 0.1,
                      //                   height: w * 0.1,
                      //                   // child: Image.network(categories[i].image,fit: BoxFit.cover,),
                      //                   child: catProvider.categories[i].image
                      //                           .contains('.svg')
                      //                       ? SvgPicture.network(
                      //                           catProvider.categories[i].image)
                      //                       : Image.network(
                      //                           catProvider.categories[i].image,
                      //                           fit: BoxFit.cover,
                      //                         ),
                      //                 ),
                      //                 SizedBox(
                      //                   width: w * 2.5 / 100,
                      //                 ),
                      //                 Text(
                      //                   translateString(
                      //                       catProvider.categories[i].nameEn,
                      //                       catProvider.categories[i].nameAr),
                      //                   style: TextStyle(
                      //                       color: Colors.black,
                      //                       fontSize: w * 0.04),
                      //                 ),
                      //               ],
                      //             ),
                      //           );
                      //         },
                      //         body: Container(
                      //           width: w,
                      //           color: catProvider
                      //                   .categories[i].subCategories.isNotEmpty
                      //               ? Colors.grey[200]
                      //               : Colors.white,
                      //           child: Padding(
                      //             padding: EdgeInsets.symmetric(
                      //                 horizontal: w * 0.05),
                      //             child: catProvider.categories[i].subCategories
                      //                     .isNotEmpty
                      //                 ? Column(
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.start,
                      //                     children: List.generate(
                      //                         catProvider
                      //                             .categories[i]
                      //                             .subCategories
                      //                             .length, (index) {
                      //                       return InkWell(
                      //                         child: SizedBox(
                      //                           width: w,
                      //                           child: Padding(
                      //                             padding: EdgeInsets.symmetric(
                      //                                 vertical: h * 0.01,
                      //                                 horizontal: w * 0.01),
                      //                             child: Row(
                      //                               children: [
                      //                                 SizedBox(
                      //                                   width: w * 0.1,
                      //                                   height: w * 0.1,
                      //                                   // child: SvgPicture.network(categories[i].subCategories[index].image),
                      //                                   child: catProvider
                      //                                           .categories[i]
                      //                                           .subCategories[
                      //                                               index]
                      //                                           .image
                      //                                           .contains(
                      //                                               '.svg')
                      //                                       ? SvgPicture.network(
                      //                                           catProvider
                      //                                               .categories[
                      //                                                   i]
                      //                                               .subCategories[
                      //                                                   index]
                      //                                               .image)
                      //                                       : Image.network(
                      //                                           catProvider
                      //                                               .categories[
                      //                                                   i]
                      //                                               .subCategories[
                      //                                                   index]
                      //                                               .image,
                      //                                           fit: BoxFit
                      //                                               .cover,
                      //                                         ),
                      //                                 ),
                      //                                 SizedBox(
                      //                                   width: w * 2.5 / 100,
                      //                                 ),
                      //                                 Text(
                      //                                   translateString(
                      //                                       catProvider
                      //                                           .categories[i]
                      //                                           .subCategories[
                      //                                               index]
                      //                                           .nameEn,
                      //                                       catProvider
                      //                                           .categories[i]
                      //                                           .subCategories[
                      //                                               index]
                      //                                           .nameAr),
                      //                                   style: TextStyle(
                      //                                     color: Colors.black,
                      //                                     fontSize: w * 0.04,
                      //                                   ),
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                           ),
                      //                         ),
                      //                         onTap: () async {
                      //                           // dialog(context);
                      //                           Provider.of<NewPackageItemProvider>(
                      //                                   context,
                      //                                   listen: false)
                      //                               .clearList();
                      //                           // Provider.of<RePackageItemProvider>(context,listen: false).clearList();
                      //                           // Provider.of<BestPackageItemProvider>(context,listen: false).clearList();
                      //                           await Provider.of<
                      //                                       NewPackageItemProvider>(
                      //                                   context,
                      //                                   listen: false)
                      //                               .getItems(catProvider
                      //                                   .categories[i]
                      //                                   .subCategories[index]
                      //                                   .id);
                      //                           Navigator.of(context).push(
                      //                               MaterialPageRoute(
                      //                                   builder: (context) =>
                      //                                       SubCategoriesScreen(
                      //                                           subcategoriesList:
                      //                                               catProvider
                      //                                                   .categories[
                      //                                                       i]
                      //                                                   .subCategories)));
                      //                           // Navigator.pushReplacement(context,
                      //                           //     MaterialPageRoute(builder:
                      //                           //         (ctx)=>MultiplePackages(id
                      //                           //             : catProvider.categories[i].subCategories[index].id,)));
                      //                         },
                      //                         highlightColor: Colors.grey,
                      //                         splashColor: Colors.grey,
                      //                         focusColor: Colors.grey,
                      //                         hoverColor: Colors.grey,
                      //                         overlayColor:
                      //                             MaterialStateProperty.all(
                      //                                 Colors.grey),
                      //                       );
                      //                     }),
                      //                   )
                      //                 : Center(
                      //                     child: Text(
                      //                       translate(context, 'empty',
                      //                           'no_products'),
                      //                       style: TextStyle(
                      //                           color: mainColor,
                      //                           fontSize: w * 0.05),
                      //                     ),
                      //                   ),
                      //           ),
                      //         ),
                      //         isExpanded: selected != i ? false : true);
                    }),
              ),
            ),
          )),
    );
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(translate(context, 'home', 'exit_app')),
            content: Text(translate(context, 'home', 'ok_mess')),
            actions: [
              // ignore: deprecated_member_use
              RaisedButton(
                color: mainColor,
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(translate(context, 'home', 'no')),
              ),
              // ignore: deprecated_member_use
              RaisedButton(
                color: mainColor,
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(translate(context, 'home', 'yes')),
              ),
            ],
          ),
        ) ??
        false;
  }
}
