import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:winn_merchant_flutter/models/banner.dart';
import 'package:winn_merchant_flutter/models/Promotion/promotion.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:get/get.dart';

class CustomCarousel {
  headerCarousel({
    @required BannerData? banner,
    int initialIndex = 0,
    @required Function(int, CarouselPageChangedReason)? onPageChanged,
    int? currentIndex = 0,
    String? url = '',
  }) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            enableInfiniteScroll: false,
            initialPage: initialIndex,
            height: 256,
            autoPlay: false,
            autoPlayAnimationDuration: Duration(seconds: 3),
            autoPlayInterval: Duration(
              seconds: 5,
            ),
            viewportFraction: 1,
            onPageChanged: onPageChanged,
          ),
          items: List.generate(
            banner?.rows?.length ?? 1,
            (index) {
              return Container(
                height: 260,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: banner?.rows?.length != null
                    ? CachedNetworkImage(
                        imageUrl: '$url${banner?.rows?[index].image}',
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
            },
          ),
        ),
        Positioned(
          top: 220,
          left: 180,
          child: Row(
            children: List.generate(
              banner?.rows?.length ?? 1,
              (index) {
                if (banner?.rows?.length == 1) {
                  return Container();
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 5,
                    ),
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: currentIndex == index
                              ? primaryColor
                              : Colors.white,
                        ),
                        color:
                            currentIndex == index ? primaryColor : Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        )
      ],
    );
  }

  generalSlider({
    @required PromotionData? banner,
    int initialIndex = 0,
    @required Function(int, CarouselPageChangedReason)? onPageChanged,
    int? currentIndex = 0,
    String? url = '',
  }) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            initialPage: initialIndex,
            height: 230,
            autoPlay: false,
            autoPlayAnimationDuration: Duration(seconds: 3),
            autoPlayInterval: Duration(
              seconds: 5,
            ),
            viewportFraction: 1,
            onPageChanged: onPageChanged,
          ),
          items: List.generate(
            banner?.rows?.length ?? 1,
            (index) {
              return GestureDetector(
                onTap: banner?.rows?.length != 0
                    ? () {
                        // Get.to(PromotionDetailScreen(
                        //   banner: banner?.rows?[index].image,
                        //   url: url,
                        //   startDate: banner?.rows?[index].start,
                        //   endDate: banner?.rows?[index].end,
                        //   term: banner?.rows?[index].term,
                        //   title: banner?.rows?[index].title,
                        // ));
                      }
                    : null,
                child: Container(
                  height: 260,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: banner?.rows?.length != 0
                      ? CachedNetworkImage(
                          imageUrl: '$url${banner?.rows?[index].image}',
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
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            banner?.rows?.length ?? 1,
            (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 5,
                ),
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: primaryColor,
                    ),
                    color: currentIndex == index ? primaryColor : Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
