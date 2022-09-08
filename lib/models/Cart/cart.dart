class CartResModel {
  String? message;
  CartData? data;

  CartResModel({
    this.message,
    this.data,
  });

  CartResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = new CartData.fromJson(json['data']);
  }
}

class CartData {
  int? count;
  List<Cart>? rows;

  CartData({
    this.count,
    this.rows,
  });

  CartData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    rows = <Cart>[];
    if (json['rows'] != null) {
      json['rows'].forEach((v) {
        rows?.add(new Cart.fromJson(v));
      });
    }
  }
}

class Cart {
  int? id;
  String? name;
  int? productId;
  String? category;
  String? description;
  String? imageUrl;
  double? normalPrice;
  double? discountedPrice;
  String? dimension;
  double? weight;
  int? stock;
  double? discount;
  double? totalPrice;
  String? productCode;
  String? typePressure;
  int? quantity;
  bool isCheckout = false;

  Cart({
    this.id,
    this.name,
    this.productId,
    this.category,
    this.imageUrl,
    this.normalPrice = 0,
    this.discountedPrice = 0,
    this.stock = 0,
    this.discount = 0,
    this.typePressure,
    this.weight,
    this.description,
    this.dimension,
    this.productCode,
    this.totalPrice = 0,
    this.quantity,
    this.isCheckout = false,
  });

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productId = json['product_id'];
    category = json['category'];
    imageUrl = json['image'];
    //discount = json['discount'].toDouble();
    typePressure = json['type_pressure'];
    description = json['description'];
    dimension = json['dimension'];
    weight = json['weight'] != null ? json['weight'].toDouble() : null;
    //normalPrice = json['price'].toDouble();
    // discountedPrice = json['after_discount'].toDouble();
    productCode = json['product_code'];
    //totalPrice = json['total_price'].toDouble();
    quantity = json['quantity'];
    stock = json['stock'];
    isCheckout = json['is_checkout'];
  }
}
