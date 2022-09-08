class OrderResModel {
  String? message;
  OrderData? data;

  OrderResModel({
    this.message,
    this.data,
  });

  OrderResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = new OrderData.fromJson(json['data']);
  }
}

class OrderData {
  int? count;
  List<Order>? rows;

  OrderData({
    this.count,
    this.rows,
  });

  OrderData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    rows = <Order>[];
    if (json['rows'].length > 0 && json['rows'] != null) {
      json['rows'].forEach((v) {
        rows?.add(new Order.fromJson(v));
      });
    }
  }
}

class Order {
  int? id;
  String? companyName;
  String? generateId;
  String? shipping;
  String? payment;
  String? orderCreatedDate;
  String? confirmedDate;
  String? paymentDate;
  String? packingDate;
  String? sendDate;
  String? receivedDate;
  String? userName;
  String? status;
  double? totalPrice;
  String? paymentUrl;
  List<CartCheckout>? products;

  Order({
    this.id,
    this.companyName,
    this.generateId,
    this.shipping,
    this.payment,
    this.orderCreatedDate,
    this.paymentDate,
    this.confirmedDate,
    this.packingDate,
    this.sendDate,
    this.receivedDate,
    this.userName,
    this.status,
    this.totalPrice,
    this.paymentUrl,
    this.products,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['order_id'];
    companyName = json['company_name'];
    generateId = json['order_generate'];
    shipping = json['shipping'];
    payment = json['payment'];
    orderCreatedDate = json['ordered_date'];
    confirmedDate = json['confirmed_date'];
    paymentDate = json['payment_date'];
    sendDate = json['send_date'];
    packingDate = json['packaged_date'];
    receivedDate = json['received_date'];
    userName = json['user'];
    status = json['status'];
    paymentUrl = json['payment_url'];
    totalPrice =
        json['price_total'] != null ? json['price_total'].toDouble() : null;
    products = <CartCheckout>[];
    if (json['product'] != null) {
      json['product'].forEach((v) {
        products?.add(new CartCheckout.fromJson(v));
      });
    }
  }
}

class CartCheckout {
  int? id;
  int? quantity;
  String? productCode;
  String? productName;
  String? photo;

  CartCheckout({
    this.id,
    this.quantity,
    this.productCode,
    this.productName,
    this.photo,
  });

  CartCheckout.fromJson(Map<String, dynamic> json) {
    id = json['cart_id'];
    quantity = json['quantity'];
    productCode = json['product_code'];
    productName = json['product_name'];
    photo = json['photo'];
  }
}
