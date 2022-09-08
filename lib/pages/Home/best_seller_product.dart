import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:winn_merchant_flutter/controllers/home/best-seller.dart';
import 'package:winn_merchant_flutter/controllers/home/home.dart';
import 'package:winn_merchant_flutter/widgets/product_card.dart';

class BestSellerProductCategoryScreen extends StatelessWidget {
  BestSellerProductCategoryScreen({ this.tittle });
  //final BestSellerController controller = Get.find<BestSellerController>();
  final HomeController controller = Get.put(HomeController());
  final String? tittle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tittle!, style: TextStyle(color: Colors.black87),),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_outlined),
        ),
      ),
      body: GetBuilder<BestSellerController>(
        id: 'best-seller-product',
        builder: (_) {
          return NotificationListener(
            onNotification: (ScrollNotification scrollInfo) {
              if (!controller.isLoading &&
                  scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent &&
                  !controller.complete) {
                if (controller.product.total >=
                    controller.product.totalProducts) {
                  controller.changeComplete();
                  Get.snackbar(
                    'Product',
                    'Semua produk sudah dikeluarkan',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } else {
                  controller.loadData();
                }
              }
              return false;
            },
            child: productBody(context),
          );
        },
      ),
    );
  }

  ListView productBody(BuildContext context) {
    print("controller.isLoading");
    // print(controller.bestSellerProd.length);
    // print(controller.isLoading);
    return ListView(
      physics: BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 5.0,
          ),
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 300,
            ),
            itemCount: controller.bestSellerProd.length,
            // itemCount: controller.product.bestSeller.length,
            itemBuilder: (context, idx) {
              return ProductCard(
                index: idx,
                product: controller.bestSellerProd[idx],
                onTap: () {
                  controller.product.toDescriptionProduct(
                    id: controller.bestSellerProd[idx].id,
                  );
                },
                url: controller.api.content,

              );
            },
          ),
        ),
        controller.isLoading
            ? Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(),
      ],
    );
  }
}
