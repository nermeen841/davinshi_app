import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/order.dart';
import 'order_info.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: getDirection(),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: mainColor,
            title: Text(
              translate(context, 'order', 'title'),
              style: TextStyle(
                  fontSize: w * 0.05,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            leading: BackButton(
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
                // Provider.of<BottomProvider>(context, listen: false).setIndex(3);
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => Home()),
                // );
              },
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: orders.isEmpty
              ? SingleChildScrollView(
                  child: Column(
                  children: [
                    SizedBox(
                      height: h * 0.1,
                    ),
                    SizedBox(
                      width: w * 0.5,
                      height: h * 0.3,
                      child: SvgPicture.asset(
                        'assets/empty.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: h * 0.07,
                    ),
                    Text(
                      translate(context, 'empty', 'no_order'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: w * 0.07,
                      ),
                    ),
                    SizedBox(
                      height: h * 0.07,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: w * 0.05,
                        right: w * 0.05,
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            child: Container(
                              height: h * 0.08,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: mainColor,
                              ),
                              child: Center(
                                child: Text(
                                  translate(context, 'buttons', 'back'),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: w * 0.045,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(
                            height: h * 0.07,
                          ),
                        ],
                      ),
                    )
                  ],
                ))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, i) {
                    return Center(
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: h * 0.007, bottom: h * 0.005),
                        child: InkWell(
                          child: SizedBox(
                            width: w * 0.9,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: w * 0.9,
                                  height: h * 0.11,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: w * 0.17,
                                        height: h * 0.09,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                              image:
                                                  NetworkImage(orders[i].image),
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      SizedBox(
                                        width: w * 0.03,
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: h * 0.11,
                                          child: Align(
                                            alignment: isLeft()
                                                ? Alignment.centerLeft
                                                : Alignment.centerRight,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  (language == 'en')
                                                      ? orders[i].titleEn
                                                      : orders[i].titleAr +
                                                          ' #' +
                                                          orders[i]
                                                              .id
                                                              .toString(),
                                                  style: TextStyle(
                                                    fontSize: w * 0.03,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  orders[i].date,
                                                  style: TextStyle(
                                                      fontSize: w * 0.03,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          translateStutse(
                                              statuse: orders[i].orderStatus),
                                          style: TextStyle(
                                            fontSize: w * 0.03,
                                            color: mainColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: h * 0.01,
                                ),
                                Divider(
                                  height: h * 0.005,
                                  color: Colors.grey[300],
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            dialog(context);
                            await getOrder(orders[i].id).then((value) {
                              if (value) {
                                navPR(
                                    context,
                                    OrderInfo(
                                      orderClass: orders[i],
                                    ));
                              } else {
                                navPop(context);
                                error(context);
                              }
                            });
                          },
                        ),
                      ),
                    );
                  },
                )),
    );
  }

  translateStutse({required String statuse}) {
    if (statuse == 'pending') {
      return translateString("pendeing", "قيد الانتظار ");
    } else if (statuse == 'accept') {
      return translateString("accept", "تم الموافقه");
    } else if (statuse == 'reject') {
      return translateString("reject", "تم رفض الطلب");
    } else if (statuse == 'done') {
      return translateString("done", "تم التسليم");
    } else if (statuse == 'shipping') {
      return translateString("shipping", "جاري الشحن");
    }
  }
}
