// To parse this JSON data, do
//
//     final requestModel = requestModelFromJson(jsonString);

import 'dart:convert';

RequestModel requestModelFromJson(String str) => RequestModel.fromJson(json.decode(str));

String? requestModelToJson(RequestModel data) => json.encode(data.toJson());

class RequestModel {
  RequestModel({
    this.message,
    this.data,
  });

  String? message;
  List<Products>? data;

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
    message: json["message"],
    data: List<Products>.from(json["data"].map((x) => Products.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Products {
  Products({
    this.productId,
    this.orderId,
    this.orderGenerate,
    this.productName,
    this.categoryId,
    this.categoryName,
    this.quantity,
  });

  int? productId;
  int? orderId;
  String? orderGenerate;
  String? productName;
  int? categoryId;
  String? categoryName;
  String? quantity;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    productId: json["product_id"],
    orderId: json["order_id"],
    orderGenerate: json["order_generate"],
    productName: json["product_name"],
    categoryId: json["category_id"],
    categoryName: json["category_name"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "order_id": orderId,
    "order_generate": orderGenerate,
    "product_name": productName,
    "category_id": categoryId,
    "category_name": categoryName,
    "quantity": quantity,
  };
}
