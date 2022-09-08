import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';
import 'package:winn_merchant_flutter/models/address.dart';
import 'package:winn_merchant_flutter/models/error.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';
import 'main.dart';

class AddressFormController extends GetxController {
  late String? pageName;
  int? selectedIdAddress;
  late TextEditingController? receiverName = new TextEditingController();
  late TextEditingController? receiverPhone = new TextEditingController();
  late TextEditingController? addressName = new TextEditingController();
  late TextEditingController? completeAddress = new TextEditingController();
  late TextEditingController? postalCode = new TextEditingController();
  late String? province;
  late String? city;
  late String? subDistrict;
  late String? urbanVillage;
  late LocationData? currentPosition;
  late String? address;
  late PermissionStatus? permissionGranted;
  late GoogleMapController mapController;
  late Set<Marker> marker = HashSet<Marker>();
  Location location = Location();
  late CameraPosition? initialCameraPosition;
  late LatLng initialPosition;
  late Completer<GoogleMapController> completer = Completer();
  bool isMainAddress = false;
  late List<LocalAddress>? provinces = <LocalAddress>[];
  late List<LocalAddress>? cities = <LocalAddress>[];
  late List<LocalAddress>? districts = <LocalAddress>[];
  late List<LocalAddress>? urbans = <LocalAddress>[];
  bool isLoading = false;
  late String section;
  late double? latitude;
  late double? longitude;

  String titleNameAddress = 'Home';
  List<String> titlesNameAddress = ['Home', 'Office'];

  RestApi api = Get.find<RestApi>();
  late SavedAddressController saved;

  void onInit() async {
    Get.lazyPut(() => saved = SavedAddressController());
    permissionGetLocation();
    await getInitalLocation();
    await getRegion(section: 'province', url: 'province');
    super.onInit();
  }

  void dropdownNameAddress(value) {
    titleNameAddress = value;
  }

  Future getRegion({String? section, String? url}) async {
    try {
      var addressRes = await api.dynamicGet(
        section: 'region',
        endpoint: '/$url',
        page: 'region-$section',
        contentType: "application/json",
      );

      switch (section) {
        case 'province':
          provinces = LocalAddressResModel.fromJson(addressRes.data).data?.rows;
          break;
        case 'city':
          cities = LocalAddressResModel.fromJson(addressRes.data).data?.rows;
          break;
        case 'subdistrict':
          districts = LocalAddressResModel.fromJson(addressRes.data).data?.rows;
          break;
        case 'urban':
          urbans = LocalAddressResModel.fromJson(addressRes.data).data?.rows;
          break;
        default:
      }

      update(['$section-region']);
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

  void addAddress() {
    pageName = 'Add New Address';
    receiverName = new TextEditingController();
    receiverPhone = new TextEditingController();
    addressName = new TextEditingController();
    completeAddress = new TextEditingController();
    postalCode = new TextEditingController();
    province = null;
    city = null;
    subDistrict = null;
    urbanVillage = null;
    section = 'add';
    getLocation();
    update(['content-map']);
  }

  void editAddress(int? index) async {
    var selectedAddress = saved.addresses[index ?? 0];
    selectedIdAddress = selectedAddress.id ?? 1;
    pageName = 'Edit Address';
    receiverName?.text = selectedAddress.name ?? '';
    receiverPhone?.text = selectedAddress.phone ?? '';
    addressName?.text = selectedAddress.label ?? '';
    completeAddress?.text = selectedAddress.address ?? '';
    postalCode?.text = selectedAddress.postalCode ?? '';
    province = "${selectedAddress.province}";
    city = "${selectedAddress.city}";
    subDistrict = "${selectedAddress.subDistrict}";
    urbanVillage = selectedAddress.urbanVillage.toString();
    section = 'edit';
    isMainAddress = selectedAddress.status != null ? true : false;
    // getLocation(
    //   section: 'edit',
    //   curLatitude: selectedAddress.map?.latitude,
    //   curLongitude: selectedAddress.map?.longitude,
    // );
    await getAddress(
      province: selectedAddress.province,
      city: selectedAddress.city,
      subDistrict: selectedAddress.subDistrict,
    );
    update(['content-map']);
  }

  Future getAddress({
    int? province,
    int? city,
    int? subDistrict,
  }) async {
    await getRegion(
      section: 'province',
      url: 'province',
    );
    await getRegion(
      section: 'city',
      url: 'cities/$province',
    );
    await getRegion(
      section: 'subdistrict',
      url: 'subdistrict/$city',
    );
    await getRegion(
      section: 'urban',
      url: 'urbanvillage/$subDistrict',
    );
  }

  void permissionGetLocation() async {
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future getInitalLocation() async {
    currentPosition = await location.getLocation();
    initialPosition = LatLng(
      currentPosition?.latitude ?? 0.5937,
      currentPosition?.longitude ?? 0.5937,
    );

    latitude = currentPosition?.latitude;
    longitude = currentPosition?.longitude;

    initialCameraPosition = CameraPosition(
      target: initialPosition,
      zoom: 20.0,
    );
  }

  void getLocation({
    String section = 'add',
    double? curLatitude,
    double? curLongitude,
  }) async {
    mapController = await completer.future;
    currentPosition = await location.getLocation();

    switch (section) {
      case 'add':
        initialPosition = LatLng(
          currentPosition?.latitude ?? 0.5937,
          currentPosition?.longitude ?? 0.5937,
        );

        latitude = currentPosition?.latitude;
        longitude = currentPosition?.longitude;
        break;
      case 'edit':
        initialPosition = LatLng(
          curLatitude ?? 0.5937,
          curLongitude ?? 0.5937,
        );

        latitude = curLatitude;
        longitude = curLongitude;
        break;
      default:
    }

    marker.clear();

    marker.add(Marker(
      markerId: MarkerId('current'),
      position: initialPosition,
    ));

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: initialPosition,
          zoom: 20.0,
        ),
      ),
    );

    update(['content-map']);
  }

  void changePosition(LatLng latlng) async {
    mapController = await completer.future;
    marker.clear();

    marker.add(Marker(
      markerId: MarkerId('current'),
      position: latlng,
    ));

    initialPosition = latlng;

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latlng,
          zoom: 20.0,
        ),
      ),
    );

    update(['content-map']);
  }

  void getAddressFromGoogle() async {
    final coordinates = new Coordinates(
      initialPosition.latitude,
      initialPosition.longitude,
    );

    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    print(first.addressLine);
    print(first.adminArea);
    print(first.subAdminArea);
    print(first.locality);
    print(first.subLocality);
    print(first.postalCode);

    completeAddress?.text = first.addressLine;
    latitude = initialPosition.latitude;
    longitude = initialPosition.longitude;

    update(['content-form']);
  }

  void tickMainAddress() {
    isMainAddress = !isMainAddress;
    update(['primary-address']);
  }

  void dropdownChange(String? value, String? section) {
    switch (section) {
      case 'province':
        province = value;
        city = null;
        subDistrict = null;
        urbanVillage = null;
        getRegion(
          section: 'city',
          url: 'cities/$value',
        );
        break;
      case 'city':
        city = value;
        subDistrict = null;
        urbanVillage = null;
        getRegion(
          section: 'subdistrict',
          url: 'subdistrict/$value',
        );
        break;
      case 'subdistrict':
        subDistrict = value;
        urbanVillage = null;
        getRegion(
          section: 'urban',
          url: 'urbanvillage/$value',
        );
        break;
      case 'urban':
        urbanVillage = value;
        break;
      default:
    }

    update(['content-form']);
  }

  void submit() async {
    try {
      // isLoading = true;
      update(['form-body']);
      var response;

      var form = {
        "address": addressName?.text,
        "name": receiverName?.text,
        "phone": receiverPhone?.text,
        "complete_address": completeAddress?.text,
        "province": province,
        "city": city,
        "sub_district": subDistrict,
        "urban_village": urbanVillage,
        "postal_code": postalCode?.text,
        "map": {
          "latitude": latitude,
          "longitude": longitude,
        },
        "status": isMainAddress ? "main" : null,
      };

      switch (section) {
        case 'add':
          response = await api.dynamicPost(
            section: 'user',
            endpoint: '/addresses-input',
            data: form,
            contentType: "application/json",
            page: 'submit-address',
          );
          break;
        default:
          response = await api.dynamicUpdate(
            section: 'user',
            endpoint: '/addresses/${selectedIdAddress.toString()}',
            data: form,
            contentType: "application/json",
            page: 'update-address',
          );
      }

      if (response.statusCode == 200) {
        await saved.initial();
        // isLoading = false;
        province = null;
        city = null;
        subDistrict = null;
        urbanVillage = null;
        postalCode?.text = '';
        receiverName?.text = '';
        receiverPhone?.text = '';
        addressName?.text = '';
        completeAddress?.text = '';
        isMainAddress = false;
        Get.back();
        switch (section) {
          case 'add':
            Get.snackbar(
              'Success',
              'Address successful added',
              snackPosition: SnackPosition.BOTTOM,
            );
            break;
          default:
            Get.snackbar(
              'Success',
              'Address successful updated',
              snackPosition: SnackPosition.BOTTOM,
            );
        }
      }
    } on ErrorResModel catch (e) {
      print("GAGAL DSINI");
      // isLoading = false;
      update(['form-body']);

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

  void deleteAddress() async {
    try
    {
      isLoading = true;
      update(['form-body']);


      var form = {
        "address": completeAddress?.text,
        "complete_address": completeAddress?.text,
        "province": province,
        "city": city,
        "sub_district": subDistrict,
        "urban_village": urbanVillage,
        "postal_code": postalCode?.text,
        "map": {
          "latitude": latitude,
          "longitude": longitude,
        },
        "status": isMainAddress ? "main" : null,
      };

      var response = await api.dynamicDelete(
        section: 'user',
        endpoint: '/addresses-delete/${selectedIdAddress.toString()}',
        data: form,
        contentType: "application/json",
        page: 'update-address',
      );

      if (response.statusCode == 200) {
        await saved.initial();

        isLoading = false;
        province = null;
        city = null;
        subDistrict = null;
        urbanVillage = null;
        postalCode?.text = '';
        receiverName?.text = '';
        receiverPhone?.text = '';
        addressName?.text = '';
        completeAddress?.text = '';
        isMainAddress = false;
        Get.back();
        switch (section) {
          case 'add':
            Get.snackbar(
              'Success',
              'Address successful added',
              snackPosition: SnackPosition.BOTTOM,
            );
            break;
          default:
            Get.snackbar(
              'Success',
              'Address successful updated',
              snackPosition: SnackPosition.BOTTOM,
            );
        }
      }
    } on ErrorResModel catch (e) {
      isLoading = false;
      update(['form-body']);

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
