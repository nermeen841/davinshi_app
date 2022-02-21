import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:davinshi_app/lang/change_language.dart';
import 'package:davinshi_app/models/bottomnav.dart';
import 'package:davinshi_app/models/cat.dart';
import 'package:davinshi_app/models/constants.dart';
import 'package:davinshi_app/provider/package_provider.dart';
import 'package:davinshi_app/screens/multiple_packages.dart';
import 'package:provider/provider.dart';

class SubCatPage extends StatelessWidget {
  final Category category;
  const SubCatPage({Key? key, required this.category}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translateString(category.nameEn, category.nameAr),
          style: TextStyle(color: Colors.white, fontSize: w * 0.04),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        elevation: 5,
        backgroundColor: mainColor,
        iconTheme: IconThemeData(color: mainColor),
      ),
      body: Padding(
        padding: EdgeInsets.all(w * 0.05),
        child: category.subCategories.isNotEmpty
            ? GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: h * 0.05,
                crossAxisSpacing: w * 0.1,
                childAspectRatio: 1,
                children: List.generate(category.subCategories.length, (i) {
                  SubCategories _sub = category.subCategories[i];
                  return InkWell(
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(w * 0.05),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: w * 0.15,
                                  height: w * 0.09,
                                  // child: SvgPicture.network(subCat[i].image),
                                  child: _sub.image.contains('.svg')
                                      ? SvgPicture.network(_sub.image)
                                      : Image.network(
                                          _sub.image,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                SizedBox(
                                  height: h * 0.03,
                                ),
                                // Text(translateString(_sub.nameEn, _sub.nameAr),style: TextStyle(color: Colors.black,fontSize: w*0.05),),
                                SizedBox(
                                  height: h * 0.07,
                                  child: Text(
                                    translateString(_sub.nameEn, _sub.nameAr),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: w * 0.04),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      dialog(context);
                      Provider.of<NewPackageItemProvider>(context,
                              listen: false)
                          .clearList();
                      await Provider.of<NewPackageItemProvider>(context,
                              listen: false)
                          .getItems(_sub.id);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => MultiplePackages(
                                    id: _sub.id,
                                  )));
                    },
                  );
                }),
              )
            : SizedBox(
                height: h,
                width: w,
                child: Center(
                  child: Text(
                    translate(context, 'empty', 'no_products'),
                    style: TextStyle(color: mainColor, fontSize: w * 0.05),
                  ),
                ),
              ),
      ),
    );
  }
}
