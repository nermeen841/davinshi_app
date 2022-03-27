import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/screens/designes/single_designe.dart/one_item.dart';
import 'package:flutter/material.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

class AllDesignes extends StatefulWidget {
  const AllDesignes({Key? key}) : super(key: key);

  @override
  State<AllDesignes> createState() => _AllDesignesState();
}

class _AllDesignesState extends State<AllDesignes> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return GridView.builder(
        primary: true,
        shrinkWrap: true,
        itemCount: 10,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: w * 0.05,
            mainAxisSpacing: w * 0.015),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => const SingleDesigneScreen()),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: const DecorationImage(
                          image: AssetImage("assets/images/asset-3.png"),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(w * 0.05),
                      border: Border.all(color: mainColor)),
                ),
                SizedBox(
                  height: h * 0.015,
                ),
                Row(
                  children: [
                    Text(
                      "designer name",
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: w * 0.04,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: w * 0.015,
                    ),
                    SimpleStarRating(
                      isReadOnly: true,
                      starCount: 5,
                      rating: 3,
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
        });
  }
}
