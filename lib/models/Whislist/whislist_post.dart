class WishlistPostResModel {
  String? message;
  WishlistPost? data;

  WishlistPostResModel({
    this.message,
    this.data,
  });

  WishlistPostResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = new WishlistPost();
    if (json['data'] != null) {
      data = WishlistPost.fromJson(json['data']);
    }
  }
}

class WishlistPost {
  int? idWishlist;

  WishlistPost({
    this.idWishlist,
  });

  WishlistPost.fromJson(Map<String, dynamic> json) {
    idWishlist = json['id'];
  }
}