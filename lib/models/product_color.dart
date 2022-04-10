class ColorModel {
  int? status;
  List<Data>? data;

  ColorModel({this.status, this.data});

  ColorModel.fromJson(Map<String, dynamic> json) {
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
  String? nameEn;
  String? nameAr;

  Data({
    this.id,
    this.nameEn,
    this.nameAr,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameEn = json['name_en'];
    nameAr = json['name_ar'];
  }
}
