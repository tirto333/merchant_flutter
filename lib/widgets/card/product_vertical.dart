import 'package:cached_network_image/cached_network_image.dart';
import 'package:winn_merchant_flutter/models/product.dart';
import 'package:flutter/material.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';

class ProductCardVertical extends StatelessWidget {
  final Product? product;
  final Function() onTap;
  final String? url;

  ProductCardVertical({
    required this.product,
    required this.onTap,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
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
                    if (product?.discount != null)
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
            ],
          ),
        ),
      ),
    );
  }
}
