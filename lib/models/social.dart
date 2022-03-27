class SocialModel {
  int? status;
  List<Data>? data;

  SocialModel({this.status, this.data});

  SocialModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }
}

class Data {
  int? id;
  String? title;
  String? img;
  String? link;
  String? type;

  String? src;

  Data({this.id, this.title, this.img, this.link, this.type, this.src});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    img = json['img'];
    link = json['link'];
    type = json['type'];
    src = json['src'];
  }
}
