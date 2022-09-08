import 'package:winn_merchant_flutter/controllers/main_tab_controller.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  final MainPageController controller = Get.put(MainPageController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainPageController>(
      id: 'content-page',
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: Container(
              color: Colors.white30,
              child: Stack(
                children: [
                  Container(color: Colors.white),
                  SafeArea(
                    child: Container(color: Colors.white30),
                  ),
                  GetBuilder<MainPageController>(
                    id: 'content-page',
                    builder: (_) {
                      return controller
                          .tabs()[controller.bottomNavBarIndex.value];
                    },
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: GetBuilder<MainPageController>(
            id: 'content-page',
            builder: (_) {
              return _buildBottomNavBar();
            },
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Column(
        children: [
          Divider(),
          SizedBox(
            height: 2,
          ),
          BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.white,
            selectedItemColor: primaryColor,
            unselectedItemColor: primaryColor,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            currentIndex: controller.bottomNavBarIndex.value,
            onTap: (index) {
              controller.updateContent(index: index);
            },
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  controller.bottomNavBarIndex.value == 0
                      ? 'assets/icons/home_active.svg'
                      : 'assets/icons/home_inactive.svg',
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(controller.bottomNavBarIndex.value == 1
                    ? 'assets/icons/order_active.svg'
                    : 'assets/icons/order_inactive.svg'),
                label: 'My Order',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(controller.bottomNavBarIndex.value == 2
                    ? 'assets/icons/events_active.svg'
                    : 'assets/icons/events_inactive.svg'),
                label: 'Promotion',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    SvgPicture.asset(
                      controller.bottomNavBarIndex.value == 3
                          ? 'assets/icons/box_active.svg'
                          : 'assets/icons/box_inactive.svg',
                      color: controller.bottomNavBarIndex.value != 3
                          ? Colors.black
                          : null,
                    ),
                    /*if (controller.cartCount.value > 0)
                      Positioned(
                        left: 12,
                        child: Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Text(
                                '${controller.cartCount.value}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 7,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )*/
                  ],
                ),
                label: 'Return',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(controller.bottomNavBarIndex.value == 4
                    ? 'assets/icons/account_active.svg'
                    : 'assets/icons/account_inactive.svg'),
                label: 'My Profile',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
