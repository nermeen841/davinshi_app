// ignore_for_file: use_key_in_widget_constructors, avoid_function_literals_in_foreach_calls, avoid_print

import 'package:badges/badges.dart';
import 'package:davinshi_app/elements/newtwork_image.dart';
import 'package:davinshi_app/models/brands_search.dart';
import 'package:davinshi_app/models/search_model.dart';
import 'package:davinshi_app/provider/student_provider.dart';
import 'package:davinshi_app/screens/product_info/products.dart';
import 'package:davinshi_app/screens/sub_categories_screen.dart';
import 'package:dio/dio.dart';
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

import '../provider/student_product.dart';
import '../screens/student/student_info.dart';
import '../screens/student/view_all.dart';

class PageFour extends StatefulWidget {
  @override
  _PageFourState createState() => _PageFourState();
}

class _PageFourState extends State<PageFour> {
  bool isSearching = false;
  String? search;
  int page = 1;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;
  List searchData = [];
  // This function will be called when the app launches (see the initState function)
  void firstLoad({required String keyword}) async {
    setState(() {
      isFirstLoadRunning = true;
      searchData = [];
    });
    try {
      final String url = domain + "search";
      Map data = {"text": keyword};
      Response response = await Dio().post(url,
          queryParameters: {'page': page},
          data: data,
          options: Options(headers: {
            'auth-token': (login) ? auth : '',
          }));
      print("''''''''''''''''''''''''''''''''''''''''''''''''");
      print(response.data);
      searchData = [];
      if (response.data['status'] == 1) {
        if (ViewAll.brandsSearch) {
          BrandsSearchModel brandsSearchModel =
              BrandsSearchModel.fromJson(response.data);
          setState(() {
            searchData = brandsSearchModel.orders!.brands!;
          });
        } else {
          SearchModel searchModel = SearchModel.fromJson(response.data);
          // searchData = searchModel.orders!.categories!;

          if (searchModel.orders!.product!.data!.isNotEmpty) {
            setState(() {
              searchData = searchModel.orders!.product!.data!;
            });
          }
        }
      }
    } catch (err) {
      print(err.toString());
    }

    setState(() {
      isFirstLoadRunning = false;
    });
  }

  void loadMore() async {
    if (hasNextPage == true &&
        isFirstLoadRunning == false &&
        isLoadMoreRunning == false &&
        _controller.position.extentAfter < 400) {
      setState(() {
        isLoadMoreRunning = true;
        page++;
      });
      // Increase _page by 1
      try {
        final String url = domain + "search";
        Map data = {"text": search};
        Response response = await Dio().post(url,
            queryParameters: {'page': page},
            data: data,
            options: Options(headers: {
              'auth-token': (login) ? auth : '',
            }));

        if (ViewAll.brandsSearch) {
          BrandsSearchModel brandsSearchModel =
              BrandsSearchModel.fromJson(response.data);
          List fetchedBrands = [];
          if (brandsSearchModel.orders!.brands!.isNotEmpty) {
            setState(() {
              fetchedBrands = brandsSearchModel.orders!.brands!;
            });
          }
          if (fetchedBrands.isNotEmpty) {
            setState(() {
              searchData.addAll(fetchedBrands);
            });
          } else {
            setState(() {
              hasNextPage = false;
            });
          }
        } else {
          SearchModel searchModel = SearchModel.fromJson(response.data);
          List fetchedPosts = [];
          if (searchModel.orders!.product!.data!.isNotEmpty) {
            setState(() {
              fetchedPosts = searchModel.orders!.product!.data!;
            });
          }
          if (fetchedPosts.isNotEmpty) {
            setState(() {
              searchData.addAll(fetchedPosts);
            });
          } else {
            setState(() {
              hasNextPage = false;
            });
          }
        }
      } catch (err) {
        print(err.toString());
      }

      setState(() {
        isLoadMoreRunning = false;
      });
    }
  }

  late ScrollController _controller;
  @override
  void initState() {
    firstLoad(keyword: '');
    _controller = ScrollController()..addListener(loadMore);
    super.initState();
  }

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
          backgroundColor: Colors.white,
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
                        // onEditingComplete: () {
                        //   FocusScope.of(context).unfocus();
                        // },
                        onFieldSubmitted: (value) {
                          if (value.isNotEmpty) {
                            firstLoad(keyword: value);
                          } else {
                            setState(() {
                              isSearching = false;
                            });
                          }
                        },
                        onSaved: (value) {
                          if (value!.isNotEmpty) {
                            firstLoad(keyword: value);
                          } else {
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
                          hintText: (ViewAll.brandsSearch)
                              ? translateString(
                                  "search for brands", "البحث عن المتاجر")
                              : translate(context, 'inputs', 'find_product'),
                          hintStyle: const TextStyle(color: Colors.grey),
                        ),
                        onChanged: (val) {
                          print(val);
                          if (val.isNotEmpty) {
                            firstLoad(keyword: val);
                            setState(() {
                              isSearching = true;
                              search = val;
                            });
                          }

                          List<SubCategories> _subCat = [];
                          if (val.isEmpty || val == '') {
                            setState(() {
                              catProvider.sub = catProvider.allSub;

                              isSearching = false;
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

                      if (isSearching)
                        Container(
                          child: isFirstLoadRunning
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: mainColor,
                                  ),
                                )
                              : Column(
                                  children: [
                                    SizedBox(
                                      height: h * 0.55,
                                      child: (searchData.isNotEmpty)
                                          ? ListView.builder(
                                              controller: _controller,
                                              itemCount: searchData.length,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    (!ViewAll.brandsSearch)
                                                        ? InkWell(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical: h *
                                                                          0.01),
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width:
                                                                        w * 0.1,
                                                                    height:
                                                                        w * 0.1,
                                                                    child: Image
                                                                        .network(
                                                                      imagePath +
                                                                          searchData[index]
                                                                              .img,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: w *
                                                                        2.5 /
                                                                        100,
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                        w * 0.7,
                                                                    child: Text(
                                                                      translateString(
                                                                          searchData[index]
                                                                              .nameEn
                                                                              .toString(),
                                                                          searchData[index]
                                                                              .nameAr
                                                                              .toString()),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              w * 0.04),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              // await getItem(searchData[index].id);
                                                              // Navigator.pushNamed(context, 'pro');
                                                              navP(
                                                                  context,
                                                                  Products(
                                                                    fromFav:
                                                                        false,
                                                                    productId:
                                                                        searchData[index]
                                                                            .id,
                                                                  ));
                                                            },
                                                          )
                                                        : InkWell(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical: h *
                                                                          0.01),
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width:
                                                                        w * 0.1,
                                                                    height:
                                                                        w * 0.1,
                                                                    child: Image
                                                                        .network(
                                                                      searchData[index]
                                                                              .imgSrc +
                                                                          '/' +
                                                                          searchData[index]
                                                                              .img,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: w *
                                                                        2.5 /
                                                                        100,
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                        w * 0.7,
                                                                    child: Text(
                                                                      searchData[
                                                                              index]
                                                                          .name,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              w * 0.04),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              Provider.of<StudentItemProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .clearList();
                                                              Provider.of<StudentItemProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getItems(
                                                                      searchData[
                                                                              index]
                                                                          .id);
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          StudentInfo(
                                                                            studentId:
                                                                                searchData[index].id,
                                                                            // studentClass:
                                                                            //     searchData[index],
                                                                          )));
                                                            },
                                                          ),
                                                    Divider(
                                                      color: Colors.grey[200],
                                                      thickness: h * 0.002,
                                                    ),
                                                  ],
                                                );
                                              })
                                          : Center(
                                              child: Text(
                                                translate(context, 'alert',
                                                    'search_empty'),
                                                style: TextStyle(
                                                    fontFamily: 'Tajawal',
                                                    fontSize: w * 0.04,
                                                    fontWeight: FontWeight.w600,
                                                    color: mainColor),
                                              ),
                                            ),
                                    ),
                                    if (isLoadMoreRunning == true)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: h * 0.01, bottom: h * 0.01),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: mainColor,
                                          ),
                                        ),
                                      ),

                                    // When nothing else to load
                                    if (hasNextPage == false)
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: h * 0.01, bottom: h * 0.01),
                                        color: Colors.white,
                                      ),
                                  ],
                                ),
                        ),

                      // if (login && !isSearching) SearchPaginate(),
                      if (!isSearching && !ViewAll.brandsSearch)
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

                      if (!isSearching && ViewAll.brandsSearch)
                        Consumer<StudentProvider>(
                            builder: (context, st, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              st.students.length,
                              (i) {
                                StudentClass _st = st.students[i];
                                return Column(
                                  children: [
                                    InkWell(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: w * 0.1,
                                            height: h * 0.06,
                                            decoration: BoxDecoration(
                                              border:
                                                  Border.all(color: mainColor),
                                              image: _st.image == null
                                                  ? const DecorationImage(
                                                      image: AssetImage(
                                                          'assets/logo2.png'),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : DecorationImage(
                                                      image: NetworkImage(
                                                          _st.image!),
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: w * 0.02,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(top: h * 0.02),
                                            child: Text(
                                              _st.name ?? '',
                                              style: TextStyle(
                                                  fontSize: w * 0.04,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () async {
                                        Provider.of<StudentItemProvider>(
                                                context,
                                                listen: false)
                                            .clearList();
                                        //  Provider.of<StudentItemProvider>(
                                        //                           context,
                                        //                           listen:
                                        //                               false).getItems(_st.id);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StudentInfo(
                                                      // studentClass: _st,
                                                      studentId: _st.id!,
                                                    )));
                                      },
                                    ),
                                    SizedBox(
                                      height: h * 0.02,
                                    ),
                                    const Divider(),
                                  ],
                                );
                              },
                            ),
                          );
                        }),
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
