import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:winn_merchant_flutter/controllers/Profile/wishlist.dart';
import 'package:winn_merchant_flutter/models/Whislist/wishlist.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';

import '../general_text.dart';

class ProductWhislistCard extends StatelessWidget {
  final WishlistController controller = Get.find<WishlistController>();

  final Function() onTap;
  final double itemWidth;
  final String? url;
  final Wishlist? whislist;

  ProductWhislistCard({
    required this.onTap,
    required this.itemWidth,
    required this.url,
    this.whislist,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.shade400,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 150,
              height: 150,
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                image: DecorationImage(
                    image: NetworkImage("$url/product/${whislist?.imageUrl}"),
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(
              width: itemWidth - 182, // (60 + 12 + 110)
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  whislist?.discountedPrice != null
                      ? Container(
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
                              title: "Disc ${whislist?.discount}%",
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              textAlign: TextAlign.center,
                              border: TextDecoration.none,
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    whislist?.typePressure ?? whislist?.category ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    whislist?.name ?? '',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.clip,
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        width: 110,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            whislist?.discountedPrice != null
                                ? Text(
                                    NumberFormat.currency(
                                      decimalDigits: 0,
                                      symbol: 'Rp ',
                                    ).format(
                                      whislist?.discountedPrice ?? 0,
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
                            SizedBox(height: 5),
                            Text(
                              whislist?.normalPrice != null
                                  ? NumberFormat.currency(
                                          decimalDigits: 0, symbol: 'Rp ')
                                      .format(whislist?.normalPrice)
                                  : '',
                              style: TextStyle(
                                fontSize:
                                    whislist?.discountedPrice != null ? 12 : 15,
                                decoration: whislist?.discountedPrice != null
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                decorationThickness: 1.0,
                                color: whislist?.discountedPrice != null
                                    ? Colors.black54
                                    : primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
