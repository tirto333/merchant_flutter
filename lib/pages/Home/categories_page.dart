import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:winn_merchant_flutter/controllers/home/best-seller.dart';
import 'package:winn_merchant_flutter/controllers/home/home.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';

class CategoriesPage extends StatelessWidget {
  CategoriesPage({this.tittle});

  final HomeController controller = Get.put(HomeController());
  final String? tittle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tittle!,
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_outlined),
        ),
      ),
      body: GetBuilder<BestSellerController>(
        id: 'sub-categories',
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
            child: SingleChildScrollView(
              child: GetBuilder<HomeController>(
                id: 'sub-category',
                builder: (_) {
                  return GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                    ),
                    itemCount: controller.subCategories == null ? 0 : controller.subCategories!.length,
                    itemBuilder: (c, i) {
                      return cardBody(i, context);
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Padding cardBody(int i, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 10.0,
      ),
      child: GestureDetector(
        onTap: () {
          print("cardBody");
          controller.toProductCategory(
              id: controller.subCategories?[i].id,
              tittle: controller.subCategories?[i].category);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 7,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: controller.subCategories?.length != null
                    ? CachedNetworkImage(
                        imageUrl:
                            '${controller.api.content}/category/${controller.subCategories?[i].image}',
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            ),
                          ],
                        ),
                        errorWidget: (context, url, error) => SizedBox(
                            height: 16,
                            width: 16,
                            child: Center(child: CircularProgressIndicator())),
                      )
                    : SizedBox(
                        height: 16,
                        width: 16,
                        child: Center(child: CircularProgressIndicator())),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: WinnGeneralText(
                    title: controller.subCategories?[i].category,
                    border: TextDecoration.none,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    colorTitle: Colors.black,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
