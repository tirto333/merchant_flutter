class ShippingPriceModel {
  String? message;
  ShippingPrice? data;

  ShippingPriceModel({
    this.message,
    this.data,
  });

  ShippingPriceModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data =
        json['data'] != null ? new ShippingPrice.fromJson(json['data']) : null;
  }
}

class ShippingPrice {
  double? price;

  ShippingPrice({
    this.price,
  });

  ShippingPrice.fromJson(Map<String, dynamic> json) {
    price = json['price'] != null ? json['price'].toDouble() : null;
  }
}
