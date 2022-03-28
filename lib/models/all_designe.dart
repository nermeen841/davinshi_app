class AllDesignesModel {
  int? status;
  Data? data;

  AllDesignesModel({this.status, this.data});

  AllDesignesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? currentPage;
  List<DesigneData>? data;

  Data({
    this.currentPage,
    this.data,
  });

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <DesigneData>[];
      json['data'].forEach((v) {
        data!.add(DesigneData.fromJson(v));
      });
    }
  }
}

class DesigneData {
  int? id;
  String? designName;
  String? userName;
  String? phone;
  String? email;
  String? note;
  int? status;
  String? countRate;
  List<Images>? images;

  DesigneData(
      {this.id,
      this.designName,
      this.userName,
      this.phone,
      this.email,
      this.note,
      this.status,
      this.countRate,
      this.images});

  DesigneData.fromJson(Map<String, dynamic> json) {
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
