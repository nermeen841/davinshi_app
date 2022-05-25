import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/models/products_cla.dart';
import 'package:davinshi_app/screens/product_info/products.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../elements/newtwork_image.dart';
import '../lang/change_language.dart';
import '../models/bottomnav.dart';

class SubCategoryProductsList extends StatefulWidget {
  final String subcatId;
  const SubCategoryProductsList({Key? key, required this.subcatId})
      : super(key: key);

  @override
  State<SubCategoryProductsList> createState() =>
      _SubCategoryProductsListState();
}

class _SubCategoryProductsListState extends State<SubCategoryProductsList> {
  var currency = (prefs.getString('language_code').toString() == 'en')
      ? prefs.getString('currencyEn').toString()
      : prefs.getString('currencyAr').toString();
  int page = 1;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;
  List<ProductsModel> productList = [];
  late ScrollController scrollController;

  void getProducts() async {
    setState(() {
      isFirstLoadRunning = true;
      productList = [];
    });
    final String url =
        domain + 'get-new-products/${widget.subcatId.toString()}?page=$page';
    Response response = await Dio().get(
      url,
      options: Options(headers: {
        'Content-language': prefs.getString('language_code').toString().isEmpty
            ? 'en'
            : prefs.getString('language_code').toString()
      }),
    );

    if (response.data['status'] == 1) {
      for (var data in response.data['data']['products']) {
        var thisList = ProductsModel(
          isOrder: data['is_order'],
          id: data['id'].toString(),
          img: imagePath + data['img'],
          name: data['name_ar'].toString(),
          sale_price: data['sale_price'].toString(),
          regular_price: data['regular_price'].toString(),
          disPer: data['discount_percentage'].toString(),
          in_sale: data['in_sale'].toString() == "true" ? true : false,
        );

        setState(() {
          productList.add(thisList);
        });
      }
    }
    setState(() {
      isFirstLoadRunning = false;
    });
  }

  void loadMore() async {
    if (hasNextPage == true &&
        isFirstLoadRunning == false &&
        isLoadMoreRunning == false &&
        scrollController.position.extentAfter < 400) {
      List<ProductsModel> fetchedPosts = [];
      setState(() {
        isLoadMoreRunning = true;
        page++; // Display a progress indicator at the bottom
      });
      // Increase _page by 1
      try {
        final String url = domain +
            'get-new-products/${widget.subcatId.toString()}?page=$page';
        Response response = await Dio().get(
          url,
          options: Options(headers: {
            'Content-language':
                prefs.getString('language_code').toString().isEmpty
                    ? 'en'
                    : prefs.getString('language_code').toString()
          }),
        );
        if (response.data['status'] == 1) {
          for (var data in response.data['data']['products']) {
            var thisList = ProductsModel(
              isOrder: data['is_order'],
              id: data['id'].toString(),
              img: imagePath + data['img'],
              name: data['name_ar'].toString(),
              sale_price: data['sale_price'].toString(),
              regular_price: data['regular_price'].toString(),
              disPer: data['discount_percentage'].toString(),
              in_sale: data['in_sale'].toString() == "true" ? true : false,
            );

            fetchedPosts.add(thisList);
          }
        }
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            productList.addAll(fetchedPosts);
          });
        } else {
          setState(() {
            hasNextPage = false;
          });
        }
      } catch (err) {
        // ignore: avoid_print
        print(err.toString());
      }

      setState(() {
        isLoadMoreRunning = false;
      });
    }
  }

  @override
  void initState() {
    getProducts();
    scrollController = ScrollController()..addListener(loadMore);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
      height: h,
      child: isFirstLoadRunning
          ? Center(
              child: CircularProgressIndicator(
                color: mainColor,
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: h * 0.03,
                ),
                SizedBox(
                  height: h * 0.7,
                  child: (productList.isNotEmpty)
                      ? GridView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: productList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: h * 0.01,
                            mainAxisSpacing: w * 0.02,
                            crossAxisCount: 2,
                            childAspectRatio: 0.62,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: Padding(
                                padding: isLeft()
                                    ? EdgeInsets.only(
                                        right: w * 0.025, bottom: h * 0.02)
                                    : EdgeInsets.only(
                                        left: w * 0.025, bottom: h * 0.02),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Stack(
                                      children: [
                                        ImageeNetworkWidget(
                                          fit: BoxFit.cover,
                                          width: w * 0.45,
                                          height: h * 0.28,
                                          image:
                                              productList[index].img.toString(),
                                        ),
                                        (productList[index].isOrder == 1)
                                            ? Container(
                                                height: h * 0.04,
                                                width: w * 0.22,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: w * 0.01,
                                                    vertical: h * 0.01),
                                                decoration: BoxDecoration(
                                                  color: mainColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          w * 0.02),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    translateString(
                                                        "Order", "علي الطلب"),
                                                    style: TextStyle(
                                                        fontFamily: 'Tajawal',
                                                        fontSize: w * 0.04,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                    SizedBox(
                                      width: w * 0.45,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: h * 0.01,
                                          ),
                                          Text(
                                            productList[index].name.toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.fade,
                                          ),
                                          SizedBox(
                                            height: h * 0.005,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    if (productList[index]
                                                            .in_sale ==
                                                        true)
                                                      TextSpan(
                                                          text: getProductprice(
                                                              currency:
                                                                  currency,
                                                              productPrice: num
                                                                  .parse(productList[
                                                                          index]
                                                                      .sale_price
                                                                      .toString())),
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Tajawal',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  mainColor)),
                                                    if (productList[index]
                                                            .in_sale ==
                                                        false)
                                                      TextSpan(
                                                          text:
                                                              '${productList[index].regular_price} '
                                                              '$currency ',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Tajawal',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  mainColor)),
                                                  ],
                                                ),
                                              ),
                                              if (productList[index].in_sale ==
                                                      true &&
                                                  productList[index].disPer !=
                                                      null)
                                                Text(
                                                  '${productList[index].regular_price} $currency',
                                                  style: TextStyle(
                                                    fontSize: w * 0.035,
                                                    color: Colors.grey,
                                                    decorationColor: mainColor,
                                                    decorationThickness:
                                                        w * 0.1,
                                                    decoration: TextDecoration
                                                        .lineThrough,
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
                                navP(
                                  context,
                                  Products(
                                    fromFav: false,
                                    productId: int.parse(
                                        productList[index].id.toString()),
                                  ),
                                );
                                // dialog(context);
                                // getItem(int.parse(
                                //         productList[index].id.toString()))
                                //     .then((value) {
                                //   Navigator.pop(context);
                                //   Navigator.pushNamed(context, 'pro');
                                // });
                              },
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            translateString(
                                "No product here", "لا توجد منتجات"),
                            style: TextStyle(
                                color: mainColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Tajawal',
                                fontSize: w * 0.04),
                          ),
                        ),
                ),
                if (isLoadMoreRunning == true)
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.01),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: mainColor,
                      ),
                    ),
                  ),

                // When nothing else to load
                if (hasNextPage == false)
                  Container(
                    padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.01),
                    color: Colors.white,
                    child: Text(
                      translate(context, 'contac_us', 'paginate'),
                      style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: w * 0.04,
                          color: mainColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
    );
  }
}
