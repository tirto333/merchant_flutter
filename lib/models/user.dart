class UserResModel {
  String? message;
  User? data;

  UserResModel({
    this.message,
    this.data,
  });

  UserResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data = new User.fromJson(v);
      });
    }
  }

  // UserResModel.fromJson(Map<String, dynamic> json) {
  //   message = json['message'];
  //   data = json['data'] != null ? new User.fromJson(json['data']) : null;
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['message'] = this.message;
  //   if (this.data != null) {
  //     data['data'] = this.data!.toJson();
  //   }
  //   return data;
  // }
}

class User {
  // int? id;
  // String? dob;
  // String? profile;
  // String? name;
  // String? email;
  // String? phone;
  // String? title;
  // String? nik;
  // String? placeBirth;
  // String? phoneOffice;
  // String? companyName;
  // String? username;
  // String? npwp;
  // String? status;
  // String? role;

  //NEW
  int? id;
  String? companyName;
  String? name;
  String? nik;
  String? username;
  String? npwp;
  String? photo;
  String? email;
  String? phone;
  String? phoneOffice;
  String? status;
  String? role;
  String? province;
  String? cities;
  String? subdistricts;
  String? urbanVillage;
  String? address;
  String? label;

  User({
    // this.dob,
    // this.profile,
    // this.name,
    // this.email,
    // this.phone,
    // this.title,
    // this.nik,
    // this.placeBirth,
    // this.phoneOffice,
    // this.companyName,
    // this.username,
    // this.npwp,
    // this.status,
    // this.role,

    this.id,
    this.companyName,
    this.name,
    this.nik,
    this.username,
    this.npwp,
    this.photo,
    this.email,
    this.phone,
    this.phoneOffice,
    this.status,
    this.role,
    this.province,
    this.cities,
    this.subdistricts,
    this.urbanVillage,
    this.address,
    this.label
  });

  User.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    // title = json['title'];
    // name = json['name'];
    // email = json['email'];
    // phone = json['phone'];
    // placeBirth = json['place_dob'];
    // dob = json['dob'];
    // nik = json['nik'];
    // profile = json['photo'];
    // phoneOffice = json['phoneOffice'];
    // companyName = json['company_name'];
    // username = json['username'];
    // npwp = json['npwp'];
    // status = json['npwp'];
    // role = json['role'];

    id = json['id'];
    companyName = json['company_name'];
    name = json['name'];
    nik = json['nik'];
    username = json['username'];
    npwp = json['npwp'];
    photo = json['photo'];
    email = json['email'];
    phone = json['phone'];
    phoneOffice = json['phone_office'];
    status = json['status'];
    role = json['role'];
    province = json['province'];
    cities = json['cities'];
    subdistricts = json['subdistricts'];
    urbanVillage = json['urban_village'];
    address = json['address'];
    label = json['label'];
  }
}
