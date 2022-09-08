import 'package:intl/intl.dart';

class PromotionResModel {
  String? message;
  PromotionData? data;

  PromotionResModel({
    this.message,
    this.data,
  });

  PromotionResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = new PromotionData.fromJson(json['data']);
  }
}

class PromotionData {
  int? count;
  List<Promotion>? rows;

  PromotionData({
    this.count,
    this.rows,
  });

  PromotionData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    rows = <Promotion>[];
    if (json['rows'] != null) {
      json['rows'].forEach((v) {
        rows?.add(new Promotion.fromJson(v));
      });
    }
  }
}

// class Promotion {
//   int? id;
//   String? image;
//
//   Promotion({this.id, this.image});
//
//   Promotion.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     image = json['image'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['image'] = this.image;
//     return data;
//   }
// }

class Promotion {
  int? id;
  String? image;
  String? title;
  String? term;
  String? start;
  String? end;

  Promotion({
    this.id,
    this.image,
    this.title,
    this.term,
    this.start,
    this.end,
  });

  Promotion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    title = json['promo'];
    term = json['condition'];
    start = DateFormat('dd MMMM yyyy')
        .format(DateTime.parse((json['start_time_promo'])));
    end = DateFormat('dd MMMM yyyy')
        .format(DateTime.parse((json['end_time_promo'])));
  }
}
