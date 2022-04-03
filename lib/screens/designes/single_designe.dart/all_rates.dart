// ignore_for_file: avoid_print

import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/designe_rate.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/provider/one_designe.dart';
import 'package:davinshi_app/screens/designes/single_designe.dart/one_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

import '../../../models/constants.dart';

class AllRatesScreen extends StatefulWidget {
  final String designeID;
  const AllRatesScreen({Key? key, required this.designeID}) : super(key: key);

  @override
  State<AllRatesScreen> createState() => _AllRatesScreenState();
}

class _AllRatesScreenState extends State<AllRatesScreen> {
  String lang = '';
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
      final String url = domain + "designs/get-ratings/${widget.designeID}";
      Response response = await Dio().get(url,
          queryParameters: {'page': page},
          options: Options(
            headers: {
              'auth-token': auth,
            },
          ));
      DesigneRatingModel designeRatingModel =
          DesigneRatingModel.fromJson(response.data);
      setState(() {
        searchData = designeRatingModel.data!.data!;
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
        final String url = domain + "designs/get-ratings/${widget.designeID}";
        Response response = await Dio().get(url,
            queryParameters: {'page': page},
            options: Options(
              headers: {
                'auth-token': auth,
              },
            ));

        DesigneRatingModel designeRatingModel =
            DesigneRatingModel.fromJson(response.data);
        final List<RatingData>? fetchedPosts = designeRatingModel.data?.data;
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

  getLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      lang = preferences.getString('language_code').toString();
    });
  }

  @override
  void initState() {
    getLang();
    firstLoad();
    _controller = ScrollController()..addListener(loadMore);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Text(
          (lang == 'en') ? "All Rates" : "التقييمات",
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
              EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.02),
          margin: EdgeInsets.only(top: h * 0.04),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(w * 0.05),
              topRight: Radius.circular(w * 0.05),
            ),
          ),
          child: isFirstLoadRunning
              ? Center(
                  child: CircularProgressIndicator(
                    color: mainColor,
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: h * 0.75,
                      child: ListView.separated(
                          controller: _controller,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: h * 0.01),
                                      child: Text(
                                        searchData[index].user.name,
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: w * 0.044,
                                            fontFamily: 'Tajawal',
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: h * 0.01),
                                      child: Text(
                                        searchData[index].comment ?? "",
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: w * 0.044,
                                            fontFamily: 'Tajawal',
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: h * 0.01),
                                      child: SimpleStarRating(
                                        isReadOnly: true,
                                        starCount: 5,
                                        rating: double.parse(searchData[index]
                                            .rating
                                            .toString()),
                                        size: w * 0.05,
                                        allowHalfRating: true,
                                        filledIcon: Icon(
                                          Icons.star,
                                          color: mainColor,
                                          size: w * 0.05,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                (searchData[index].user.id == userId)
                                    ? Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: ((context) =>
                                                      SingleDesigneScreen(
                                                        rateVal: double.parse(
                                                            searchData[index]
                                                                .rating
                                                                .toString()),
                                                        ratingId:
                                                            searchData[index]
                                                                .id
                                                                .toString(),
                                                        designID:
                                                            widget.designeID,
                                                        comment:
                                                            searchData[index]
                                                                    .comment ??
                                                                "",
                                                      )),
                                                ),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: mainColor,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              deleteDesigneRating(
                                                      ratingId:
                                                          searchData[index]
                                                              .id
                                                              .toString(),
                                                      context: context)
                                                  .then((value) async {
                                                dialog(context);
                                                await Future.delayed(
                                                    const Duration(seconds: 1));
                                                firstLoad();
                                                navPop(context);
                                              });
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: mainColor,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: h * 0.02,
                                ),
                                const Divider(
                                  thickness: 1,
                                ),
                                SizedBox(
                                  height: h * 0.02,
                                ),
                              ],
                            );
                          },
                          itemCount: searchData.length),
                    ),
                    if (isLoadMoreRunning == true)
                      Padding(
                        padding:
                            EdgeInsets.only(top: h * 0.01, bottom: h * 0.01),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: mainColor,
                          ),
                        ),
                      ),
                    if (hasNextPage == false)
                      Container(
                        padding:
                            EdgeInsets.only(top: h * 0.01, bottom: h * 0.01),
                        color: Colors.white,
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
