import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:winn_merchant_flutter/controllers/Promotion/main.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
// import 'package:winn_merchant_flutter/widgets/custom_appbar.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';

class PromotionDetailScreen extends StatelessWidget {
  final PromotionController controller = Get.put(PromotionController());

  PromotionDetailScreen({
    this.banner,
    this.title,
    this.term,
    this.startDate,
    this.endDate,
    this.url,
  });

  final String? banner;
  final String? url;
  final String? title;
  final String? startDate;
  final String? endDate;
  final String? term;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WinnGeneralText(
          title: 'Promo Detail',
          colorTitle: Colors.black87,
          fontSize: 18,
          border: TextDecoration.none,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () => Get.back(),
        ),
      ),
      // appBar: CustomAppBar().generalAppBar(
      //   title: "Promo Detail",
      // ),
      body: ListView(
        children: [
          buildHeader(),
          SizedBox(height: 15),
          buildTitleAndTime(),
          SizedBox(height: 15),
          Divider(height: 1),
          SizedBox(height: 15),
          buildTermAndConditions()
        ],
      ),
    );
  }

  Widget buildTermAndConditions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WinnGeneralText(
            title: "Term & Conditions",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            colorTitle: Colors.black,
            border: TextDecoration.none,
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              text: term,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitleAndTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WinnGeneralText(
            title: title,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            colorTitle: Colors.black,
            border: TextDecoration.none,
          ),
          SizedBox(height: 15),
          Row(
            children: [
              SvgPicture.asset('assets/icons/timer.svg'),
              SizedBox(width: 5),
              WinnGeneralText(
                title: endDate,
                colorTitle: primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                border: TextDecoration.none,
              ),
            ],
          )
        ],
      ),
    );
  }

  Container buildHeader() {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: banner != null
          ? CachedNetworkImage(
              imageUrl: '$url$banner',
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
    );
  }
}
