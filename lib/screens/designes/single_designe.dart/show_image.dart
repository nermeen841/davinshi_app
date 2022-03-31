import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';

import '../../../models/bottomnav.dart';

class ShowDesigneImage extends StatefulWidget {
  final List images;
  const ShowDesigneImage({Key? key, required this.images}) : super(key: key);

  @override
  State<ShowDesigneImage> createState() => _ShowDesigneImageState();
}

class _ShowDesigneImageState extends State<ShowDesigneImage> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: Swiper(
        autoplayDelay: 5000,
        pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(
                color: mainColor.withOpacity(0.3), activeColor: mainColor),
            alignment: Alignment.bottomCenter),
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return Container(
            width: w,
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: NetworkImage(
                    "https://davinshi.net/" + widget.images[index].src),
              ),
            ),
          );
        },
      ),
    );
  }
}
