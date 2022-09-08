class LocalAddressResModel {
  String? message;
  LocalAddressData? data;

  LocalAddressResModel({
    this.message,
    this.data,
  });

  LocalAddressResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = new LocalAddressData.fromJson(json['data']);
  }
}

class LocalAddressData {
  int? count;
  List<LocalAddress>? rows;

  LocalAddressData({
    this.count,
    this.rows,
  });

  LocalAddressData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    rows = <LocalAddress>[];
    if (json['rows'] != null) {
      json['rows'].forEach((v) {
        rows?.add(new LocalAddress.fromJson(v));
      });
    }
  }
}

class LocalAddress {
  int? id;
  String? name;

  LocalAddress({
    this.id,
    this.name,
  });

  LocalAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
