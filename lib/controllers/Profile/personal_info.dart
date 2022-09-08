import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dio/src/form_data.dart' as form;
import 'package:dio/src/multipart_file.dart' as multipart;
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';
import 'package:winn_merchant_flutter/helpers/custom_date.dart';
import 'package:winn_merchant_flutter/models/error.dart';
import 'package:winn_merchant_flutter/models/user.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';

class PersonalInfoController extends GetxController {
  int? stringEdited;
  String? tempNPWP;
  String? tempNIK;
  TextEditingController? edited;
  User? user;
  List? userInfo;
  List info = [
    //'USER ID',
    'COMPANY NAME',
    'NPWP',
    'COMPANY EMAIL',
    'PIC NAME',
    'PHONE NUMBER',
    'KTP',
    // 'ADDRESS',
  ];
  Timer? debounce;

  RestApi api = Get.find<RestApi>();

  void onInit() async {
    stringEdited = null;
    edited = new TextEditingController();
    await getPersonalData();
    super.onInit();
    // print("DATA EDIT $stringEdited");
  }

  Future getPersonalData() async {
    print("onInit getPersonalData");

    try {
      var response = await api.dynamicGet(
        endpoint: '/profile',
        contentType: "application/json",
        page: 'profile',
        section: 'user',
      );

      user = UserResModel.fromJson(response.data).data;

      var npwp = user?.npwp;
      if (npwp != null) {
        if (npwp.contains('-')) {
          tempNPWP = npwp.replaceAll('-', '');
        } else {
          tempNPWP = npwp;
        }
      }
      var noNPWP =
          "${tempNPWP?.substring(0, 2)} . ${tempNPWP?.substring(2, 5)} . ${tempNPWP?.substring(5, 8)} . ${tempNPWP?.substring(8, 9)}-${tempNPWP?.substring(9, 12)} . ${tempNPWP?.substring(12, tempNPWP?.length)}";

      var nik = user?.nik;
      if (nik != null) {
        if (nik.contains('-')) {
          tempNIK = nik.replaceAll('-', '');
        } else {
          tempNIK = nik;
        }
      }

      userInfo = [
        //user?.username,
        user?.companyName,
        noNPWP,
        // user?.npwp!.replaceAll('-', ' . '),
        user?.email,
        user?.username,
        //CustomDate().backToFront(user?.dob),
        user?.phone,
        tempNIK,
        // user?.address,
      ];

      update(['user-info']);
    } on ErrorResModel catch (e) {
      Get.snackbar(
        'Error',
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void selectedIndex({int? index}) {
    stringEdited = index;
    switch (index) {
      case 0:
        edited?.text = user?.companyName ?? '';
        break;
      case 1:
        edited?.text = user?.npwp ?? '';
        break;
      case 2:
        edited?.text = user?.email ?? '';
        break;
      case 3:
        edited?.text = user?.username ?? '';
        break;
      case 4:
        edited?.text = user?.phone ?? '';
        break;
      case 5:
        edited?.text = user?.nik ?? '';
        break;
      /*case 6:
        edited?.text = user?.nik ?? '';
        break;*/
      // case 7:
      //   edited?.text = user?.address ?? '';
      //   break;
      default:
    }
    update(['user-info']);
  }

  void datePickerChange(DateTime date) {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      edited?.text = DateFormat('dd/MM/yyyy').format(date);
      update(['user-info']);
    });
  }

  void submit(context) async {
    print("submit di panggil");
    try {
      CustomShowDialog().openLoading(context);
      String variable = '';

      switch (stringEdited) {
        case 0:
          variable = 'company_name';
          break;
        case 1:
          variable = 'npwp';
          break;
        case 2:
          variable = 'email';
          break;
        case 3:
          variable = 'username';
          break;
        case 4:
          variable = 'phone';
          break;
        case 5:
          variable = 'nik';
          break;
        /*case 6:
          variable = 'nik';
          break;*/
        // case 7:
        //   variable = 'address';
        //   break;
        default:
          break;
      }

      var data = {
        "$variable": edited?.text,
        // "$variable": stringEdited == 2
        //     ? CustomDate().dateParse(edited?.text)
        //     : edited?.text,
      };

      var response = await api.dynamicUpdate(
        endpoint: '/update-profile?section=$variable',
        data: data,
        page: 'update-profile',
        contentType: 'application/json',
        section: 'user',
      );

      print("DATA PROFILE UPDATE $response");
      print("DATA PROFILE UPDATE ENDPOINT $data");
      print("DATA PROFILE UPDATE ENDPOINT $variable");

      print("response");
      print(response);

      if (response.statusCode == 200) {
        CustomShowDialog().closeLoading();
        getPersonalData();
      }
    } on ErrorResModel catch (e) {
      CustomShowDialog().closeLoading();

      switch (e.statusCode) {
        case 401:
          CustomShowDialog().tokenError(e);
          break;
        default:
          CustomShowDialog().generalDialog(e);
      }
    }
  }

  Future getImageFromGallery(context) async {
    try {
      CustomShowDialog().openLoading(context);

      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
      );

      PlatformFile? file = pickedFile?.files.first;

      var formData = form.FormData.fromMap({
        'photo': await multipart.MultipartFile.fromFile(
          file?.path ?? '',
          filename: file?.path?.split('/').last,
        ),
      });

      print("ISI FORM DATA ${formData.files}");

      var response = await api.dynamicUpdate(
        endpoint: '/change-upload-photo-profile',
        data: formData,
        page: 'user-profile-pic',
        contentType: 'multipart/form-data',
        section: 'user',
      );

      if (response.statusCode == 200) {
        CustomShowDialog().closeLoading();
        getPersonalData();
      }
    } on ErrorResModel catch (e) {
      CustomShowDialog().closeLoading();

      switch (e.statusCode) {
        case 401:
          CustomShowDialog().tokenError(e);
          break;
        default:
          CustomShowDialog().generalDialog(e);
      }
    }
  }

  Future getImageFromCamera(context) async {
    try {
      CustomShowDialog().openLoading(context);
      dynamic picker = ImagePicker();

      PickedFile? pickedFile = await picker.getImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );

      var formData = form.FormData.fromMap({
        'photo': await multipart.MultipartFile.fromFile(
          pickedFile?.path ?? '',
          filename: pickedFile?.path.split('/').last,
        ),
      });

      var response = await api.dynamicUpdate(
        endpoint: '/change-upload-photo-profile',
        data: formData,
        page: 'user-profile-pic',
        contentType: 'multipart/form-data',
        section: 'user',
      );

      if (response.statusCode == 200) {
        CustomShowDialog().closeLoading();
        getPersonalData();
      }
    } on ErrorResModel catch (e) {
      CustomShowDialog().closeLoading();

      switch (e.statusCode) {
        case 401:
          CustomShowDialog().tokenError(e);
          break;
        default:
          CustomShowDialog().generalDialog(e);
      }
    }
  }

  Future removeProfile(context) async {
    try {
      CustomShowDialog().openLoading(context);

      var response = await api.dynamicDelete(
        endpoint: '/delete-upload-photo-profile',
        page: 'user-delete-pic',
        contentType: 'application/json',
        section: 'user',
      );

      if (response.statusCode == 200) {
        CustomShowDialog().closeLoading();
        getPersonalData();
      }
    } on ErrorResModel catch (e) {
      CustomShowDialog().closeLoading();

      switch (e.statusCode) {
        case 401:
          CustomShowDialog().tokenError(e);
          break;
        default:
          CustomShowDialog().generalDialog(e);
      }
    }
  }
}
