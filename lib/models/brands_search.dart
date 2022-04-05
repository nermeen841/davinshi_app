class BrandsSearchModel {
  int? status;
  Orders? orders;

  BrandsSearchModel({this.status, this.orders});

  BrandsSearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    orders = json['orders'] != null ? Orders.fromJson(json['orders']) : null;
  }
}

class Orders {
  List<Brands>? brands;

  Orders({this.brands});

  Orders.fromJson(Map<String, dynamic> json) {
    if (json['brands'] != null) {
      brands = <Brands>[];
      json['brands'].forEach((v) {
        brands!.add(Brands.fromJson(v));
      });
    }
  }
}

class Brands {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? date;
  String? university;
  String? universityId;
  String? major;
  String? img;
  int? isActive;
  int? points;
  String? cover;
  int? limitProducts;
  String? facebook;
  String? instagram;
  String? linkedin;
  String? twitter;
  String? imgSrc;
  int? endPoints;

  Brands(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.date,
      this.university,
      this.universityId,
      this.major,
      this.img,
      this.isActive,
      this.points,
      this.cover,
      this.limitProducts,
      this.facebook,
      this.instagram,
      this.linkedin,
      this.twitter,
      this.imgSrc,
      this.endPoints});

  Brands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    date = json['date'];
    university = json['university'];
    universityId = json['university_id'];
    major = json['major'];
    img = json['img'];
    isActive = json['is_active'];
    points = json['points'];
    cover = json['cover'];
    limitProducts = json['limit_products'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    linkedin = json['linkedin'];
    twitter = json['twitter'];
    imgSrc = json['img_src'];
    endPoints = json['end_points'];
  }
}
