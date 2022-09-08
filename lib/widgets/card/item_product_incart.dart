import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:winn_merchant_flutter/models/Cart/cart.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';

class ItemCard extends StatelessWidget {
  final Cart? cart;
  final Function() onTap;
  final String? url;

  ItemCard({
    required this.cart,
    required this.onTap,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: CachedNetworkImage(
              imageUrl: '$url/product/${cart?.imageUrl}',
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
              errorWidget: (context, url, error) => Image.asset(
                'assets/images/bannerImage.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cart?.typePressure ?? cart?.category ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  cart?.name ?? '',
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.clip,
                ),
                SizedBox(height: 10),
                cart?.discountedPrice != null
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          NumberFormat.currency(
                            decimalDigits: 0,
                            symbol: 'Rp ',
                          ).format(cart?.discountedPrice ?? 0),
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      )
                    : Container(),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(
                        cart?.normalPrice != null
                            ? NumberFormat.currency(
                                    decimalDigits: 0, symbol: 'Rp ')
                                .format(cart?.normalPrice)
                            : '',
                        style: TextStyle(
                          fontSize: 10,
                          decoration: TextDecoration.none,
                          decorationThickness: 1.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    cart?.discountedPrice != null
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                              color: Colors.red[800],
                            ),
                            child: WinnGeneralText(
                              title: "${cart?.discount}%",
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              textAlign: TextAlign.center,
                              border: TextDecoration.none,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
