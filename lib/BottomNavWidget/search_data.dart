// ignore_for_file: avoid_print

import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/brands_search.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/products_cla.dart';
import 'package:davinshi_app/models/search_model.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/student_product.dart';
import '../screens/student/student_info.dart';
import '../screens/student/view_all.dart';

class SearchDataScreen extends StatefulWidget {
  final String keyword;

  const SearchDataScreen({
    Key? key,
    required this.keyword,
  }) : super(key: key);

  @override
  _SearchDataScreenState createState() => _SearchDataScreenState();
}

class _SearchDataScreenState extends State<SearchDataScreen> {
  int page = 1;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;
  List searchData = [];
  // This function will be called when the app launches (see the initState function)
  void firstLoad() async {
    setState(() {
      isFirstLoadRunning = true;
    });
    try {
      final String url = domain + "search";
      Map data = {"text": widget.keyword};
      Response response = await Dio().post(url,
          queryParameters: {'page': page},
          data: data,
          options: Options(headers: {
            'auth-token': (login) ? auth : '',
          }));
      print(response.data);
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

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void loadMore() async {
    if (hasNextPage == true &&
        isFirstLoadRunning == false &&
        isLoadMoreRunning == false &&
        _controller.position.extentAfter < 400) {
      setState(() {
        isLoadMoreRunning = true;
        page++; // Display a progress indicator at the bottom
      });
      // Increase _page by 1
      try {
        final String url = domain + "search";
        Map data = {"text": widget.keyword};
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
    firstLoad();
    _controller = ScrollController()..addListener(loadMore);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  child: ListView.builder(
                      controller: _controller,
                      itemCount: searchData.length,
                      itemBuilder: (context, index) {
                        return (searchData.isNotEmpty)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  (!ViewAll.brandsSearch)
                                      ? InkWell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: h * 0.01),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: w * 0.1,
                                                  height: w * 0.1,
                                                  child: Image.network(
                                                    imagePath +
                                                        searchData[index].img,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: w * 2.5 / 100,
                                                ),
                                                SizedBox(
                                                  width: w * 0.7,
                                                  child: Text(
                                                    translateString(
                                                        searchData[index]
                                                            .nameEn
                                                            .toString(),
                                                        searchData[index]
                                                            .nameAr
                                                            .toString()),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: w * 0.04),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () async {
                                            dialog(context);
                                            await getItem(searchData[index].id);
                                            Navigator.pushReplacementNamed(
                                                context, 'pro');
                                          },
                                        )
                                      : InkWell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: h * 0.01),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: w * 0.1,
                                                  height: w * 0.1,
                                                  child: Image.network(
                                                    searchData[index].imgSrc +
                                                        '/' +
                                                        searchData[index].img,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: w * 2.5 / 100,
                                                ),
                                                SizedBox(
                                                  width: w * 0.7,
                                                  child: Text(
                                                    searchData[index].name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: w * 0.04),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () async {
                                            dialog(context);

                                            StudentItemProvider st = Provider
                                                .of<StudentItemProvider>(
                                                    context,
                                                    listen: false);
                                            st.clearList();
                                            await st
                                                .getItems(searchData[index].id);
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        StudentInfo(
                                                          studentClass:
                                                              searchData[index],
                                                        )));
                                          },
                                        ),
                                  Divider(
                                    color: Colors.grey[200],
                                    thickness: h * 0.002,
                                  ),
                                ],
                              )
                            : Center(
                                child: Text(translate(
                                    context, 'alert', 'search_empty')),
                              );
                      }),
                ),
                if (isLoadMoreRunning == true)
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.01),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: mainColor,
                      ),
                    ),
                  ),

                // When nothing else to load
                if (hasNextPage == false)
                  Container(
                    padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.01),
                    color: Colors.white,
                  ),
              ],
            ),
    );
  }
}
