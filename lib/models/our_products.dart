//import 'dart:convert';

// OurProduct ourProductFromJson(String str) => OurProduct.fromJson(json.decode(str));
//
// String ourProductToJson(OurProduct data) => json.encode(data.toJson());

class OurProductResModel {
  OurProductResModel({
    this.message,
    this.data,
  });

  String? message;
  Data? data;

  factory OurProductResModel.fromJson(Map<String, dynamic> json) => OurProductResModel(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.count,
    this.rows,
  });

  int? count;
  List<Row1>? rows;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    count: json["count"],
    rows: List<Row1>.from(json["rows"].map((x) => Row1.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "rows": List<dynamic>.from(rows!.map((x) => x.toJson())),
  };
}

class Row1 {
  Row1({
    this.id,
    this.category,
    this.image,
  });

  int? id;
  String? category;
  String? image;

  factory Row1.fromJson(Map<String, dynamic> json) => Row1(
    id: json["id"],
    category: json["category"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category,
    "image": image,
  };
}
