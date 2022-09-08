import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Profile/main.dart';
import 'package:winn_merchant_flutter/widgets/custom_appbar.dart';

class MyProfilePage extends StatelessWidget {
  final MyProfileController controller = Get.put(MyProfileController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        controller.tab.backToHome();
        throw ({null});
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: CustomAppBar().generalAppBar(
          title: "Profile",
          implyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              buildProfileMenu(context),
              SizedBox(height: 10),
              buildChangePassword(),
              SizedBox(height: 10),
              buildLogout(context),
            ],
          ),
        ),
      ),
    );
  }

  Container buildLogout(context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade200,
          width: 0.8,
        ),
      ),
      child: ListTile(
        leading: SvgPicture.asset('assets/icons/logout.svg'),
        title: Text('Log out', style: TextStyle(color: Colors.red)),
        onTap: () async {
          controller.logout(context);
        },
      ),
    );
  }

  Container buildChangePassword() {
    return Container(
      color: Colors.white,
      child: Column(
        children: List.generate(
          controller.password('section').length,
          (index) => ListTile(
            title: Text(controller.password('section')[index]),
            trailing: Icon(Icons.chevron_right),
            onTap: controller.password('function')[index],
          ),
        ),
      ),
    );
  }

  Container buildProfileMenu(BuildContext context) {
    print("DIPANGGIL + buildProfileMenu");
    return Container(
      color: Colors.white,
      child: Column(
        children: List.generate(
          controller.userProfile('section').length,
          (index) => ListTile(
            title: Text(controller.userProfile('section')[index]),
            trailing: Icon(Icons.chevron_right),
            onTap: controller.userProfile('function')[index],
          ),
        ),
      ),
    );
  }
}
