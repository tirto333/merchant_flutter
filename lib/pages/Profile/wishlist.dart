import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Profile/wishlist.dart';
import 'package:winn_merchant_flutter/widgets/card/product_horizontal.dart';
import 'package:winn_merchant_flutter/widgets/card/product_wishlist_card.dart';
import 'package:winn_merchant_flutter/widgets/custom_appbar.dart';

class WishlistPage extends StatelessWidget {
  final WishlistController controller = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar().generalAppBar(
        title: "My Wishlist",
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: GetBuilder<WishlistController>(
        id: 'wishlist-content',
        builder: (_) {
          return RefreshIndicator(
            onRefresh: controller.initial,
            child: NotificationListener(
              onNotification: (ScrollNotification scrollInfo) {
                if (!controller.isLoading &&
                    scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent &&
                    !controller.complete) {
                  if (controller.total >= controller.totalProducts) {
                    controller.changeComplete();
                    Get.snackbar(
                      'Wishlist',
                      'Semua wishlist sudah dikeluarkan',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    controller.loadMoreProduct();
                  }
                }
                return false;
              },
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.wishProducts.length,
                itemBuilder: (context, index) {
                  double listItemWidth =
                      MediaQuery.of(context).size.width - 2 * 10;

                  return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 15.0,
                      ),
                      child: Stack(
                        children: [
                          ProductWhislistCard(
                            whislist: controller.wishProducts[index],
                            itemWidth: listItemWidth,
                            url: controller.api.content,
                            onTap: () {
                              controller.toDetail(
                                id: controller.wishProducts[index].productId,
                              );
                            },
                          ),
                          Positioned(
                            bottom: 14,
                            right: 14,
                            child: InkWell(
                              onTap: () => controller.unSaveProduct(
                                controller.wishProducts[index].productId
                                    .toString(),
                                controller.wishProducts[index].wishlistId
                                    .toString(),
                                context,
                              ),
                              child:
                                  SvgPicture.asset('assets/icons/delete.svg'),
                            ),
                          ),
                        ],
                      ));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
