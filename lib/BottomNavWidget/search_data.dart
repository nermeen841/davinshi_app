// // ignore_for_file: avoid_print

// import 'package:davinshi_app/lang/change_language.dart';
// import 'package:davinshi_app/models/bottomnav.dart';
// import 'package:davinshi_app/models/brands_search.dart';
// import 'package:davinshi_app/models/constants.dart';
// import 'package:davinshi_app/models/search_model.dart';
// import 'package:davinshi_app/models/user.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../provider/student_product.dart';
// import '../screens/product_info/products.dart';
// import '../screens/student/student_info.dart';
// import '../screens/student/view_all.dart';

// class SearchDataScreen extends StatefulWidget {
//   final String keyword;

//   const SearchDataScreen({
//     Key? key,
//     required this.keyword,
//   }) : super(key: key);

//   @override
//   _SearchDataScreenState createState() => _SearchDataScreenState();
// }

// class _SearchDataScreenState extends State<SearchDataScreen> {
 
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: isFirstLoadRunning
//           ? Center(
//               child: CircularProgressIndicator(
//                 color: mainColor,
//               ),
//             )
//           : Column(
//               children: [
//                 SizedBox(
//                   height: h * 0.55,
//                   child: ListView.builder(
//                       controller: _controller,
//                       itemCount: searchData.length,
//                       itemBuilder: (context, index) {
//                         return (searchData.isNotEmpty)
//                             ? Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   (!ViewAll.brandsSearch)
//                                       ? InkWell(
//                                           child: Padding(
//                                             padding: EdgeInsets.symmetric(
//                                                 vertical: h * 0.01),
//                                             child: Row(
//                                               children: [
//                                                 SizedBox(
//                                                   width: w * 0.1,
//                                                   height: w * 0.1,
//                                                   child: Image.network(
//                                                     imagePath +
//                                                         searchData[index].img,
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: w * 2.5 / 100,
//                                                 ),
//                                                 SizedBox(
//                                                   width: w * 0.7,
//                                                   child: Text(
//                                                     translateString(
//                                                         searchData[index]
//                                                             .nameEn
//                                                             .toString(),
//                                                         searchData[index]
//                                                             .nameAr
//                                                             .toString()),
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: w * 0.04),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           onTap: () async {
//                                             // await getItem(searchData[index].id);
//                                             // Navigator.pushNamed(context, 'pro');
//                                             navP(
//                                                 context,
//                                                 Products(
//                                                   fromFav: false,
//                                                   productId:
//                                                       searchData[index].id,
//                                                 ));
//                                           },
//                                         )
//                                       : InkWell(
//                                           child: Padding(
//                                             padding: EdgeInsets.symmetric(
//                                                 vertical: h * 0.01),
//                                             child: Row(
//                                               children: [
//                                                 SizedBox(
//                                                   width: w * 0.1,
//                                                   height: w * 0.1,
//                                                   child: Image.network(
//                                                     searchData[index].imgSrc +
//                                                         '/' +
//                                                         searchData[index].img,
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: w * 2.5 / 100,
//                                                 ),
//                                                 SizedBox(
//                                                   width: w * 0.7,
//                                                   child: Text(
//                                                     searchData[index].name,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     style: TextStyle(
//                                                         color: Colors.black,
//                                                         fontSize: w * 0.04),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           onTap: () async {
//                                             Provider.of<StudentItemProvider>(
//                                                     context,
//                                                     listen: false)
//                                                 .clearList();
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         StudentInfo(
//                                                           studentId:
//                                                               searchData[index]
//                                                                   .id,
//                                                           studentClass:
//                                                               searchData[index],
//                                                         )));
//                                           },
//                                         ),
//                                   Divider(
//                                     color: Colors.grey[200],
//                                     thickness: h * 0.002,
//                                   ),
//                                 ],
//                               )
//                             : Center(
//                                 child: Text(translate(
//                                     context, 'alert', 'search_empty')),
//                               );
//                       }),
//                 ),
//                 if (isLoadMoreRunning == true)
//                   Padding(
//                     padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.01),
//                     child: Center(
//                       child: CircularProgressIndicator(
//                         color: mainColor,
//                       ),
//                     ),
//                   ),

//                 // When nothing else to load
//                 if (hasNextPage == false)
//                   Container(
//                     padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.01),
//                     color: Colors.white,
//                   ),
//               ],
//             ),
//     );
//   }
// }
