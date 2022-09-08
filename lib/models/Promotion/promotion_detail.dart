class PromotionDetailResModel {
  String? message;
  List<DataDetail>? data;

  PromotionDetailResModel({this.message, this.data});

  PromotionDetailResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <DataDetail>[];
      json['data'].forEach((v) {
        data!.add(new DataDetail.fromJson(v));
      });
    }
  }
}

class DataDetail {
  int? id;
  String? image;
  String? promo;
  String? condition;
  String? startTimePromo;
  String? endTimePromo;

  DataDetail(
      {this.id,
        this.image,
        this.promo,
        this.condition,
        this.startTimePromo,
        this.endTimePromo});

  DataDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    promo = json['promo'];
    condition = json['condition'];
    startTimePromo = json['start_time_promo'];
    endTimePromo = json['end_time_promo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['promo'] = this.promo;
    data['condition'] = this.condition;
    data['start_time_promo'] = this.startTimePromo;
    data['end_time_promo'] = this.endTimePromo;
    return data;
  }
}