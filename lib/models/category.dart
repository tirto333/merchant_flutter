class CategoryResModel {
  String? message;
  CategoryData? data;

  CategoryResModel({
    this.message,
    this.data,
  });

  CategoryResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = new CategoryData.fromJson(json['data']);
  }
}

class CategoryData {
  int? count;
  List<Category>? rows;
  CategoryData({
    this.count,
    this.rows,
  });

  CategoryData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    rows = <Category>[];
    if (json['rows'] != null) {
      json['rows'].forEach((v) {
        rows?.add(new Category.fromJson(v));
      });
    }
  }
}

class Category {
  int? id;
  String? name;
  String? imageUrl;

  Category({
    this.id,
    this.name,
    this.imageUrl,
  });

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['image'];
  }
}
