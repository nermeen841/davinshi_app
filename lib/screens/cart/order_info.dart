// ignore_for_file: use_key_in_widget_constructors

import 'package:davinshi_app/models/products_cla.dart';
import 'package:flutter/material.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/order.dart';

class OrderInfo extends StatefulWidget {
  final OrderClass orderClass;
  const OrderInfo({required this.orderClass});
  @override
  _OrderInfoState createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
  var currency = (prefs.getString('language_code').toString() == 'en')
      ? prefs.getString('currencyEn').toString()
      : prefs.getString('currencyAr').toString();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: SizedBox(
              width: w * 0.7,
              child: (language == 'en')
                  ? Text(widget.orderClass.titleEn)
                  : Text(
                      widget.orderClass.titleAr,
                    ),
            ),
            titleTextStyle: TextStyle(
                color: Colors.white, fontSize: w * 0.04, fontFamily: 'Tajawal'),
            centerTitle: false,
            backgroundColor: mainColor,
            leading: const BackButton(
              color: Colors.white,
            ),
          ),
          body: Container(
              width: w,
              height: h,
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        SizedBox(
                          width: w,
                          child: Padding(
                            padding: EdgeInsets.all(w * 0.05),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.grey,
                                  size: w * 0.09,
                                ),
                                SizedBox(
                                  width: w * 0.02,
                                ),
                                SizedBox(
                                  width: w * 0.7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.orderClass.userAddress!.title,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: w * 0.04),
                                      ),
                                      Text(
                                        widget.orderClass.userAddress!.address,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: w * 0.035,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Expanded(
                                    child: SizedBox(
                                  width: 1,
                                )),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: h * 0.02,
                          width: w,
                          color: Colors.grey[200],
                        ),

                        Padding(
                          padding: EdgeInsets.all(w * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                widget.orderClass.items.length, (i) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: w * 0.00, vertical: h * 0.01),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      translateString(
                                          widget.orderClass.items[i].titleEn,
                                          widget.orderClass.items[i].titleAr),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: mainColor,
                                          fontSize: w * 0.035),
                                    ),
                                    SizedBox(
                                      height: h * 0.01,
                                    ),
                                    SizedBox(
                                      width: w,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: w * 0.09,
                                          ),
                                          Container(
                                            height: h * 0.12,
                                            width: w * 0.18,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(widget
                                                    .orderClass.items[i].image),
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: w * 0.03,
                                          ),
                                          SizedBox(
                                            height: h * 0.13,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${widget.orderClass.items[i].price} $currency',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: mainColor,
                                                      fontSize: w * 0.035),
                                                ),
                                                Text(
                                                  translateString(
                                                      widget.orderClass.items[i]
                                                          .desEn,
                                                      widget.orderClass.items[i]
                                                          .desAr),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: mainColor,
                                                      fontSize: w * 0.035),
                                                ),
                                                Container(
                                                  height: h * 0.07,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        w * 0.03),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: w * 0.04,
                                                        ),
                                                        Text(
                                                          widget.orderClass
                                                              .items[i].quantity
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  w * .04),
                                                        ),
                                                        SizedBox(
                                                          width: w * 0.04,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: h * 0.02,
                                    ),
                                    Divider(
                                      color: Colors.grey[300],
                                      thickness: h * 0.002,
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                        Container(
                          height: h * 0.02,
                          width: w,
                          color: Colors.grey[200],
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        // if(widget.orderClass.note!=null)Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: w*0.05),
                        //   child: SizedBox(
                        //     width: w*0.9,
                        //     child: TextFormField(
                        //       initialValue: widget.orderClass.note!,
                        //       cursorColor: Colors.black,
                        //       maxLines: 5,
                        //       minLines: 1,
                        //       decoration: InputDecoration(
                        //         focusedBorder: form(),
                        //         enabledBorder: form(),
                        //         errorBorder: form(),
                        //         focusedErrorBorder: form(),
                        //         hintText: ' Note (optional)',
                        //         hintStyle: const TextStyle(color: Colors.grey),
                        //         floatingLabelBehavior:FloatingLabelBehavior.never,
                        //         errorMaxLines: 1,
                        //         errorStyle: TextStyle(fontSize: w*0.03),
                        //         contentPadding: EdgeInsets.symmetric(horizontal: w*0.01),
                        //       ),
                        //       keyboardType: TextInputType.multiline,
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: h*0.02,),
                        Padding(
                          padding: EdgeInsets.all(w * 0.05),
                          child: SizedBox(
                            width: w,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      translate(context, 'cart', 'price'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: w * 0.05),
                                    ),
                                    Text(
                                      getProductprice(
                                          currency: currency,
                                          productPrice:
                                              widget.orderClass.subTotal),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: w * 0.05),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: h * 0.03,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      translate(context, 'cart', 'delivery'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: w * 0.05),
                                    ),
                                    Text(
                                      getProductprice(
                                          currency: currency,
                                          productPrice:
                                              widget.orderClass.delivery),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: w * 0.05),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: h * 0.03,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      translate(context, 'cart', 'discount'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: w * 0.05),
                                    ),
                                    Text(
                                      getProductprice(
                                          currency: currency,
                                          productPrice: widget.orderClass.dis),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: w * 0.05),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: h * 0.03,
                                ),
                                Divider(
                                  color: Colors.grey[300],
                                  thickness: h * 0.001,
                                ),
                                SizedBox(
                                  height: h * 0.03,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      translate(context, 'cart', 'total'),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: w * 0.05),
                                    ),
                                    Text(
                                      getProductprice(
                                          currency: currency,
                                          productPrice:
                                              widget.orderClass.total),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: w * 0.055,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: h * 0.06,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }
}

InputBorder form() {
  return OutlineInputBorder(
    borderSide: BorderSide(color: mainColor, width: 1.5),
    borderRadius: BorderRadius.circular(5),
  );
}
