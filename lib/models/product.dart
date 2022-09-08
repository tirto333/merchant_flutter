class ProductResModel {
  String? message;
  ProductData? data;

  ProductResModel({
    this.message,
    this.data,
  });

  ProductResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = new ProductData.fromJson(json['data']);
  }
}

class ProductData {
  int? count;
  List<Product>? rows;

  ProductData({
    this.count,
    this.rows,
  });

  ProductData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    rows = <Product>[];
    if (json['rows'].length > 0 && json['rows'] != null) {
      json['rows'].forEach((v) {
        rows?.add(new Product.fromJson(v));
      });
    }
  }
}

class Product {
  int? id;
  int? whishlistId;
  String? name;
  String? category;
  String? description;
  String? imageUrl;
  double? normalPrice;
  double? discountedPrice;
  String? dimension;
  String? weight;
  int? stock;
  double? discount;
  bool? isFavorite;
  String? productCode;
  String? typePressure;
  int? pcs;
  bool? statusWishlist;
  String? image;

  Product({
    this.id,
    this.whishlistId,
    this.name,
    this.category,
    this.imageUrl,
    this.normalPrice,
    this.discountedPrice,
    this.stock = 999,
    this.discount = 0,
    this.typePressure,
    this.weight,
    this.description,
    this.dimension,
    this.productCode,
    this.isFavorite = false,
    this.pcs,
    this.statusWishlist,
    this.image
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    whishlistId = json['wishlist_id'];
    name = json['name'];
    category = json['category'];
    imageUrl = json['image'];
    discount = json['discount'] != null ? json['discount'].toDouble() : null;
    typePressure = json['type_pressure'];
    description = json['description'];
    dimension = json['dimension'];
    weight = json['weight'] != null ? json['weight'].toString() : null;
    stock = json['stock'];
    normalPrice = json['price'] != null ? json['price'].toDouble() : null;
    discountedPrice = json['after_discount'] != null
        ? json['after_discount'].toDouble()
        : null;
    productCode = json['product_code'];
    isFavorite = json['status_wishlist'];
    pcs = json['pcs'];
    statusWishlist = json['status_wishlist'];
    image = json['image'];
  }
}
