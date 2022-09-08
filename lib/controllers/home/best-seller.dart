import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Product/product.dart';
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';
import 'package:winn_merchant_flutter/models/category.dart';
import 'package:winn_merchant_flutter/models/error.dart';
import 'package:winn_merchant_flutter/models/product.dart';
import 'package:winn_merchant_flutter/pages/Home/best_seller.dart';
import 'package:winn_merchant_flutter/pages/Home/best_seller_product.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';

class BestSellerController extends GetxController {
  List<Category>? categories;
  int? selectedCategory;
  bool isLoading = false;
  bool complete = false;

  // Best Seller Product
  var bestSellerProd = <Product>[].obs;
  int startBestSeller = 0;
  int totalBestSeller = 0;
  int totalBestSellerProducts = 0;

  RestApi api = Get.find<RestApi>();
  ProductController product = Get.find<ProductController>();

  void toCategory() async {
    try {
      var response = await api.dynamicGet(
        section: 'product',
        endpoint: '/category',
        page: 'product-category',
        contentType: "application/json",
      );

      print("----------------------------");
      print("HASIL ${response.data}");
      print("----------------------------");

      categories = CategoryResModel.fromJson(response.data).data?.rows;

      //Get.to(BestSellerPage());
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

  // void toProductCategory({int? id}) async {
  //   try {
  //     complete = false;
  //     bestSellerProd = <Product>[].obs;
  //     startBestSeller = 0;
  //     totalBestSeller = 5;
  //     totalBestSellerProducts = 0;
  //
  //     var bestProd = await api.dynamicGet(
  //       section: 'product',
  //       endpoint: '/product-by-category/$id?start=$startBestSeller&limit=5',
  //       contentType: 'application/json',
  //       page: 'best-seller-token',
  //     );
  //
  //     ProductData? bestData = ProductResModel.fromJson(bestProd.data).data;
  //     totalBestSellerProducts = bestData?.count ?? 0;
  //     bestData?.rows?.forEach((element) {
  //       bestSellerProd.add(element);
  //     });
  //
  //     update(['best-seller-product']);
  //     Get.to(BestSellerProductCategoryScreen());
  //   } on ErrorResModel catch (e) {
  //     switch (e.statusCode) {
  //       case 401:
  //         CustomShowDialog().tokenError(e);
  //         break;
  //       default:
  //         Get.snackbar(
  //           'Error',
  //           e.message.toString(),
  //           snackPosition: SnackPosition.BOTTOM,
  //         );
  //         break;
  //     }
  //   }
  // }

  void changeComplete() {
    complete = true;
    update();
  }

  void loadData() async {
    isLoading = true;
    update(['best-seller-product']);
    await loadMoreProduct(section: 'product');
  }

  Future loadMoreProduct({String? section = 'product'}) async {
    startBestSeller += 5;
    totalBestSeller += 5;

    var bestProduct = await api.dynamicGet(
      section: 'product',
      endpoint: '/best-product?start=?start=$startBestSeller&limit=5',
      page: 'product',
      contentType: 'application/json',
    );

    ProductData? bestData = ProductResModel.fromJson(bestProduct.data).data;

    bestData?.rows?.forEach((element) {
      bestSellerProd.add(element);
    });

    isLoading = false;
    update(['best-seller-product']);
  }
}
