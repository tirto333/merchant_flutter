
import 'package:winn_merchant_flutter/models/user_address.dart';

import 'order.dart';

class OrderDetailResModel {
  String? status;
  String? message;
  OrderDetail? data;

  OrderDetailResModel({
    this.status,
    this.message,
    this.data,
  });

  OrderDetailResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = new OrderDetail.fromJson(json['data']);
  }
}

class OrderDetail {
  Order? order;
  UserAddress? address;
  List<OrderProduct>? productOverviews;
  int? quantity;
  double? weight;
  // double? subTotal;
  // double? shippingPrice;
  // double? conveniecePrice;
  int? totalPrice;


  OrderDetail({
    this.order,
    this.address,
    this.quantity,
    this.weight,
    // this.subTotal,
    // this.shippingPrice,
    // this.conveniecePrice,
    this.totalPrice,
    this.productOverviews,
  });

  OrderDetail.fromJson(Map<String, dynamic> json) {
    order = new Order.fromJson(json['order']);
    address =
        json['addres'] != null ? UserAddress.fromJson(json['addres']) : null;
    productOverviews = <OrderProduct>[];
    if (json['product_overview'] != null) {
      json['product_overview'].forEach((v) {
        productOverviews?.add(new OrderProduct.fromJson(v));
      });
    }
    quantity = json['quantity'];
    weight = json['weight'].toDouble();
    // subTotal = json['price_subtotal'].toDouble();
    // shippingPrice = json['price_shipping'].toDouble();
    // conveniecePrice = json['price_convenience'].toDouble();
    totalPrice = json['price_total'];
  }
}

class OrderProduct {
  int? cartId;
  String? productCode;
  double? subTotal;
  String? productName;
  double? weight;
  int? quantity;
  String? photo;

  OrderProduct({
    this.cartId,
    this.productCode,
    this.productName,
    this.subTotal,
    this.weight,
    this.quantity,
    this.photo,
  });

  OrderProduct.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    productCode = json['product_code'];
    photo = json['photo'];
    subTotal = json['subtotal'].toDouble();
    productName = json['product_name'];
    weight = json['weight'].toDouble();
    quantity = (json['quantity']);
  }
}
