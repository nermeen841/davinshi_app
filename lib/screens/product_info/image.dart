// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class Img extends StatelessWidget {
  final String src;
  Img(this.src, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: NetworkImage(src),
          ),
        ),
      ),
    );
  }
}
