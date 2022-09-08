class UserAddressResModel {
  String? message;
  UserAddressData? data;

  UserAddressResModel({
    this.message,
    this.data,
  });

  UserAddressResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new UserAddressData.fromJson(json['data']) : null;
  }
}

class UserAddressData {
  int? count;
  List<UserAddress>? rows;

  UserAddressData({
    this.count,
    this.rows,
  });

  UserAddressData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    rows = <UserAddress>[];
    if (json['rows'] != null) {
      json['rows'].forEach((v) {
        rows!.add(new UserAddress.fromJson(v));
      });
    }
  }
}

class UserAddress {
  int? id;
  int? userId;
  String? name;
  String? phone;
  String? role;
  String? label;
  String? email;
  String? address;
  int? province;
  int? city;
  int? subDistrict;
  int? urbanVillage;
  String? postalCode;
  String? status;
  int? deleted;
  String? createdAt;
  String? updatedAt;
  String? merchantId;
  LocalCoordinate? map;

  UserAddress({
    this.id,
    this.userId,
    this.name,
    this.phone,
    this.role,
    this.label,
    this.email,
    this.address,
    this.province,
    this.city,
    this.subDistrict,
    this.urbanVillage,
    this.postalCode,
    this.status,
    this.deleted,
    this.createdAt,
    this.updatedAt,
    this.merchantId,
    this.map,
  });

  UserAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    role = json['role'];
    label = json['label'];
    address = json['address'];
    province = json['province'];
    city = json['city'];
    subDistrict = json['sub_district'];
    urbanVillage = json['urban_village'];
    postalCode = json['postal_code'];
    // map = json['map'];
    status = json['status'];
    deleted = json['deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    merchantId = json['merchantId'];
    map = (json['map'] != null && json['map'].runtimeType != String)
        ? LocalCoordinate.fromJson(json['map'])
        : null;
    // map = json['map'] != null ? new Map.fromJson(json['map']) : null;
  }
}

class LocalCoordinate {
  double? latitude;
  double? longitude;

  LocalCoordinate({
    this.latitude,
    this.longitude,
  });

  LocalCoordinate.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }
}
