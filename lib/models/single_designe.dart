class OneItemModel {
  int? status;
  List<Data>? data;

  OneItemModel({this.status, this.data});

  OneItemModel.fromJson(Map<String, dynamic> json) {
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
  String? designName;
  String? userName;
  String? phone;
  String? email;
  String? note;
  int? status;
  String? countRate;
  List<Images>? images;

  Data(
      {this.id,
      this.designName,
      this.userName,
      this.phone,
      this.email,
      this.note,
      this.status,
      this.countRate,
      this.images});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    designName = json['design_name'];
    userName = json['user_name'];
    phone = json['phone'];
    email = json['email'];
    note = json['note'];
    status = json['status'];
    countRate = json['count_rate'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
  }
}

class Images {
  int? id;
  String? src;
  int? designId;

  Images({this.id, this.src, this.designId});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    src = json['src'];
    designId = json['design_id'];
  }
}
