// ignore_for_file: avoid_print, use_full_hex_values_for_flutter_colors

import 'package:davinshi_app/elements/newtwork_image.dart';
import 'package:davinshi_app/screens/product_info/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/provider/student_product.dart';
import 'package:davinshi_app/provider/student_provider.dart';
import 'package:davinshi_app/screens/student/student_info.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/constants.dart';
import '../../models/home_item.dart';
import '../../provider/home.dart';
import '../home_folder/home_page.dart';

class ViewAll extends StatefulWidget {
  static bool brandsSearch = false;

  const ViewAll({Key? key}) : super(key: key);

  @override
  State<ViewAll> createState() => _ViewAllState();
}

class _ViewAllState extends State<ViewAll> {
  final ScrollController _controller = ScrollController();

  bool f1 = true;
  bool isLoading = false;
  void start(context) {
    var of1 = Provider.of<StudentProvider>(context, listen: false);
    of1.getStudents().then((value) {
      isLoading = true;
    });

    _controller.addListener(() {
      if (_controller.position.atEdge) {
        if (_controller.position.pixels != 0) {
          if (f1) {
            if (!of1.finish) {
              f1 = false;
              of1.getStudents().then((value) {
                f1 = true;
              });
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    start(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translateString("Brand", "المتاجر"),
          style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.05,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.02),
            child: InkWell(
              onTap: () {
                Provider.of<BottomProvider>(context, listen: false).setIndex(2);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
                setState(() {
                  ViewAll.brandsSearch = true;
                });
              },
              child: Image.asset(
                "assets/images/search-1.png",
                width: w * 0.06,
                height: h * 0.03,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
        leading: InkWell(
          onTap: () => Navigator.pop(context),
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
        elevation: 0.0,
        backgroundColor: mainColor,
      ),
      body: Consumer<StudentProvider>(
        builder: ((context, value, child) => SizedBox(
              width: w,
              height: h,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (getAds(8).isNotEmpty)
                      SizedBox(
                        height: h * 0.3,
                        child: Swiper(
                          itemCount: getAds(8).length,
                          pagination: SwiperPagination(
                              builder: DotSwiperPaginationBuilder(
                                  color: mainColor.withOpacity(0.3),
                                  activeColor: mainColor),
                              alignment: Alignment.bottomCenter),
                          itemBuilder: (BuildContext context, int i) {
                            Ads _ads = getAds(8)[i];
                            return InkWell(
                              child: ImageeNetworkWidget(
                                height: h * 0.2 + 5,
                                fit: BoxFit.cover,
                                width: w,
                                image: _ads.image,
                              ),
                              focusColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                if (_ads.inApp) {
                                  if (_ads.type) {
                                    navP(
                                        context,
                                        Products(
                                          fromFav: false,
                                          productId: int.parse(_ads.link),
                                        ));
                                  }
                                } else {
                                  await canLaunch(_ads.link)
                                      ? await launch(_ads.link)
                                      : throw 'Could not launch ${_ads.link}';
                                }
                              },
                            );
                          },
                          autoplay: true,
                          autoplayDelay: 5000,
                        ),
                      ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: w * 0.02, vertical: h * 0.02),
                      child: Consumer<StudentProvider>(
                        builder: (context, st, _) {
                          print("\n\n\n\n st: ${st.students.length}");
                          if (!isLoading) {
                            return Padding(
                              padding: EdgeInsets.only(top: h * 0.3),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: mainColor,
                                ),
                              ),
                            );
                          } else {
                            if (st.students.isNotEmpty) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemBuilder: (context, i) {
                                    StudentClass _st = st.students[i];
                                    return InkWell(
                                      onTap: () async {
                                        Provider.of<StudentItemProvider>(
                                                context,
                                                listen: false)
                                            .clearList();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StudentInfo(
                                                      studentClass: _st,
                                                      studentId: _st.id,
                                                    )));
                                      },
                                      child: SizedBox(
                                        height: h * 0.48,
                                        child: Stack(
                                          alignment:
                                              AlignmentDirectional.bottomCenter,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional
                                                  .topCenter,
                                              child: Container(
                                                height: h * 0.35,
                                                color: Colors.white,
                                                child: ImageeNetworkWidget(
                                                  fit: BoxFit.cover,
                                                  image: st.students[i].cover!,
                                                  width: double.infinity,
                                                  height: h * 0.25,
                                                ),
                                                // child: Column(
                                                //   mainAxisSize: MainAxisSize.min,
                                                //   children: [
                                                //     Container(
                                                //       width: w * 0.3,
                                                //       height: h * 0.14,
                                                //       decoration: BoxDecoration(
                                                //         shape: BoxShape.circle,
                                                //         color: Colors.white,
                                                //         border: Border.all(
                                                //             color: mainColor),
                                                //         image: _st.image == null
                                                //             ? const DecorationImage(
                                                //                 image: AssetImage(
                                                //                     'assets/logo2.png'),
                                                //                 fit: BoxFit.cover,
                                                //               )
                                                //             : DecorationImage(
                                                //                 image: NetworkImage(
                                                //                     _st.image!),
                                                //                 fit: BoxFit.cover,
                                                //               ),
                                                //       ),
                                                //     ),
                                                //     // SizedBox(
                                                //     //   height: h * 0.01,
                                                //     // ),
                                                //     // Text(
                                                //     //   _st.name ?? '',
                                                //     //   style: TextStyle(
                                                //     //       fontSize: w * 0.04,
                                                //     //       color: Colors.white,
                                                //     //       fontWeight: FontWeight.bold),
                                                //     //   overflow: TextOverflow.fade,
                                                //     // ),
                                                //   ],
                                                // ),
                                              ),
                                            ),
                                            Container(
                                              width: w * 0.3,
                                              height: h * 0.3,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                boxShadow:  [
                                                  BoxShadow(
                                                      color:
                                                          Colors.grey.withOpacity(0.5),
                                                      offset:const Offset(0, 3),
                                                      blurRadius: 3,
                                                      spreadRadius: 3),
                                                ],
                                                border: Border.all(
                                                    color: mainColor),
                                                image: _st.image == null
                                                    ? const DecorationImage(
                                                        image: AssetImage(
                                                            'assets/logo2.png'),
                                                        fit: BoxFit.contain,
                                                      )
                                                    : DecorationImage(
                                                        image: NetworkImage(
                                                            _st.image!),
                                                        fit: BoxFit.contain,
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  
                                  itemCount: st.students.length);
                              // return GridView.count(
                              //   controller: _controller,
                              //   crossAxisCount: 3,
                              //   shrinkWrap: true,
                              //   // primary: false,
                              //   scrollDirection: Axis.vertical,
                              //   mainAxisSpacing: w * 0.02,
                              //   crossAxisSpacing: h * 0.02,
                              //   childAspectRatio: 0.8,
                              //   children:
                              //       List.generate(st.students.length, (i) {
                              //     StudentClass _st = st.students[i];

                              //     return InkWell(
                              //       child: Container(
                              //         width: w * 0.3,
                              //         height: h * 0.2,
                              //         decoration: BoxDecoration(
                              //             color: Colors.black,
                              //             borderRadius:
                              //                 BorderRadius.circular(w * 0.05),
                              //             border: Border.all(color: mainColor)),
                              //         child: Column(
                              //           mainAxisSize: MainAxisSize.min,
                              //           children: [
                              //             Container(
                              //               width: w * 0.3,
                              //               height: h * 0.14,
                              //               decoration: BoxDecoration(
                              //                 borderRadius:
                              //                     BorderRadius.circular(15),
                              //                 color: Colors.white,
                              //                 border:
                              //                     Border.all(color: mainColor),
                              //                 image: _st.image == null
                              //                     ? const DecorationImage(
                              //                         image: AssetImage(
                              //                             'assets/logo2.png'),
                              //                         fit: BoxFit.cover,
                              //                       )
                              //                     : DecorationImage(
                              //                         image: NetworkImage(
                              //                             _st.image!),
                              //                         fit: BoxFit.cover,
                              //                       ),
                              //               ),
                              //             ),
                              //             SizedBox(
                              //               height: h * 0.01,
                              //             ),
                              //             Text(
                              //               _st.name ?? '',
                              //               style: TextStyle(
                              //                   fontSize: w * 0.04,
                              //                   color: Colors.white,
                              //                   fontWeight: FontWeight.bold),
                              //               overflow: TextOverflow.fade,
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //       onTap: () async {
                              //         Provider.of<StudentItemProvider>(context,
                              //                 listen: false)
                              //             .clearList();
                              //         Navigator.push(
                              //             context,
                              //             MaterialPageRoute(
                              //                 builder: (context) => StudentInfo(
                              //                       studentClass: _st,
                              //                       studentId: _st.id,
                              //                     )));
                              //       },
                              //     );
                              //   }),
                              // );
                            } else {
                              return Center(
                                child: Text(
                                  translate(context, 'empty', 'no_student'),
                                  style: TextStyle(
                                      color: mainColor, fontSize: w * 0.05),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: h * 0.01,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
