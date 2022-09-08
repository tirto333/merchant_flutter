import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Product/product.dart';
import 'package:winn_merchant_flutter/controllers/home/home.dart';
import 'package:winn_merchant_flutter/models/product.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'general_text.dart';

class ProductCard extends StatelessWidget {
  final ProductController controller = Get.find<ProductController>();
  final HomeController homeController = Get.find<HomeController>();
  final Product? product;
  final Function() onTap;
  final String? url;
  final int index;


  ProductCard({
    required this.product,
    required this.onTap,
    required this.url,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    print('${product?.whishlistId}');
    return GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        child: product?.imageUrl != null
                            ? Center(
                                child: CachedNetworkImage(
                                  imageUrl: "$url/product/${product?.imageUrl}",
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
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/images/bannerImage.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              )
                            : Image.asset(
                                'assets/images/bannerImage.png',
                                fit: BoxFit.fill,
                              ),
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width / 4,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.red[800],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 5,
                            ),
                            child: WinnGeneralText(
                              title: "Disc ${product?.discount}%",
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              textAlign: TextAlign.center,
                              border: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                WinnGeneralText(
                  title: product?.typePressure ?? product?.category ?? '',
                  colorTitle: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.start,
                  border: TextDecoration.none,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  product?.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                product?.discountedPrice != null
                    ? Text(
                        NumberFormat.currency(
                          decimalDigits: 0,
                          symbol: 'Rp ',
                        ).format(
                          product?.discountedPrice ?? 0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      )
                    : Container(),
                Text(
                  product?.normalPrice != null
                      ? NumberFormat.currency(decimalDigits: 0, symbol: 'Rp ')
                          .format(product?.normalPrice)
                      : '',
                  style: TextStyle(
                    fontSize: product?.discountedPrice != null ? 12 : 15,
                    decoration: product?.discountedPrice != null
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationThickness: 1.0,
                    color: product?.discountedPrice != null
                        ? Colors.black54
                        : primaryColor,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GetBuilder<ProductController>(
                        id: 'love-icon',
                        builder: (_) {
                          return IconButton(
                            icon: product?.isFavorite == false
                                ? Icon(Icons.favorite_border_outlined)
                                : Icon(
                                    Icons.favorite_rounded,
                                    color: Colors.red[600],
                                  ),
                            iconSize: 26,
                            onPressed: () {
                              /*if(homecontroller.bestSellerProd[index].isFavorite==true)
                                {
                                  homecontroller.bestSellerProd[index].isFavorite=false;
                                }
                              else
                                {
                                  homecontroller.bestSellerProd[index].isFavorite=true;
                                }*/
                              controller.wishProd(
                                id: product?.id,
                                wishId: product?.whishlistId,
                                );
                              homeController.update();
                            },
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
