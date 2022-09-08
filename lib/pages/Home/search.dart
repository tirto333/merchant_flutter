import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/home/search.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/card/product_horizontal.dart';
import 'package:winn_merchant_flutter/widgets/product_card.dart';

class SearchProductPage extends StatefulWidget {
  @override
  State<SearchProductPage> createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  final SearchController controller = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            controller.onBack();
          },
          icon: Padding(
            padding: const EdgeInsets.only(
              left: 5.0,
              top: 5,
            ),
            child: Icon(
              Icons.close_rounded,
              size: 30,
            ),
          ),
        ),
        leadingWidth: 40,
        title: searchBar(),
        bottom: indicatorSort(context),
      ),
      body: NotificationListener(
        onNotification: (ScrollNotification scrollInfo) {
          if (!controller.isLoading &&
              scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent &&
              !controller.complete) {
            if (controller.product.totalFilter >=
                controller.product.totalFilterProducts) {
              controller.changeComplete();
              Get.snackbar(
                'Product',
                'Semua produk sudah dikeluarkan',
                snackPosition: SnackPosition.BOTTOM,
              );
            } else {
              //controller.loadData();
            }
          }
          return false;
        },
        child: GetBuilder<SearchController>(
          id: 'filter-product',
          builder: (_) {
            if (controller.search.text == '') {
              return noProductContent(context);
            } else if (controller.search.text != '' &&
                controller.product.filterProduct.length < 1) {
              return noProductContent(context);
            } else {
              return productContent(context);
            }
          },
        ),
      ),
    );
  }

  Container noProductContent(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.85,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
          child: Text(
            "No result yet.\nTry to search the name of the product",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF292929), fontSize: 14),
          ),
        ));
  }

  ListView productContent(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      children: [
        controller.grid ? gridPortrait() : gridLandscape(),
        controller.isLoading
            ? Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(),
      ],
    );
  }

  Padding gridLandscape() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.product.filterProduct.length,
        itemBuilder: (context, index) {
          double listItemWidth = MediaQuery.of(context).size.width - 2 * 10;
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 15.0,
            ),
            child: ProductCardV(
              product: controller.product.filterProduct[index],
              itemWidth: listItemWidth,
              url: controller.api.content,
              onTap: () {
                controller.product.toDescriptionProduct(
                  id: controller.product.filterProduct[index].id,
                );
              },
              index: index,
            ),
          );
        },
      ),
    );
  }

  Padding gridPortrait() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 300,
        ),
        itemCount: controller.product.filterProduct.length,
        itemBuilder: (context, idx) {
          return ProductCard(
            // product: controller.product.filterProductSearch[idx],
            product: controller.product.filterProduct[idx],
            onTap: () {
              controller.product.toDescriptionProduct(
                // id: controller.product.filterProductSearch[idx].id,
                id: controller.product.filterProduct[idx].id,
              );
            },
            url: controller.api.content,
            index: idx,
          );
        },
      ),
    );
  }

  Padding searchBar() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        right: 10.0,
      ),
      child: Container(
        height: 40,
        child: Center(
          child: TextFormField(
            controller: controller.search,
            onChanged: (value) {
              controller.onChangeSearch();
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Color(0xFF737373),
              ),
              hintText: 'Search',
              hintStyle: TextStyle(
                fontSize: 13,
              ),
              fillColor: Colors.grey[200],
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row changeGrid() {
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              controller.changeGrid();
            },
            child: SvgPicture.asset(
              'assets/icons/view-grid.svg',
              height: 30,
              width: 30,
              color: controller.grid ? null : Color(0xFFACACAC),
            )
            // Icon(
            //   Icons.grid_view,
            //   size: 30,
            //   color: controller.grid ? primaryColor : null,
            // ),
            ),
        GestureDetector(
            onTap: () {
              controller.changeGrid();
            },
            child: SvgPicture.asset(
              'assets/icons/view-list.svg',
              height: 30,
              width: 30,
              color: !controller.grid ? primaryColor : null,
            )
            // Icon(
            //   Icons.ballot_outlined,
            //   size: 35,
            //   color: !controller.grid ? primaryColor : null,
            // ),
            ),
      ],
    );
  }

  PreferredSize indicatorSort(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(
        double.infinity,
        85,
      ),
      child: GetBuilder<SearchController>(
        id: 'indicator',
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width / 2.7,
                  // ),
                  DropdownButton<String>(
                    value: controller.indicator,
                    icon: Icon(
                      Icons.swap_vert_rounded,
                      size: 25,
                    ),
                    iconSize: 20,
                    elevation: 16,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    iconEnabledColor: Color(0xff2D368B),
                    underline: Container(
                      height: 1,
                      color: Colors.transparent,
                    ),
                    onChanged: (val) {
                      controller.indicatorChange(val ?? '');
                    },
                    items: [
                      'Disc (Low > High)',
                      'Disc (High > Low)',
                      'Name (A - Z)',
                      'Name (Z - A)',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Color(0xff2D368B)),
                        ),
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [changeGrid()],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
