import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Product/product.dart';
import 'package:winn_merchant_flutter/controllers/home/home.dart';
import 'package:winn_merchant_flutter/models/product.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductCardV extends StatelessWidget {
  final ProductController controller = Get.find<ProductController>();
  final HomeController homeController = Get.find<HomeController>();
  final Product? product;
  final double itemWidth;
  final String? url;
  final Function() onTap;
  final itemProduct;
  final int index;

  ProductCardV(
      {this.product,
      required this.itemWidth,
      required this.url,
      required this.onTap,
      this.itemProduct,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color(0xFFE3E3E3),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: 140,
                      height: 140,
                      // margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        image: DecorationImage(
                            image: NetworkImage(
                                "$url/product/${product?.imageUrl}"),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 6,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product?.discount != 0)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: Colors.red[800],
                                ),
                                margin: EdgeInsets.only(left: 10, top: 10),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0,
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
                            Padding(
                              padding: const EdgeInsets.only(top: 10, left: 10),
                              child: Text(
                                product?.typePressure ??
                                    product?.category ??
                                    '',
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 10),
                              child: Text(
                                product?.name ?? '',
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
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
                                        controller.wishProd(
                                          id: product?.id,
                                          wishId: product?.whishlistId,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                ],
              ))
        ],
      ),
    );
  }
}
