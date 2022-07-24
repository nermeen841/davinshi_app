class NotificationModel {
  int? status;
  List<Data>? data;

  NotificationModel({this.status, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }
}

class Data {
  int? id;
  String? type;
  int? typeId;
  String? title;
  String? body;
  String? createdAt;
  String? image;
  bool? isRead;

  Data(
      {this.id,
      this.type,
      this.typeId,
      this.title,
      this.body,
      this.createdAt,
      this.image,
      this.isRead});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    typeId = json['type_id'];
    title = json['title'];
    body = json['body'];
    createdAt = json['created_at'];
    image = json['image'];
    isRead = json['is_read'];
  }
}