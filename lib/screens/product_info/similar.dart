import 'package:flutter/material.dart';

import '../../lang/change_language.dart';
import '../../models/bottomnav.dart';
import '../../models/constants.dart';
import '../../models/products_cla.dart';

class SimilarProductScreen extends StatefulWidget {
  final List similar;
  const SimilarProductScreen({Key? key, required this.similar})
      : super(key: key);

  @override
  State<SimilarProductScreen> createState() => _SimilarProductScreenState();
}

class _SimilarProductScreenState extends State<SimilarProductScreen> {
  var currency = (prefs.getString('language_code').toString() == 'en')
      ? prefs.getString('currencyEn').toString()
      : prefs.getString('currencyAr').toString();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.02),
      child: GridView.builder(
        itemCount: widget.similar.length,
        itemBuilder: (ctx, i) {
          return InkWell(
              child: Padding(
                padding: isLeft()
                    ? EdgeInsets.only(left: w * 0.025)
                    : EdgeInsets.only(right: w * 0.025),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Container(
                        width: w * 0.5,
                        height: h * 0.25,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          image: DecorationImage(
                            image: NetworkImage(
                                imagePath + widget.similar[i].image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: w * 0.4,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: h * 0.01,
                          ),
                          Container(
                              width: w * 0.45,
                              constraints: BoxConstraints(
                                maxHeight: h * 0.07,
                              ),
                              child: Text(
                                  translateString(widget.similar[i].nameEn,
                                      widget.similar[i].nameAr),
                                  style: TextStyle(fontSize: w * 0.035),
                                  overflow: TextOverflow.ellipsis)),
                          SizedBox(
                            height: h * 0.005,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    if (widget.similar[i].inSale)
                                      TextSpan(
                                          text:
                                              '${widget.similar[i].salePrice} $currency ',
                                          style: TextStyle(
                                              fontFamily: 'Tajawal',
                                              fontWeight: FontWeight.bold,
                                              color: mainColor)),
                                    if (!widget.similar[i].inSale)
                                      TextSpan(
                                          text:
                                              '${widget.similar[i].regularPrice} $currency',
                                          style: TextStyle(
                                              fontFamily: 'Tajawal',
                                              fontWeight: FontWeight.bold,
                                              color: mainColor)),
                                  ],
                                ),
                              ),
                              if (widget.similar[i].inSale)
                                Text(
                                  '${widget.similar[i].salePrice} $currency',
                                  style: TextStyle(
                                    fontSize: w * 0.035,
                                    decorationThickness: w * 0.1,
                                    decorationColor: mainColor,
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () async {
                dialog(context);
                await getItem(widget.similar[i].id);
                Navigator.pushReplacementNamed(context, 'pro');
              });
        },
        shrinkWrap: true,
        primary: false,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: h * 0.001,
            mainAxisSpacing: w * 0.05,
            crossAxisCount: 2,
            childAspectRatio: 0.8),
      ),
    );
  }
}
