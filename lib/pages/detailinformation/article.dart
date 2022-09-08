import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:intl/intl.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/custom_appbar.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';

class ArticleDetailScreen extends StatelessWidget {
  ArticleDetailScreen({
    @required this.banner,
    @required this.title,
    @required this.description,
    this.startDate,
    @required this.url,
  });

  final String? banner;
  final String? url;
  final String? title;
  final String? startDate;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar().generalAppBar(
        title: "Article Detail",
      ),
      body: ListView(
        children: [
          buildHeader(),
          SizedBox(height: 15),
          buildTitleAndTime(),
          SizedBox(height: 15),
          Divider(
            height: 1,
          ),
          SizedBox(height: 15),
          articleDescription()
        ],
      ),
    );
  }

  Widget articleDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: description,
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
                title: "$startDate",
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
