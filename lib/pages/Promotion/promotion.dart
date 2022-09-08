import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Promotion/main.dart';
import 'package:winn_merchant_flutter/pages/detailinformation/promotion.dart';
import 'package:winn_merchant_flutter/widgets/custom_appbar.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';

class PromotionPage extends StatelessWidget {
  final PromotionController controller = Get.put(PromotionController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        controller.tab.backToHome();
        throw ({null});
      },
      child: Scaffold(
        appBar: CustomAppBar().generalAppBar(
          implyLeading: false,
          title: "Promotion",
        ),
        body: GetBuilder<PromotionController>(builder: (_) {
          print(controller.promotions?.rows?.length);
          return Container(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: controller.promotions?.rows?.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: controller.promotions?.rows?.length != 0
                        ? () {
                            Get.to(PromotionDetailScreen(
                              banner: controller.promotions?.rows?[index].image,
                              url: '${controller.api.content}/promotion/',
                              startDate:
                                  controller.promotions?.rows?[index].start,
                              endDate: controller.promotions?.rows?[index].end,
                              term: controller.promotions?.rows?[index].term,
                              title: controller.promotions?.rows?[index].title,
                            ));
                          }
                        : null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 211,
                          margin: EdgeInsets.only(
                            right: (index + 1 ==
                                    controller.promotions?.rows?.length)
                                ? 5
                                : 5,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10)),
                          child: CachedNetworkImage(
                            imageUrl: controller.api.content +
                                '/promotion/${controller.promotions?.rows?[index].image}',
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/bannerImage.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
