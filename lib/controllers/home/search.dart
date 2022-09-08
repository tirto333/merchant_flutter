import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Product/product.dart';
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';

class SearchController extends GetxController {
  TextEditingController search = new TextEditingController();
  String indicator = 'Disc (Low > High)';
  String? selectedIndicator = 'price';
  String? sortSelected = 'ASC';
  bool grid = true;
  Timer? _debounce;
  bool complete = false;
  bool isLoading = false;

  // Other Controller
  RestApi api = Get.find<RestApi>();
  ProductController product = Get.find<ProductController>();

  void onInit() {
    super.onInit();
  }

  void onBack() {
    search.text = '';
    indicator = 'Disc (Low > High)';
    selectedIndicator = 'discount';
    sortSelected = 'ASC';
    grid = true;
    complete = false;
    update();
    Get.back();
  }

  void indicatorChange(String value) {
    switch (value) {
      case 'Disc (Low > High)':
        selectedIndicator = 'discount';
        sortSelected = 'ASC';
        break;
      case 'Disc (High > Low)':
        selectedIndicator = 'discount';
        sortSelected = 'DESC';
        break;
      case 'Name (A - Z)':
        selectedIndicator = 'name';
        sortSelected = 'ASC';
        break;
      case 'Name (Z - A)':
        selectedIndicator = 'name';
        sortSelected = 'DESC';
        break;
      default:
        break;
    }

    indicator = value;
    update(['indicator']);

    onChangeSearch();
  }

  void changeComplete() {
    complete = true;
    update();
  }

  // void loadData() async {
  //   isLoading = true;
  //   update(['product']);
  //   await loadMoreProduct();
  // }

  // Future loadMoreProduct() async {
  //   if (product.totalFilter >= product.totalFilterProducts) {
  //     isLoading = false;
  //     update(['filter-product']);
  //   } else {
  //     var form = {
  //       "search": search.text,
  //       "sort": sortSelected,
  //       "indicator": selectedIndicator
  //     };
  //
  //     await product.loadMoreProduct(
  //       section: 'filter-product',
  //       data: form,
  //     );
  //
  //     isLoading = false;
  //     update(['filter-product']);
  //   }
  // }

  void changeGrid() {
    grid = !grid;
    update(['indicator', 'filter-product']);
  }

  void onChangeSearch() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      complete = false;

      var form = {
        "search": search.text,
        "sort": sortSelected,
        "indicator": selectedIndicator
      };

      await product.getFilterProduct(data: form);
      update(['filter-product']);
    });
  }
}
