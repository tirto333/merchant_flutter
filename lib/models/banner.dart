class BannerResModel {
  String? message;
  BannerData? data;

  BannerResModel({
    this.message,
    this.data,
  });

  BannerResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = new BannerData.fromJson(json['data']);
  }
}

class BannerData {
  int? count;
  List<Banner>? rows;

  BannerData({
    this.count,
    this.rows,
  });

  BannerData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    rows = <Banner>[];
    if (json['rows'] != null) {
      json['rows'].forEach((v) {
        rows?.add(new Banner.fromJson(v));
      });
    }
  }
}

class Banner {
  int? id;
  String? image;

  Banner({
    this.id,
    this.image,
  });

  Banner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }
}
