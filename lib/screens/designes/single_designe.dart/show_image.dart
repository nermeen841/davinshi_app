import 'package:davinshi_app/elements/newtwork_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';

import '../../../models/bottomnav.dart';
import '../../../models/constants.dart';

class ShowDesigneImage extends StatefulWidget {
  final List images;
  const ShowDesigneImage({Key? key, required this.images}) : super(key: key);

  @override
  State<ShowDesigneImage> createState() => _ShowDesigneImageState();
}

class _ShowDesigneImageState extends State<ShowDesigneImage>
    with SingleTickerProviderStateMixin {
  TransformationController? transformationController;
  AnimationController? animationController;
  TapDownDetails? tapDownDetails;
  Animation<Matrix4>? animation;
  @override
  void initState() {
    transformationController = TransformationController();
    animationController = AnimationController(
        vsync: this, duration: const Duration(microseconds: 200))
      ..addListener(() => transformationController!.value = animation!.value);
    super.initState();
  }

  @override
  void dispose() {
    transformationController!.dispose();
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return PreferredSize(
      preferredSize: Size(w, h),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            GestureDetector(
              onDoubleTap: () {
                final position = tapDownDetails!.localPosition;
                const double scale = 3.0;
                final x = -position.dx * (scale - 1);
                final y = -position.dy * (scale - 1);
                final zoomed = Matrix4.identity()
                  ..translate(x, y)
                  ..scale(scale);
                final end = transformationController!.value.isIdentity()
                    ? zoomed
                    : Matrix4.identity();
                animation = Matrix4Tween(
                  begin: transformationController!.value,
                  end: end,
                ).animate(
                  CurveTween(curve: Curves.easeOut)
                      .animate(animationController!),
                );
                animationController!.forward(from: 0);
              },
              onDoubleTapDown: (details) => tapDownDetails = details,
              child: InteractiveViewer(
                clipBehavior: Clip.none,
                // maxScale: 4,
                // minScale: 1,
                panEnabled: false,
                transformationController: transformationController,
                // onInteractionEnd: (details) {
                //   resetAnimation();
                // },
                child: Swiper(
                  autoplayDelay: 5000,
                  pagination: SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                          color: mainColor.withOpacity(0.3),
                          activeColor: mainColor),
                      alignment: Alignment.bottomCenter),
                  itemCount: widget.images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: w,
                      color: Colors.black,
                      child: ImageeNetworkWidget(
                          image: "https://davinshi.net/" +
                              widget.images[index].src,
                          fit: BoxFit.contain),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: h * 0.1, horizontal: w * 0.03),
              child: Align(
                alignment:
                    (language == 'en') ? Alignment.topLeft : Alignment.topRight,
                child: InkWell(
                  onTap: () => navPop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: mainColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
