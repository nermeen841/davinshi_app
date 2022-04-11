// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:flutter/material.dart';

class ImageeNetworkWidget extends StatelessWidget {
  String image = "";
  double? height;
  double? width;
  ImageeNetworkWidget({Key? key, required this.image, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: image,
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(
          color: mainColor,
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(
        "assets/images/Mask Group 2@3x.png",
        height: height,
        width: width,
      ),
    );
  }
}

class RoundedImageeNetworkWidget extends StatelessWidget {
  String image = "";
  double? height;
  double? width;
  RoundedImageeNetworkWidget(
      {Key? key, required this.image, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: image,
      fit: BoxFit.cover,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
        color: mainColor,
      )),
      errorWidget: (context, url, error) => Image.asset(
        "assets/images/Mask Group 2@3x.png",
        height: height,
        width: width,
      ),
    );
  }
}
