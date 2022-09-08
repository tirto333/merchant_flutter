// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  ChatModel({
    this.message,
    this.messageMerchant,
    this.messageAdmin,
  });

  String? message;
  Message? messageMerchant;
  Message? messageAdmin;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    message: json["message"],
    messageMerchant: Message.fromJson(json["message_merchant"]),
    messageAdmin: Message.fromJson(json["message_admin"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "message_merchant": messageMerchant?.toJson(),
    "message_admin": messageAdmin?.toJson(),
  };
}

class Message {
  Message({
    this.status,
    this.message,
  });

  int? status;
  List<MessageElement>? message;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    status: json["status"],
    message: List<MessageElement>.from(json["message"].map((x) => MessageElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": List<dynamic>.from(message!.map((x) => x.toJson())),
  };
}

class MessageElement {
  MessageElement({
    this.merchantId,
    this.adminId,
    this.role,
    this.seenAt,
    this.sentAt,
    this.isActive,
    this.messageAdmin,
    this.messageUser,
  });

  int? merchantId;
  int? adminId;
  Role? role;
  String? seenAt;
  int? sentAt;
  bool? isActive;
  String? messageAdmin;
  String? messageUser;

  factory MessageElement.fromJson(Map<String, dynamic> json) => MessageElement(
    merchantId: json["merchant_id"],
    adminId: json["admin_id"],
    role: roleValues.map![json["role"]],
    seenAt: json["seenAt"],
    sentAt: json["sentAt"],
    isActive: json["is_active"],
    messageAdmin: json["message_admin"] == null ? null : json["message_admin"],
    messageUser: json["message_user"] == null ? null : json["message_user"],
  );

  Map<String, dynamic> toJson() => {
    "merchant_id": merchantId,
    "admin_id": adminId,
    "role": roleValues.reverse![role],
    "seenAt": seenAt,
    "sentAt": sentAt,
    "is_active": isActive,
    "message_admin": messageAdmin == null ? null : messageAdmin,
    "message_user": messageUser == null ? null : messageUser,
  };
}

enum Role { ADMIN, MERCHANT }

final roleValues = EnumValues({
  "admin": Role.ADMIN,
  "merchant": Role.MERCHANT
});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map?.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
