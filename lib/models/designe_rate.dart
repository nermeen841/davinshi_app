class DesigneRatingModel {
  int? status;
  Data? data;

  DesigneRatingModel({this.status, this.data});

  DesigneRatingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<RatingData>? data;

  Data({
    this.data,
  });

  Data.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <RatingData>[];
      json['data'].forEach((v) {
        data!.add(RatingData.fromJson(v));
      });
    }
  }
}

class RatingData {
  int? id;
  int? rating;
  String? comment;

  User? user;

  RatingData({this.id, this.rating, this.comment, this.user});

  RatingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    comment = json['comment'];

    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
}

class User {
  int? id;
  String? name;

  User({
    this.id,
    this.name,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
