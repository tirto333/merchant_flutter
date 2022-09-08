class WishlistResModel {
  String? message;
  WishlistData? data;

  WishlistResModel({
    this.message,
    this.data,
  });

  WishlistResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = new WishlistData.fromJson(json['data']);
  }
}

class WishlistData {
  int? count;
  List<Wishlist>? rows;

  WishlistData({
    this.count,
    this.rows,
  });

  WishlistData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    rows = <Wishlist>[];
    if (json['rows'] != null) {
      json['rows'].forEach((v) {
        rows?.add(new Wishlist.fromJson(v));
      });
    }
  }
}

class Wishlist {
  int? wishlistId;
  int? productId;
  String? name;
  String? category;
  String? imageUrl;
  double? normalPrice;
  double? discountedPrice;
  double? discount;
  String? productCode;
  String? typePressure;

  Wishlist({
    this.productId,
    this.wishlistId,
    this.name,
    this.category,
    this.imageUrl,
    this.normalPrice,
    this.discountedPrice,
    this.discount = 0,
    this.typePressure,
    this.productCode,
  });

  Wishlist.fromJson(Map<String, dynamic> json) {
    wishlistId = json['id'];
    productId = json['product_id'];
    name = json['name'];
    category = json['category'];
    imageUrl = json['image'];
    normalPrice = json['price'].toDouble();
    discountedPrice = json['after_discount'].toDouble();
    productCode = json['product_code'];
    typePressure = json['type_pressure'];
    discount = json['discount'].toDouble();
  }
}
