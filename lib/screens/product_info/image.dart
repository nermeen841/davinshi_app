// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';

import '../../models/bottomnav.dart';

class Img extends StatelessWidget {
  final String src;
  final List? images;
  Img(this.src, {Key? key, this.images}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: (images!.isEmpty)
          ? Container(
              width: w,
              height: h,
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: NetworkImage(src),
                ),
              ),
            )
          : Swiper(
              autoplayDelay: 5000,
              pagination: SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                      color: mainColor.withOpacity(0.3),
                      activeColor: mainColor),
                  alignment: Alignment.bottomCenter),
              itemCount: images!.length,
              itemBuilder: (context, index) {
                return Container(
                  width: w,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      image: NetworkImage(images![index]),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
