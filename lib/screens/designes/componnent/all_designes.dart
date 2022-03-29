// ignore_for_file: avoid_print

import 'package:davinshi_app/models/all_designe.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/provider/one_designe.dart';
import 'package:davinshi_app/screens/designes/single_designe.dart/one_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

import '../../../models/constants.dart';
import '../../../models/user.dart';

class AllDesignes extends StatefulWidget {
  const AllDesignes({Key? key}) : super(key: key);

  @override
  State<AllDesignes> createState() => _AllDesignesState();
}

class _AllDesignesState extends State<AllDesignes> {
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
      final String url = domain + "designs";
      Response response = await Dio().get(url,
          queryParameters: {'page': page},
          options: Options(
            headers: {
              'auth-token': auth,
            },
          ));
      AllDesignesModel allDesignesModel =
          AllDesignesModel.fromJson(response.data);
      setState(() {
        searchData = allDesignesModel.data!.data!;
      });
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
        page++; // Display a progress indicator at the bottom
      });
      // Increase _page by 1
      try {
        final String url = domain + "designs";
        Response response = await Dio().get(url,
            queryParameters: {'page': page},
            options: Options(
              headers: {
                'auth-token': auth,
              },
            ));

        AllDesignesModel allDesignesModel =
            AllDesignesModel.fromJson(response.data);
        final List<DesigneData>? fetchedPosts = allDesignesModel.data?.data;
        if (fetchedPosts!.isNotEmpty) {
          setState(() {
            searchData.addAll(fetchedPosts);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            hasNextPage = false;
          });
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
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
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
                  child: GridView.builder(
                      controller: _controller,
                      itemCount: searchData.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: w * 0.05,
                          mainAxisSpacing: w * 0.015),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            OneDesigne().getoneDesigne(
                              id: searchData[index].id.toString(),
                            );
                            await Future.delayed(const Duration(seconds: 1))
                                .then((value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => SingleDesigneScreen(
                                        designID:
                                            searchData[index].id.toString(),
                                      )),
                                ),
                              );
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "https://davinshi.net/" +
                                                searchData[index]
                                                    .images[0]
                                                    .src),
                                        fit: BoxFit.cover),
                                    borderRadius:
                                        BorderRadius.circular(w * 0.05),
                                    border: Border.all(color: mainColor)),
                              ),
                              SizedBox(
                                height: h * 0.015,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    searchData[index].designName,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        fontFamily: 'Tajawal',
                                        fontSize: w * 0.04,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SimpleStarRating(
                                    isReadOnly: true,
                                    starCount: 5,
                                    rating:
                                        (searchData[index].countRate != null)
                                            ? double.parse(searchData[index]
                                                .countRate
                                                .toString())
                                            : 0.0,
                                    size: w * 0.03,
                                    allowHalfRating: true,
                                    filledIcon: Icon(
                                      Icons.star,
                                      color: mainColor,
                                      size: w * 0.03,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
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
