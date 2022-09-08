import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/home/best-seller.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';

class BestSellerPage extends StatelessWidget {
  final BestSellerController controller = Get.find<BestSellerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Best Seller Product"),
        centerTitle: true,
      ),
      body: GridView.builder(
        shrinkWrap: true,
        primary: false,
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
        ),
        itemCount: controller.categories?.length,
        itemBuilder: (c, i) {
          return cardBody(i, context);
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
          print("disini");
          //controller.toProductCategory(id: controller.categories?[i].id);
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
                            '${controller.api.content}/category/${controller.categories?[i].imageUrl}',
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
                      )
                    : Image.asset(
                        'assets/images/bannerImage.png',
                        fit: BoxFit.fill,
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: WinnGeneralText(
                    title: controller.categories?[i].name,
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
