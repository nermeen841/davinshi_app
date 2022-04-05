class SocialModel {
  int? status;
  Data? data;

  SocialModel({this.status, this.data});

  SocialModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<IconsSp>? iconsSp;
  List<Icons>? icons;

  Data({this.iconsSp, this.icons});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['icons_sp'] != null) {
      iconsSp = <IconsSp>[];
      json['icons_sp'].forEach((v) {
        iconsSp!.add(IconsSp.fromJson(v));
      });
    }
    if (json['icons'] != null) {
      icons = <Icons>[];
      json['icons'].forEach((v) {
        icons!.add(Icons.fromJson(v));
      });
    }
  }
}

class Icons {
  int? id;
  String? title;
  String? img;
  String? link;
  String? type;
  String? src;

  Icons({this.id, this.title, this.img, this.link, this.type, this.src});
  Icons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    img = json['img'];
    link = json['link'];
    type = json['type'];

    src = json['src'];
  }
}

class IconsSp {
  int? id;
  String? title;
  String? img;
  String? link;
  String? type;
  String? src;

  IconsSp({this.id, this.title, this.img, this.link, this.type, this.src});

  IconsSp.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    img = json['img'];
    link = json['link'];
    type = json['type'];

    src = json['src'];
  }
}
