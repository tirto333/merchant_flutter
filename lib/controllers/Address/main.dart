import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';
import 'package:winn_merchant_flutter/models/error.dart';
import 'package:winn_merchant_flutter/models/user_address.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';

import 'add_edit.dart';

class SavedAddressController extends GetxController {
  List<UserAddress> addresses = <UserAddress>[];

  AddressFormController addEditController = Get.put(AddressFormController());
  RestApi api = Get.find<RestApi>();

  void onInit() async {
    await initial();
    super.onInit();
  }

  Future initial() async {
    try {
      var addressData = await api.dynamicGet(
        section: 'user',
        endpoint: '/addresses',
        page: 'user-address',
        contentType: 'application/json',
      );

      addresses = UserAddressResModel.fromJson(addressData.data).data?.rows ??
          <UserAddress>[];

      update(['list-address']);
    } on ErrorResModel catch (e) {
      switch (e.statusCode) {
        case 401:
          CustomShowDialog().tokenError(e);
          break;
        default:
          Get.snackbar(
            'Error',
            e.message.toString(),
            snackPosition: SnackPosition.BOTTOM,
          );
          break;
      }
    }
  }
}
