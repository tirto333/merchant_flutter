import '../user_address.dart';

class CheckoutResModel {
  String? message;
  CheckoutData? data;

  CheckoutResModel({
    this.message,
    this.data,
  });

  CheckoutResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = new CheckoutData.fromJson(json['data']);
  }
}

class CheckoutData {
  int? count;
  Checkout? rows;

  CheckoutData({
    this.count,
    this.rows,
  });

  CheckoutData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    rows = new Checkout.fromJson(json['rows']);
  }
}

class Checkout {
  UserAddress? address;
  int? quantity;
  double? subtotal;
  double? weight;
  double? convenienceFee;
  List<ProductOverview>? productOverviews;

  Checkout({
    this.address,
    this.quantity,
    this.subtotal,
    this.weight,
    this.convenienceFee,
    this.productOverviews,
  });

  Checkout.fromJson(Map<String, dynamic> json) {
    address = json['addres'] != null
        ? new UserAddress.fromJson(json['addres'])
        : null;
    quantity = json['quantity'];
    subtotal = json['subtotal'].toDouble();
    weight = json['weight'].toDouble();
    convenienceFee = json['convinience_fee'].toDouble();
    productOverviews = <ProductOverview>[];
    if (json['product_overview'].length > 0 &&
        json['product_overview'] != null) {
      json['product_overview'].forEach((v) {
        productOverviews?.add(new ProductOverview.fromJson(v));
      });
    }
  }
}

class ProductOverview {
  int? cartId;
  int? productId;
  double? afterDiscount;
  String? productName;
  double? weight;
  double? discount;
  int? quantity;
  int? stock;

  ProductOverview({
    this.cartId,
    this.productId,
    this.afterDiscount,
    this.productName,
    this.weight,
    this.discount,
    this.quantity,
    this.stock,
  });

  ProductOverview.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    productId = json['product_id'];
    afterDiscount = json['after_discount'].toDouble();
    productName = json['product_name'];
    weight = json['weight'].toDouble();
    discount = json['discount'].toDouble();
    quantity = json['quantity'];
    stock = json['stock'];
  }
}
