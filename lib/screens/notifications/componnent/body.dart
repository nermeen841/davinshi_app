import 'package:davinshi_app/elements/newtwork_image.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/user.dart';
import 'package:davinshi_app/provider/notification.dart';
import 'package:davinshi_app/screens/product_info/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/constants.dart';
import '../../../models/order.dart';
import '../../cart/order_info.dart';
import '../../student/student_info.dart';

class NotificationBody extends StatefulWidget {
  const NotificationBody({Key? key}) : super(key: key);

  @override
  State<NotificationBody> createState() => _NotificationBodyState();
}

class _NotificationBodyState extends State<NotificationBody> {
  @override
  Widget build(BuildContext context) {
    Provider.of<NotificationProvider>(context, listen: false);
    return Consumer<NotificationProvider>(
      builder: (context, value, child) {
        return (!value.waitingData)
            ? Center(
                child: CircularProgressIndicator(
                  color: mainColor,
                ),
              )
            : (value.notificationModel!.data!.isNotEmpty)
                ? ListView.separated(
                    shrinkWrap: true,
                    primary: true,
                    itemCount: value.notificationModel!.data!.length,
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 0.02, vertical: h * 0.02),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          value.changeNotificationStatuse(
                              notificationId:
                                  value.notificationModel!.data![index].id!);
                          if (value.notificationModel!.data![index].type! ==
                              "Order") {
                            if (login) {
                              await getOrder(value
                                      .notificationModel!.data![index].typeId!)
                                  .then((value) {
                                navPR(
                                    context,
                                    OrderInfo(
                                        // orderClass: orders[index],
                                        ));
                              });
                            }
                          } else if (value
                                  .notificationModel!.data![index].type! ==
                              "Product") {
                            navPR(
                              context,
                              Products(
                                fromFav: false,
                                productId: value
                                    .notificationModel!.data![index].typeId!,
                              ),
                            );
                          } else if (value
                                  .notificationModel!.data![index].type! ==
                              "Brand") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StudentInfo(
                                          studentId: value.notificationModel!
                                              .data![index].id!,
                                        )));
                          } else if (value
                                  .notificationModel!.data![index].type! ==
                              "Category") {}
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: w * 0.02, vertical: h * 0.02),
                          decoration: BoxDecoration(
                            color:
                                (value.notificationModel!.data![index].isRead ==
                                            true ||
                                        value.isRead[value.notificationModel!
                                                .data![index].id!] ==
                                            true)
                                    ? Colors.white
                                    : const Color(0xffD7E5F0),
                            borderRadius: BorderRadius.circular(w * 0.03),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.07),
                                offset: const Offset(0, 3),
                                spreadRadius: 3,
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              (value.notificationModel!.data![index].image !=
                                      null)
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(w * 0.03),
                                      child: ImageeNetworkWidget(
                                        image: value.notificationModel!
                                            .data![index].image!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: h * 0.3,
                                      ),
                                    )
                                  : const SizedBox(),
                              (value.notificationModel!.data![index].image !=
                                      null)
                                  ? SizedBox(
                                      height: h * 0.03,
                                    )
                                  : const SizedBox(),
                              Text(
                                value.notificationModel!.data![index].title!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: "Tajawal",
                                    color: mainColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04),
                              ),
                              SizedBox(
                                height: h * 0.015,
                              ),
                              Text(
                                value.notificationModel!.data![index].body!,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: "Tajawal",
                                    color: Colors.black.withOpacity(0.8),
                                    fontWeight: FontWeight.w400,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04),
                              ),
                              SizedBox(
                                height: h * 0.015,
                              ),
                              Text(
                                value.notificationModel!.data![index].createdAt.toString(),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: "Tajawal",
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                      height: h * 0.03,
                    ),
                  )
                : Center(
                    child: Text(
                      translateString(
                          "no notifications here", "لا توجد إشعارات "),
                      style: TextStyle(
                          fontFamily: "Tajawal",
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.w700,
                          color: mainColor),
                    ),
                  );
      },
    );
  }
}
