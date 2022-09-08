// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String? str) => NotificationModel.fromJson(json.decode(str!));

String? notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    this.message,
    this.count,
    this.data,
  });

  String? message;
  int? count;
  List<Notifications>? data;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    message: json["message"],
    count: json["count"],
    data: List<Notifications>.from(json["data"].map((x) => Notifications.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "count": count,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Notifications {
  Notifications({
    this.id,
    this.userId,
    this.notificationTitle,
    this.notificationDescription,
    this.notificationType,
    this.notificationIsRead,
    this.orderId,
    this.name,
    this.email,
    this.role,
  });

  int? id;
  int? userId;
  String? notificationTitle;
  String? notificationDescription;
  String? notificationType;
  bool? notificationIsRead;
  int? orderId;
  String? name;
  String? email;
  String? role;

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
    id: json["id"],
    userId: json["user_id"],
    notificationTitle: json["notification_title"],
    notificationDescription: json["notification_description"],
    notificationType: json["notification_type"],
    notificationIsRead: json["notification_is_read"],
    orderId: json["order_id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "notification_title": notificationTitle,
    "notification_description": notificationDescription,
    "notification_type": notificationType,
    "notification_is_read": notificationIsRead,
    "order_id": orderId,
    "name": name,
    "email": email,
    "role": role,
  };
}
