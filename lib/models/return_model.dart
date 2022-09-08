// To parse this JSON data, do
//
//     final returnModel = returnModelFromJson(jsonString);

import 'dart:convert';

ReturnModel returnModelFromJson(String str) => ReturnModel.fromJson(json.decode(str));

String? returnModelToJson(ReturnModel data) => json.encode(data.toJson());

class ReturnModel {
  ReturnModel({
    this.message,
    this.name,
    this.data,
  });

  String? message;
  String? name;
  Data? data;

  factory ReturnModel.fromJson(Map<String, dynamic> json) => ReturnModel(
    message: json["message"],
    name: json["name"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "name": name,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.count,
    this.returnProd,
  });

  int? count;
  List<ReturnProd>? returnProd;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    count: json["count"],
    returnProd: List<ReturnProd>.from(json["rows"].map((x) => ReturnProd.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "rows": List<dynamic>.from(returnProd!.map((x) => x.toJson())),
  };
}



class ReturnProd {
  ReturnProd({
    this.id,
    this.orderMerchantId,
    this.description,
    this.returnGenerate,
    this.role,
    this.createdAt,
    this.merchantId,
    this.returnDetails,
    this.orderMerchant,
  });

  int? id;
  int? orderMerchantId;
  String? description;
  String? returnGenerate;
  String? role;
  DateTime? createdAt;
  int? merchantId;
  List<ReturnDetail>? returnDetails;
  OrderMerchant? orderMerchant;

  factory ReturnProd.fromJson(Map<String, dynamic> json) => ReturnProd(
    id: json["id"],
    orderMerchantId: json["order_merchant_id"] == null ? null : json["order_merchant_id"],
    description: json["description"],
    returnGenerate: json["return_generate"],
    role: json["role"],
    createdAt: DateTime.parse(json["created_at"]),
    merchantId: json["merchant_id"],
    returnDetails: List<ReturnDetail>.from(json["return_details"].map((x) => ReturnDetail.fromJson(x))),
    orderMerchant: OrderMerchant.fromJson(json["order_merchant"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_merchant_id": orderMerchantId == null ? null : orderMerchantId,
    "description": description,
    "return_generate": returnGenerate,
    "role": role,
    "created_at": createdAt!.toIso8601String(),
    "merchant_id": merchantId,
    "return_details": List<dynamic>.from(returnDetails!.map((x) => x.toJson())),
    "order_merchant": orderMerchant!.toJson(),
  };
}
class OrderMerchant {
  OrderMerchant({
    this.id,
    this.orderGenerate,
  });

  int? id;
  String? orderGenerate;

  factory OrderMerchant.fromJson(Map<String, dynamic> json) => OrderMerchant(
    id: json["id"],
    orderGenerate: json["order_generate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_generate": orderGenerate,
  };
}
class ReturnDetail {
  ReturnDetail({
    this.id,
    this.returnDetailReturnHeaderId,
    this.productId,
    this.quantity,
    this.status,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.returnHeaderId,
    this.product,
  });

  int? id;
  int? returnDetailReturnHeaderId;
  int? productId;
  int? quantity;
  String? status;
  bool? isActive;
  DateTime? createdAt;
  dynamic updatedAt;
  int? returnHeaderId;
  Product? product;

  factory ReturnDetail.fromJson(Map<String, dynamic> json) => ReturnDetail(
    id: json["id"],
    returnDetailReturnHeaderId: json["return_header_id"],
    productId: json["product_id"],
    quantity: json["quantity"],
    status: json["status"],
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    returnHeaderId: json["returnHeaderId"],
    product: Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "return_header_id": returnDetailReturnHeaderId,
    "product_id": productId,
    "quantity": quantity,
    "status": status,
    "is_active": isActive,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt,
    "returnHeaderId": returnHeaderId,
    "product": product!.toJson(),
  };
}

class Product {
  Product({
    this.id,
    this.name,
    this.afterDiscount,
    this.productCode,
  });

  int? id;
  String? name;
  String? afterDiscount;
  String? productCode;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    afterDiscount: json["after_discount"],
    productCode: json["product_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "after_discount": afterDiscount,
    "product_code": productCode,
  };
}
