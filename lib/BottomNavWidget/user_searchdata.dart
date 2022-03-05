// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/models/usersearch_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SearchPaginate extends StatefulWidget {
  @override
  _SearchPaginateState createState() => _SearchPaginateState();
}

class _SearchPaginateState extends State<SearchPaginate> {
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
      final String url = domain + "get-my-search";
      Response response = await Dio().post(url,
          queryParameters: {'page': page},
          options: Options(
            headers: {
              'auth-token': auth,
            },
          ));
      UserSearchModel userSearchModel = UserSearchModel.fromJson(response.data);
      setState(() {
        searchData = userSearchModel.texts!.data!;
      });
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
        final String url = domain + "get-my-search";
        Response response = await Dio().post(url,
            queryParameters: {'page': page},
            options: Options(
              headers: {
                'auth-token': auth,
              },
            ));

        UserSearchModel userSearchModel =
            UserSearchModel.fromJson(response.data);
        final List<Data>? fetchedPosts = userSearchModel.texts?.data;
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
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: h * 0.01),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: w * 2.5 / 100,
                                    ),
                                    Text(
                                      searchData[index].text,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: w * 0.04),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {},
                            ),
                            Divider(
                              color: Colors.grey[200],
                              thickness: h * 0.002,
                            ),
                          ],
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
