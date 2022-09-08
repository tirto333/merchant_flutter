import 'dart:async';

import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Cart/main.dart';
import 'package:winn_merchant_flutter/controllers/home/home.dart';
import 'package:winn_merchant_flutter/controllers/home/search.dart';
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';
import 'package:winn_merchant_flutter/models/Whislist/whislist_post.dart';
import 'package:winn_merchant_flutter/models/error.dart';
import 'package:winn_merchant_flutter/models/product.dart';
import 'package:winn_merchant_flutter/pages/Cart/cart.dart';
import 'package:winn_merchant_flutter/pages/detailinformation/product.dart';
import 'package:winn_merchant_flutter/screens/main_tab.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';

import '../main_tab_controller.dart';

class ProductController extends GetxController {
  Product? selectedProduct;
  bool tapToCart = false;
  bool isLoading = false;
  RestApi api = Get.find<RestApi>();
  CartController cart = Get.put(CartController());
  MainPageController tab = Get.find<MainPageController>();

  // Product List
  var products = <Product>[].obs;
  int startProduct = 0;
  int total = 0;
  int totalProducts = 0;

  // Best Seller
  var bestSeller = <Product>[].obs;
  int startBest = 0;
  int totalBest = 0;
  int totalBestProducts = 0;

  // Product Filter
  var filterProduct = <Product>[].obs;
  int startFilter = 0;
  int totalFilter = 0;
  int totalFilterProducts = 0;

  // Filter Product in Search
  /*var filterProductSearch = <Product>[].obs;
  int startFilterr = 0;
  int totalFilterr = 0;
  int totalFilterProductss = 0;*/

  Future getProduct() async {
    isLoading = true;
    try {
      total = 0;
      startProduct = 0;
      products = <Product>[].obs;

      startBest = 0;
      totalBest = 0;
      bestSeller = <Product>[].obs;

      /*var resProduct = await api.dynamicGet(
        endpoint: '/product-detail?start=$startProduct&limit=5',
        page: 'product',
        section: 'product',
        contentType: 'application/json',
      );*/

      var bestProduct = await api.dynamicGet(
        endpoint: '/product?start=$startBest&limit=5',
        page: 'product-best',
        section: 'product',
        contentType: 'application/json',
      );

      print("bestProduct $bestProduct");
      print("data bestProduct ${bestProduct.data}");

      isLoading = false;

      /*ProductData? productData = ProductResModel.fromJson(resProduct.data).data;
      totalProducts = productData?.count ?? 0;
      productData?.rows?.forEach((element) {
        products.add(element);
      });*/

      ProductData? bestData = ProductResModel.fromJson(bestProduct.data).data;
      totalBestProducts = bestData?.count ?? 0;
      bestData?.rows?.forEach((element) {
        bestSeller.add(element);
      });

      isLoading = false;
    } on ErrorResModel catch (e) {
      switch (e.statusCode) {
        case 401:
          isLoading = false;
          CustomShowDialog().tokenError(e);
          break;
        default:
          isLoading = false;
          update(['content']);
          Get.snackbar(
            'Error Get Produk',
            e.message.toString(),
            snackPosition: SnackPosition.BOTTOM,
          );
          break;
      }
    }
  }

  Future loadMoreProduct({
    String? section = 'product',
    var data,
  }) async {
    switch (section) {
      case 'best-seller':
        startBest += 5;
        totalBest += 5;

        var bestProduct = await api.dynamicGet(
          endpoint: '/best-product?start=$startBest&limit=5',
          page: 'product-best',
          section: 'product',
          contentType: 'application/json',
        );

        ProductData? bestData = ProductResModel.fromJson(bestProduct.data).data;

        bestData?.rows?.forEach((element) {
          bestSeller.add(element);
        });
        break;
      case 'filter-product':
        startFilter += 10;
        totalFilter += 10;

        var resFilter = await api.dynamicPost(
          endpoint: '/product-max-min?start=$startFilter&limit=10',
          page: 'product-filter',
          data: data,
          section: 'product',
          contentType: 'application/json',
        );

        ProductData? filterData = ProductResModel.fromJson(resFilter.data).data;

        filterData?.rows?.forEach((element) {
          filterProduct.add(element);
          bestSeller.add(element); //Untuk Get Value IsFavorite in Search
        });
        break;
      default:
        startProduct += 5;
        total += 5;

        var resProduct = await api.dynamicGet(
          endpoint: '/product-detail?start=$startProduct&limit=5',
          page: 'product',
          contentType: 'application/json',
          section: 'product',
        );

        ProductData? productData =
            ProductResModel.fromJson(resProduct.data).data;

        productData?.rows?.forEach((element) {
          products.add(element);
        });
    }
  }

  Future? toDescriptionProduct({
    int? id,
  }) async {
    try {
      var product = await api.dynamicGet(
        endpoint: '/product/${id.toString()}',
        page: 'product-detail',
        contentType: 'application/json',
        section: 'product',
      );

      selectedProduct = ProductResModel.fromJson(product.data).data?.rows?[0];

      return Get.to(ProductDescriptionPage());
    } on ErrorResModel catch (e) {
      switch (e.statusCode) {
        case 401:
          CustomShowDialog().tokenError(e);
          break;
        default:
          Get.snackbar(
            'Error',
            e.message.toString(),
            snackPosition: SnackPosition.BOTTOM,
          );
          break;
      }
    }
  }

  Future getFilterProduct({dynamic data}) async {
    try {
      startFilter = 0;
      totalFilter = 0;
      filterProduct = <Product>[].obs;
      bestSeller = <Product>[].obs; //Untuk Get Value IsFavorite in Search

      var resFilter = await api.dynamicPost(
        endpoint: '/product-max-min?start=$startFilter&limit=10',
        page: 'product-filter',
        section: 'product',
        data: data,
        contentType: 'application/json',
      );

      print("DATA PRODUCT FILTER ${resFilter.data}");

      ProductData? filterData = ProductResModel.fromJson(resFilter.data).data;
      totalFilterProducts = filterData?.count ?? 0;
      filterProduct.clear();
      bestSeller.clear();
      filterData?.rows?.forEach((element) {
        //filterProductSearch.add(element);
        filterProduct.add(element);
        bestSeller.add(element); //Untuk Get Value IsFavorite in Search
      });
    } on ErrorResModel catch (e) {
      switch (e.statusCode) {
        case 401:
          CustomShowDialog().tokenError(e);
          break;
        default:
          Get.snackbar(
            'Error',
            e.message.toString(),
            snackPosition: SnackPosition.BOTTOM,
          );
          break;
      }
    }
  }

  void wishProd({int? id, int? wishId}) async {
    HomeController homeController = Get.find();
    SearchController search = Get.put(SearchController());

    print("DATA ADD WISHLIST  $id $wishId");
    try {
      Product _product = Product();
      Product _bestSeller = Product();

      for (var value in products) {
        if (value.id == id) {
          _product = value;
        }
      }

      for (var value in homeController.bestSellerProd) {
        if (value.id == id) {
          _bestSeller = value;
          if (_product.id == null) {
            _product = value;
          }
        }
      }

      if (_product.id == null && _bestSeller.id == null) {
        for (var value in filterProduct) {
          if (value.id == id) {
            _bestSeller = value;
            _product = value;
          }
        }
      }

      if (_bestSeller.id == null) {
        _bestSeller = _product;
      }

      // Product _product = products.firstWhere((element) => element.id == id);
      //Product _bestSeller = homeController.bestSellerProd.firstWhere((element) => element.id == id);

      print("DATA is Favorit ${_bestSeller.isFavorite}");
      print("DATA is Favorit ${_bestSeller.whishlistId}");

      if (_bestSeller.isFavorite == false) {
        var response = await api.dynamicPost(
          endpoint: '/wishlist-input',
          page: 'wishlist-add',
          section: 'user',
          data: {
            "product_id": id,
          },
          contentType: 'application/json',
        );

        if (response.statusCode == 200) {
          WishlistPost? data =
              WishlistPostResModel.fromJson(response.data).data;

          selectedProduct?.isFavorite = true;
          selectedProduct?.whishlistId = data?.idWishlist;
          update(['love-icon']);

          // newList.isFavorite = true;
          // newList.whishlistId = data?.idWishlist;

          _bestSeller.isFavorite = true;
          _bestSeller.whishlistId = data?.idWishlist;
          Get.find<HomeController>().bestSellerProd.forEach(
            (element) {
              if (element.id == id) {
                element.isFavorite = true;
                element.whishlistId = data?.idWishlist;
              }
            },
          );
          Get.find<HomeController>().update();
          for (var value in filterProduct) {
            if (value.id == _product.id) {
              value.isFavorite = true;
              value.whishlistId = data?.idWishlist;
              search.update(['filter-product']);
              break;
            }
          }

          update();
        }
      } else {
        print("masuk sini");
        print("masuk wistId $wishId");
        var response = await api.dynamicDelete(
          endpoint: '/wishlist-delete/${wishId.toString()}',
          page: 'wishlist-delete',
          section: 'user',
          data: {
            "product_id": id,
          },
          contentType: 'application/json',
        );

        if (response.statusCode == 200) {
          selectedProduct?.isFavorite = false;
          selectedProduct?.whishlistId = null;
          update(['love-icon']);

          // newList.isFavorite = false;
          // newList.whishlistId = null;

          _bestSeller.isFavorite = false;
          _bestSeller.whishlistId = null;
          Get.find<HomeController>().bestSellerProd.forEach(
            (element) {
              if (element.id == id) {
                element.isFavorite = false;
                element.whishlistId = null;
              }
            },
          );

          Get.find<HomeController>().update();
          for (var value in filterProduct) {
            if (value.id == _product.id) {
              value.isFavorite = false;
              value.whishlistId = null;
              search.update(['filter-product']);
              break;
            }
          }
          update();
        }
      }
    } on ErrorResModel catch (e) {
      print("ERROR MASUK SINI NI ${e.message}");
      print("ERROR MASUK SINI NI ${e.statusCode}");
      switch (e.statusCode) {
        case 401:
          CustomShowDialog().tokenError(e);
          break;
        default:
          Get.snackbar(
            'Error',
            e.message.toString(),
            snackPosition: SnackPosition.BOTTOM,
          );
          break;
      }
    }
  }

  void onCartTap({int? productId}) async {
    try {
      tapToCart = true;
      update(['cart-button']);

      await cart.addToCart(productId: productId);

      Timer(Duration(seconds: 10), () {
        tapToCart = false;
        update(['cart-button']);
      });
    } on ErrorResModel catch (e) {
      switch (e.statusCode) {
        case 401:
          CustomShowDialog().tokenError(e);
          break;
        default:
          Get.snackbar(
            'Error',
            e.message.toString(),
            snackPosition: SnackPosition.BOTTOM,
          );
          break;
      }
    }
  }

  void toCart() async {
    Get.offUntil(GetPageRoute(page: () => MainPage()), (route) => true);
    Get.to(() => CartPage());
    //tab.updateContent(index: 3);
  }
}
