// ignore_for_file: use_key_in_widget_constructors, avoid_function_literals_in_foreach_calls

import 'package:badges/badges.dart';
import 'package:davinshi_app/BottomNavWidget/search_data.dart';
import 'package:davinshi_app/elements/newtwork_image.dart';
import 'package:davinshi_app/screens/sub_categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:davinshi_app/provider/CatProvider.dart';
import 'package:provider/provider.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/cat.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/provider/cart_provider.dart';
import 'package:davinshi_app/provider/package_provider.dart';
import 'package:davinshi_app/screens/cart/cart.dart';

class PageFour extends StatefulWidget {
  @override
  _PageFourState createState() => _PageFourState();
}

class _PageFourState extends State<PageFour> {
  bool isSearching = false;
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    CartProvider cart = Provider.of<CartProvider>(context, listen: true);
    CatProvider catProvider = Provider.of<CatProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: showExitPopup,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              translate(context, 'page_four', 'title'),
              style: TextStyle(color: Colors.white, fontSize: w * 0.04),
            ),
            centerTitle: true,
            backgroundColor: mainColor,
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: w * 0.01),
                child: Padding(
                  padding: const EdgeInsets.all(5),
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
              if (login)
                SizedBox(
                  width: w * 0.05,
                ),
            ],
          ),
          body: Center(
            child: SizedBox(
              width: w,
              height: h,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(w * 0.06),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.search,
                        controller: search,
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();

                          setState(() {
                            isSearching = true;
                          });
                          if (search.text.isEmpty) {
                            setState(() {
                              isSearching = false;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          focusedBorder: form(),
                          enabledBorder: form(),
                          errorBorder: form(),
                          focusedErrorBorder: form(),
                          filled: true,
                          fillColor: Colors.grey[200],
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          hintText:
                              translate(context, 'inputs', 'find_product'),
                          hintStyle: const TextStyle(color: Colors.grey),
                        ),
                        onChanged: (val) {
                          setState(() {
                            isSearching = true;
                          });
                          if (search.text.isEmpty) {
                            setState(() {
                              isSearching = false;
                            });
                          }

                          List<SubCategories> _subCat = [];
                          if (val.isEmpty || val == '') {
                            setState(() {
                              catProvider.sub = catProvider.allSub;
                            });
                          } else {
                            catProvider.allSub.forEach((e) {
                              if (e.nameEn.toLowerCase().contains(val) ||
                                  e.nameAr.toUpperCase().contains(val)) {
                                _subCat.add(e);
                              }
                            });
                            setState(() {
                              catProvider.sub = _subCat;
                            });
                          }
                        },
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(
                        height: h * 0.03,
                      ),
                      // Text(
                      //   translate(context, 'page_four', 'sub_title'),
                      //   style: TextStyle(
                      //       color: Colors.grey[400], fontSize: w * 0.035),
                      // ),
                      if (isSearching) SearchDataScreen(keyword: search.text),
                      // if (login && !isSearching) SearchPaginate(),
                      if (!isSearching)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(catProvider.categories.length,
                              (index) {
                            var _sub = catProvider.categories[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: h * 0.01),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: w * 0.1,
                                          height: w * 0.1,
                                          child: _sub.image.contains('.svg')
                                              ? SvgPicture.network(_sub.image)
                                              : ImageeNetworkWidget(
                                                  image: _sub.image,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        SizedBox(
                                          width: w * 2.5 / 100,
                                        ),
                                        Text(
                                          translateString(
                                              _sub.nameEn, _sub.nameAr),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: w * 0.04),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    dialog(context);
                                    Provider.of<NewPackageItemProvider>(context,
                                            listen: false)
                                        .clearList();
                                    await Provider.of<NewPackageItemProvider>(
                                            context,
                                            listen: false)
                                        .getItems(_sub.id);
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SubCategoriesScreen(
                                                    subcategoriesList:
                                                        catProvider
                                                            .categories[index]
                                                            .subCategories)));
                                  },
                                ),
                                Divider(
                                  color: Colors.grey[200],
                                  thickness: h * 0.002,
                                ),
                              ],
                            );
                          }),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputBorder form() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[200]!),
      borderRadius: BorderRadius.circular(5),
    );
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(''),
            content: Text(translate(context, 'home', 'ok_mess')),
            actions: [
              // ignore: deprecated_member_use
              RaisedButton(
                color: mainColor,
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  translate(context, 'home', 'no'),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              // ignore: deprecated_member_use
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
}
