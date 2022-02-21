class Category{
  String nameAr;
  String nameEn;
  String image;
  int id;
  List<SubCategories> subCategories;
  Category({required this.image,required this.nameEn,required this.id,required this.nameAr,required this.subCategories});
}

class SubCategories{
  String nameAr="";
  String nameEn="";
  String image="";
  int id=0;
  SubCategories({required this.image,required this.nameEn,required this.id,required this.nameAr});

  SubCategories.fromJson(Map<String, dynamic> jsonMap) {
    nameEn = jsonMap['name_en'].toString();
    nameAr = jsonMap['name_ar'].toString();
    image = jsonMap['img'].toString();
    id = jsonMap['id'];
  }

}

