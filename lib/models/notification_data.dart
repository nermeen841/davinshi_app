class NotificationModel {
  int? status;
  List<Data>? data;

  NotificationModel({this.status, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add( Data.fromJson(v));
      });
    }
  }

}

class Data {
  int? id;
  List<String>? fcmToken;
  List<int>? userId;
  String? type;
  int? typeId;
  String? title;
  String? body;
  String? image;
  bool? isRead;

  Data(
      {this.id,
      this.fcmToken,
      this.userId,
      this.type,
      this.typeId,
      this.title,
      this.body,
      this.image,
      this.isRead});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fcmToken = json['fcm_token'].cast<String>();
    userId = json['user_id'].cast<int>();
    type = json['type'];
    typeId = json['type_id'];
    title = json['title'];
    body = json['body'];
    image = json['image'];
    isRead = json['is_read'];
  }

}