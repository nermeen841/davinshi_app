// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:flutter/material.dart';

class ImageeNetworkWidget extends StatelessWidget {
  String image = "";
  double? height;
  double? width;
  BoxFit fit;
  ImageeNetworkWidget(
      {Key? key,
      required this.image,
      this.height,
      this.width,
      required this.fit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: image,
      fit: fit,
      placeholder: (context, url) => Center(
        child: Image.asset(
          "assets/images/logo_multi.png",
          height: (height ?? 100) / 2,
          width: (width ?? 100)/ 2,
          fit: BoxFit.scaleDown,
        ),
      ),
      //logo_multi
      errorWidget: (context, url, error) => Center(
        child: Image.asset(
          "assets/images/logo_multi.png",
           height: (height ?? 100) / 2,
          width: (width ?? 100)/ 2,
          fit: BoxFit.scaleDown,
        ),
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
        child: Image.asset(
          "assets/images/logo_multi.png",
         height: (height ?? 100) / 2,
          width: (width ?? 100)/ 2,
          fit: BoxFit.scaleDown,
        ),
      ),
      errorWidget: (context, url, error) => Center(
        child: Image.asset(
          "assets/images/logo_multi.png",
          height: (height ?? 100) / 2,
          width: (width ?? 100)/ 2,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
