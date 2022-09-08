import 'package:cached_network_image/cached_network_image.dart';
import 'package:winn_merchant_flutter/controllers/Product/product.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/custom_button.dart';
// import 'package:winn_merchant_flutter/widgets/custom_form_field.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';

class ProductDescriptionPage extends StatelessWidget {
  final ProductController controller = Get.find<ProductController>();
  final TextEditingController stockController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Deskripsi Produk",
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () => Get.back(),
        ),
        actions: [
          GetBuilder<ProductController>(
            id: 'love-icon',
            builder: (_) {
              return IconButton(
                icon: controller.selectedProduct?.isFavorite != null &&
                        controller.selectedProduct?.isFavorite != false
                    ? Icon(
                        Icons.favorite_rounded,
                        color: Colors.red[600],
                      )
                    : Icon(Icons.favorite_border_outlined),
                iconSize: 26,
                onPressed: () {
                  controller.wishProd(
                    id: controller.selectedProduct?.id,
                    wishId: controller.selectedProduct?.whishlistId,
                  );
                },
              );
            },
          )
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              buildImage(),
              SizedBox(height: 15),
              buildTitleAndPrice(),
              SizedBox(height: 15),
              buildProductSpecs(context),
              SizedBox(height: 150),
            ],
          ),
          GetBuilder<ProductController>(
            id: 'cart-button',
            builder: (_) {
              return controller.tapToCart
                  ? cartPop(context)
                  : buildBottomButton();
            },
          ),
        ],
      ),
    );
  }

  Widget buildProductSpecs(context) {
    final width1 = (MediaQuery.of(context).size.width - 2 * 10) * 0.3;
    final width2 = (MediaQuery.of(context).size.width - 2 * 10) * 0.7;
    stockController.text = "${controller.selectedProduct?.stock} Pcs";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SPECIFICATION",
            style: TextStyle(
                color: Color(0xFF737373),
                fontSize: 12,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 10),
          Row(children: [
            SizedBox(
              width: width1,
              child: Text(
                "Type",
                style: TextStyle(
                    color: Color(0xFF3A3A3A), fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              width: width2,
              child: Text(
                ":  ${controller.selectedProduct?.category}",
                style: TextStyle(
                    color: Color(0xFF292929), fontWeight: FontWeight.w500),
              ),
            )
          ]),
          SizedBox(height: 5),
          Row(children: [
            SizedBox(
              width: width1,
              child: Text(
                "Dimension",
                style: TextStyle(
                    color: Color(0xFF3A3A3A), fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              width: width2,
              child: Text(
                ":  ${controller.selectedProduct?.dimension}",
                style: TextStyle(
                    color: Color(0xFF292929), fontWeight: FontWeight.w500),
              ),
            )
          ]),
          SizedBox(height: 5),
          Row(children: [
            SizedBox(
              width: width1,
              child: Text(
                "Weight",
                style: TextStyle(
                    color: Color(0xFF3A3A3A), fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              width: width2,
              child: Text(
                ":  ${controller.selectedProduct?.weight}",
                style: TextStyle(
                    color: Color(0xFF292929), fontWeight: FontWeight.w500),
              ),
            )
          ]),
          // Row(children: [
          //   SizedBox(
          //     width: width1,
          //     child: Text(
          //       "Weight 2",
          //       style: TextStyle(
          //           color: Color(0xFF3A3A3A), fontWeight: FontWeight.w400),
          //     ),
          //   ),
          //   SizedBox(
          //     width: width2,
          //     child: Text(
          //       ":  ${controller.selectedProduct?.id}",
          //       style: TextStyle(
          //           color: Color(0xFF292929), fontWeight: FontWeight.w500),
          //     ),
          //   )
          // ]),
          SizedBox(height: 10),
          Divider(
            height: 2,
          ),
          SizedBox(height: 10),
          Text(
            "Other Description".toUpperCase(),
            style: TextStyle(
                color: Color(0xFF737373),
                fontSize: 12,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 5),
          RichText(
            text: TextSpan(
              text: '${controller.selectedProduct?.description}',
              style: TextStyle(
                  color: Color(0xFF3A3A3A),
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget buildTitleAndPrice() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.selectedProduct?.typePressure.toString().toUpperCase() ??
                controller.selectedProduct?.category.toString().toUpperCase() ??
                '',
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: TextStyle(
                color: Color(0xFF737373),
                fontSize: 12,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 5),
          Text(
            controller.selectedProduct?.name ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            softWrap: true,
            overflow: TextOverflow.clip,
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 65,
                color: Colors.transparent,
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFECECEC)),
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    child: new Center(
                      child: new Text(
                        "${controller.selectedProduct!.pcs} pcs",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
              /*Container(
                width: 65,
                child: TextField(
                  controller: stockController,
                  decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  // focusNode: _focusNode,
                ),
              ),*/
              // Text(
              //   "${controller.selectedProduct?.stock} Pcs" ?? '',
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: primaryColor,
              //     fontWeight: FontWeight.bold,
              //   ),
              //   softWrap: true,
              //   overflow: TextOverflow.clip,
              // ),
              SizedBox(
                width: 10,
              ),
              Text(
                "/ Dus",
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: TextStyle(
                    color: Color(0xFF3A3A3A),
                    fontWeight: FontWeight.w700,
                    fontSize: 14),
              ),
            ],
          ),
          SizedBox(height: 15),
          Divider(
            height: 2,
          )
        ],
      ),
    );
  }

  Widget buildImage() {
    return Container(
      //height: 256,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: controller.selectedProduct?.imageUrl != null
          ? CachedNetworkImage(
              imageUrl:
                  '${controller.api.content}/product/${controller.selectedProduct?.imageUrl}',
              fit: BoxFit.fitWidth,
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
              errorWidget: (context, url, error) => Image.asset(
                'assets/images/bannerImage.png',
                fit: BoxFit.fill,
              ),
            )
          : Image.asset(
              'assets/images/bannerImage.png',
              fit: BoxFit.fitWidth,
            ),
    );
  }

  Column buildBottomButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Divider(
          height: 2,
        ),
        SizedBox(
          height: 5,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 70,
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: CustomButton(
              text: "Buy Now",
              borderRadiusSize: 10,
              textColor: Colors.white,
              colorButton: primaryColor,
              borderSideColor: Colors.transparent,
              onPressed: () {
                controller.onCartTap(productId: controller.selectedProduct?.id);
              },
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget cartPop(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20.0, right: 40),
          height: 77,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check,
                    color: Colors.greenAccent[700],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  WinnGeneralText(
                    title: 'Successully added to cart!',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    colorTitle: Colors.greenAccent[700],
                    border: TextDecoration.none,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  controller.toCart();
                },
                child: WinnGeneralText(
                  title: 'See Cart',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  colorTitle: primaryColor,
                  border: TextDecoration.none,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
