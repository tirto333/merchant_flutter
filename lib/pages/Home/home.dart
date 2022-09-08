import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:path/path.dart';
import 'package:winn_merchant_flutter/controllers/Profile/chat.dart';
import 'package:winn_merchant_flutter/controllers/home/best-seller.dart';
import 'package:winn_merchant_flutter/controllers/home/home.dart';
// import 'package:winn_merchant_flutter/models/banner.dart';
import 'package:winn_merchant_flutter/pages/Cart/cart.dart';
// import 'package:winn_merchant_flutter/pages/Home/notification.dart';
import 'package:winn_merchant_flutter/pages/Profile/chat.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/card/product_horizontal.dart';
// import 'package:winn_merchant_flutter/widgets/custom_button.dart';
import 'package:winn_merchant_flutter/widgets/custom_carousel.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';
// import 'package:winn_merchant_flutter/widgets/product_card.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final BestSellerController bestController = Get.find<BestSellerController>();

  var context;

  @override
  Widget build(BuildContext context) {
    context = context;
    return WillPopScope(
      onWillPop: () {
        controller.quitApp(context);
        throw ({null});
      },
      child: RefreshIndicator(
        onRefresh: controller.onRefresh,
        child: Scaffold(
          appBar: buildAppBar(context),
          body: NotificationListener(
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
            child: controller.isLoading
                ? Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: loadingSkeleton(),
                    ),
                  )
                : GetBuilder<HomeController>(
                    id: 'content',
                    builder: (_) {
                      return ListView(
                        children: [
                          //TEMPORARY
                          // if (controller)
                          //BANNER
                          GetBuilder<HomeController>(
                            id: 'header-content',
                            builder: (_) {
                              return CustomCarousel().headerCarousel(
                                banner: controller.banner,
                                onPageChanged: (index, reason) {
                                  controller.bannerChange(
                                    index: index,
                                    section: 'header',
                                  );
                                },
                                currentIndex: controller.headerIndex,
                                url: '${controller.api.content}/banner/',
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          buildBodyPage(context),
                          SizedBox(height: 15),
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
                    },
                  ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              ChatController chatController = Get.put(ChatController());
              chatController.init();
              Get.to(() => ChatPage());
            },
            child: SvgPicture.asset('assets/icons/message.svg'),
            backgroundColor: primaryColor,
          ),
        ),
      ),
    );
  }

  Widget skeletonLoadingContent(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView(
          // children: [
          //   Container(
          //     height: 150,
          //     width: double.infinity,
          //     child: loadingSkeleton(),
          //   ),
          //   SizedBox(
          //     height: 20,
          //   ),
          //   Container(
          //     height: 150,
          //     width: double.infinity,
          //     child: loadingSkeleton(),
          //   ),
          //   SizedBox(
          //     height: 20,
          //   ),
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: List.generate(
          //       3,
          //       (index) {
          //         return Padding(
          //           padding: EdgeInsets.only(
          //             right: index == 2 ? 0 : 10.0,
          //           ),
          //           child: Container(
          //             height: 150,
          //             width: MediaQuery.of(context).size.width / 3.5,
          //             child: loadingSkeleton(),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          //   SizedBox(
          //     height: 10,
          //   ),
          //   Column(
          //     children: List.generate(
          //       2,
          //       (index) {
          //         return Padding(
          //           padding: const EdgeInsets.only(
          //             right: 10.0,
          //           ),
          //           child: Container(
          //             width: MediaQuery.of(context).size.width - 2 * 10,
          //             child: loadingSkeleton(),
          //           ),
          //         );
          //       },
          //     ),
          //   )
          // ],
          ),
    );
  }

  LinearProgressIndicator loadingSkeleton() {
    return LinearProgressIndicator(
      color: primaryColor,
      backgroundColor: Colors.grey[300],
    );
  }

  Padding buildBodyPage(BuildContext ci) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*if (controller.promotions != null)
            WinnGeneralText(
              title: 'Promotions',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              colorTitle: Colors.black,
              border: TextDecoration.none,
            ),
          if (controller.promotions != null) SizedBox(height: 15),
          if (controller.promotions != null)
            GetBuilder<HomeController>(
              id: 'promotion-content',
              builder: (_) {
                return CustomCarousel().generalSlider(
                  banner: controller.promotions,
                  onPageChanged: (index, reason) {
                    controller.bannerChange(index: index, section: 'promotion');
                  },
                  currentIndex: controller.promotionIndex,
                  url: '${controller.api.content}/promotion/',
                );
              },
            ),
          SizedBox(height: 10),*/
          // if (controller.categories!.isNotEmpty)
          InkWell(
            onTap: () {
              controller.bestSeller.toCategory();
            },
            child: WinnGeneralText(
              title: 'Our Products',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              colorTitle: Colors.black,
              border: TextDecoration.none,
            ),
          ),
          SizedBox(height: 15),
          /*Container(
            height: 200,
            child: GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
              ),
              itemCount: best_controller.categories?.length,
              itemBuilder: (c, i) {
                return cardBody(i, ci);
              },
            ),
          ),*/
          GetBuilder<HomeController>(
            id: 'best-seller',
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
                itemCount: controller.categories == null
                    ? 0
                    : controller.categories!.length,
                itemBuilder: (c, i) {
                  return cardBody(i, ci);
                },
              );
            },
          ),
          /*GetBuilder<HomeController>(
            id: 'best-seller',
            builder: (_) {
              return buildBestSeller(ci,controller.isLoading);
            },
          ),*/
          SizedBox(height: 15),
          if (controller.product.products.isNotEmpty)
            WinnGeneralText(
              title: 'New Item',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              colorTitle: Colors.black,
              border: TextDecoration.none,
            ),
          SizedBox(height: 5),
          GetBuilder<HomeController>(
            id: 'product',
            builder: (_) {
              return buildProductList();
            },
          ),
        ],
      ),
    );
  }

  SizedBox buildProductList() {
    return SizedBox(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.product.products.length,
        itemBuilder: (context, index) {
          double listItemWidth = MediaQuery.of(context).size.width - 2 * 10;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ProductCardV(
              product: controller.product.products[index],
              itemWidth: listItemWidth,
              url: controller.api.content,
              onTap: () {
                controller.product.toDescriptionProduct(
                  id: controller.product.products[index].id,
                );
              },
              index: index,
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
          controller.toProductSubCategory(
              id: controller.categories?[i].id,
              tittle: controller.categories?[i].category);
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
                child: controller.categories?.length != null
                    ? CachedNetworkImage(
                        imageUrl:
                            '${controller.api.content}/category/${controller.categories?[i].image}',
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 8.0),
                  child: WinnGeneralText(
                    title: controller.categories?[i].category,
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

  /*SizedBox buildBestSeller(BuildContext c, bool isLoading) {
    print("controller.product");
    print(controller.product.isLoading);

    if (controller.product.bestSeller.length > 0) {
      return SizedBox(
        height: 300,
        // width: 150,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: controller.product.totalBestProducts > 5
                ? controller.product.bestSeller.length + 1
                : controller.product.bestSeller.length,
            itemBuilder: (context, index) {
              if (controller.product.totalBestProducts > 5) {
                if ((index == controller.product.bestSeller.length) &&
                    (controller.product.bestSeller.length <
                        controller.product.totalBestProducts)) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Colors.grey[200],
                      ),
                      margin: EdgeInsets.only(
                        right: 10,
                      ),
                      child: Center(
                        child: controller.bestLoading
                            ? CircularProgressIndicator()
                            : CustomButton(
                                text: 'load more'.toUpperCase(),
                                fontSize: 12,
                                sizeHeight: 10,
                                sizeWidth:
                                    MediaQuery.of(context).size.width / 3,
                                borderSideColor: Colors.white,
                                colorButton: Colors.white,
                                textColor: primaryColor,
                                onPressed: () {
                                  controller.loadBestData();
                                },
                              ),
                      ),
                    ),
                  );
                } else if ((index == controller.product.bestSeller.length) &&
                    (controller.product.bestSeller.length ==
                        controller.product.totalBestProducts)) {
                  return Container();
                } else {
                  return Container(
                    width: 200,
                    margin: EdgeInsets.only(
                      right: (index == controller.product.bestSeller.length - 1)
                          ? 10
                          : 5,
                    ),
                    child: ProductCard(
                      product: controller.product.bestSeller[index],
                      onTap: () {
                        controller.product.toDescriptionProduct(
                          id: controller.product.bestSeller[index].id,
                        );
                      },
                      url: controller.api.content,
                    ),
                  );
                }
              } else {
                if (controller.product.totalBestProducts > 0) {
                  return Container(
                    width: 200,
                    margin: EdgeInsets.only(
                      right: (index == controller.product.bestSeller.length - 1)
                          ? 10
                          : 5,
                    ),
                    child: ProductCard(
                      product: controller.product.bestSeller[index],
                      onTap: () {
                        controller.product.toDescriptionProduct(
                          id: controller.product.bestSeller[index].id,
                        );
                      },
                      url: controller.api.content,
                    ),
                  );
                } else {
                  return Container();
                }
              }
            }),
      );
    } else {
      return controller.product.isLoading
          ? SizedBox(
              width: MediaQuery.of(c).size.width,
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SizedBox(
              height: 200,
              width: MediaQuery.of(c).size.width,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Koneksi Error",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Terjadi Kesalahan Dengan Koneksi Anda, Silahkan Coba Lagi",
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
            );
    }
  }*/

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      title: GestureDetector(
        onTap: () {
          controller.search();
        },
        child: Container(
          width: (MediaQuery.of(context).size.width - 2 * 15) * 0.70,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          child: Row(
            children: [
              SizedBox(width: 10),
              SvgPicture.asset(
                'assets/icons/search.svg',
              ),
              SizedBox(width: 20),
              Text(
                'Search...',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              )
            ],
          ),
        ),
      ),
      actions: [
        SizedBox(
          width: (MediaQuery.of(context).size.width - 2 * 15) * 0.30,
          child: Row(
            children: [
              Container(
                height: 40,
                width:
                    ((MediaQuery.of(context).size.width - 2 * 15) * 0.30) / 2,
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  onPressed: controller.onNotificationTap,
                  icon: SvgPicture.asset(
                    'assets/icons/notification.svg',
                  ),
                ),
                // Center(
                //   child: SvgPicture.asset(
                //     'assets/icons/notification.svg',
                //   ),
                // ),
              ),
              Container(
                height: 40,
                width:
                    ((MediaQuery.of(context).size.width - 2 * 15) * 0.30) / 2,
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.to(() => CartPage());
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/cart.svg',
                      ),
                    ),
                    if (controller.tab.cartCount.value > 0)
                      Positioned(
                        left: 12,
                        child: Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Text(
                                '${controller.tab.cartCount.value}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 7,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
