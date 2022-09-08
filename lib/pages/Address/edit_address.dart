import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Address/add_edit.dart';
import 'package:winn_merchant_flutter/models/address.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/custom_appbar.dart';
import 'package:winn_merchant_flutter/widgets/custom_button.dart';
import 'package:winn_merchant_flutter/widgets/custom_form_field.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';

class EditAddressPage extends StatelessWidget {
  final AddressFormController controller = Get.find<AddressFormController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: GetBuilder<AddressFormController>(
          id: 'form-body',
          builder: (_) {
            if (controller.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                children: [
                  CustomAppBar().tapAppBar(
                    title: controller.pageName,
                    onpress: () {
                      Get.back();
                    },
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: buildEditAddressForm(context),
                  ),
                  SizedBox(height: 5),
                  GetBuilder<AddressFormController>(
                    id: 'primary-address',
                    builder: (_) {
                      return buildPrimaryAddressOption();
                    },
                  ),
                  SizedBox(height: 5),
                  CustomButton(
                    text: "Save Address",
                    borderRadiusSize: 10,
                    textColor: Colors.white,
                    borderSideColor: primaryColor,
                    colorButton: primaryColor,
                    onPressed: () {
                      controller.submit();
                    },
                  ),
                  SizedBox(height: 5),
                  CustomButton(
                    text: "Delete Address",
                    borderRadiusSize: 10,
                    textColor:Colors.white,
                    borderSideColor: primaryColor,
                    colorButton:primaryColor,
                    onPressed: () {
                      controller.deleteAddress();
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Row buildPrimaryAddressOption() {
    return Row(
      children: [
        Checkbox(
            value: controller.isMainAddress,
            onChanged: (bool? newValue) {
              controller.tickMainAddress();
            }),
        SizedBox(width: 5),
        Text('Set as main address')
      ],
    );
  }

  Widget buildEditAddressForm(context) {
    return GetBuilder<AddressFormController>(
      id: 'content-form',
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WinnFormField(
              colorTitle: Colors.black,
              fillColor: Color(0xFFF2F2F2),
              controller: controller.addressName,
              title: 'address name'.toUpperCase(),
              hint: "Address Name",
            ),
            // SizedBox(
            //   height: 5,
            // ),
            // WinnGeneralText(
            //   title: "ADDRESS NAME",
            //   colorTitle: Colors.black,
            //   border: TextDecoration.none,
            // ),
            // SizedBox(height: 5),
            // Container(
            //   height: 60,
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 15,
            //     ),
            //     child: Center(
            //       child: DropdownButton<String>(
            //         value: controller.titleNameAddress,
            //         icon: Icon(Icons.expand_more_outlined),
            //         isExpanded: true,
            //         iconSize: 32,
            //         elevation: 16,
            //         style: const TextStyle(
            //           color: Colors.black,
            //           fontSize: 16,
            //         ),
            //         iconEnabledColor: Colors.black,
            //         underline: Container(
            //           height: 1,
            //           color: Colors.transparent,
            //         ),
            //         onChanged: (val) {
            //           controller.dropdownNameAddress(val);
            //           // controller.checkField();
            //         },
            //         items: controller.titlesNameAddress
            //             .map<DropdownMenuItem<String>>((String value) {
            //           return DropdownMenuItem<String>(
            //             value: value,
            //             child: Text(value),
            //           );
            //         }).toList(),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            WinnFormField(
              colorTitle: Colors.black,
              fillColor: Color(0xFFF2F2F2),
              controller: controller.receiverName,
              title: 'receiver name'.toUpperCase(),
              hint: "Receiver Name",
            ),
            SizedBox(
              height: 20,
            ),
            WinnFormField(
              colorTitle: Colors.black,
              fillColor: Color(0xFFF2F2F2),
              controller: controller.receiverPhone,
              title: 'phone number'.toUpperCase(),
              textInputType: TextInputType.number,
              hint: "Phone Number",
            ),
            SizedBox(
              height: 20,
            ),
            WinnFormField(
              colorTitle: Colors.black,
              fillColor: Color(0xFFF2F2F2),
              controller: controller.completeAddress,
              title: 'complete address'.toUpperCase(),
              textInputType: TextInputType.multiline,
              minLines: 3,
              maxLines: 10,
              hint: "Complete Address",
            ),
            SizedBox(
              height: 20,
            ),
            WinnGeneralText(
              title: 'province'.toUpperCase(),
              border: TextDecoration.none,
              colorTitle: Colors.black,
            ),
            SizedBox(height: 5),
            GetBuilder<AddressFormController>(
              id: 'province-region',
              builder: (_) {
                return Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Center(
                      child: DropdownButton<String>(
                        value: controller.province,
                        icon: Icon(Icons.expand_more_outlined),
                        isExpanded: true,
                        iconSize: 32,
                        elevation: 16,
                        hint: Text(
                          'Select Province',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        iconEnabledColor: Colors.black,
                        underline: Container(
                          height: 1,
                          color: Colors.transparent,
                        ),
                        onChanged: (String? val) {
                          controller.dropdownChange(val, 'province');
                        },
                        items: controller.provinces
                            ?.map<DropdownMenuItem<String>>(
                                (LocalAddress value) {
                          return DropdownMenuItem<String>(
                            value: "${value.id}",
                            child: Text("${value.name}"),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GetBuilder<AddressFormController>(
                  id: 'city-region',
                  builder: (_) {
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WinnGeneralText(
                            title: 'city'.toUpperCase(),
                            border: TextDecoration.none,
                            colorTitle: Colors.black,
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Center(
                                child: DropdownButton<String>(
                                  value: controller.city,
                                  icon: Icon(Icons.expand_more_outlined),
                                  isExpanded: true,
                                  iconSize: 32,
                                  elevation: 16,
                                  hint: Text(
                                    'Select City',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  iconEnabledColor: Colors.black,
                                  underline: Container(
                                    height: 1,
                                    color: Colors.transparent,
                                  ),
                                  onChanged: (String? val) {
                                    controller.dropdownChange(val, 'city');
                                  },
                                  items: controller.cities
                                      ?.map<DropdownMenuItem<String>>(
                                          (LocalAddress value) {
                                    return DropdownMenuItem<String>(
                                      value: "${value.id}",
                                      child: Text("${value.name}"),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(width: 15),
                GetBuilder<AddressFormController>(
                  id: 'subdistrict-region',
                  builder: (_) {
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WinnGeneralText(
                            title: 'sub-district'.toUpperCase(),
                            border: TextDecoration.none,
                            colorTitle: Colors.black,
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Center(
                                child: DropdownButton<String>(
                                  value: controller.subDistrict,
                                  icon: Icon(Icons.expand_more_outlined),
                                  isExpanded: true,
                                  iconSize: 32,
                                  elevation: 16,
                                  hint: Text(
                                    'Select Sub-District',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  iconEnabledColor: Colors.black,
                                  underline: Container(
                                    height: 1,
                                    color: Colors.transparent,
                                  ),
                                  onChanged: (String? val) {
                                    controller.dropdownChange(
                                      val,
                                      'subdistrict',
                                    );
                                  },
                                  items: controller.districts
                                      ?.map<DropdownMenuItem<String>>(
                                          (LocalAddress value) {
                                    return DropdownMenuItem<String>(
                                      value: "${value.id}",
                                      child: Text("${value.name}"),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GetBuilder<AddressFormController>(
                  id: 'urban-region',
                  builder: (_) {
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WinnGeneralText(
                            title: 'urban village'.toUpperCase(),
                            border: TextDecoration.none,
                            colorTitle: Colors.black,
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Center(
                                child: DropdownButton<String>(
                                  value: controller.urbanVillage,
                                  icon: Icon(Icons.expand_more_outlined),
                                  isExpanded: true,
                                  iconSize: 32,
                                  elevation: 16,
                                  hint: Text(
                                    'Select Urban Village',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  iconEnabledColor: Colors.black,
                                  underline: Container(
                                    height: 1,
                                    color: Colors.transparent,
                                  ),
                                  onChanged: (String? val) {
                                    controller.dropdownChange(
                                      val,
                                      'urban',
                                    );
                                  },
                                  items: controller.urbans
                                      ?.map<DropdownMenuItem<String>>(
                                          (LocalAddress value) {
                                    return DropdownMenuItem<String>(
                                      value: "${value.id}",
                                      child: Text("${value.name}"),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WinnGeneralText(
                        title: 'postal code'.toUpperCase(),
                        border: TextDecoration.none,
                        colorTitle: Colors.black,
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 1,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                          controller: controller.postalCode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Stack(children: [
              GetBuilder<AddressFormController>(
                id: 'content-map',
                builder: (_) {
                  return Container(
                    height: 200,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: controller.initialCameraPosition ??
                          CameraPosition(
                            target: LatLng(
                              -6.2422017,
                              106.8490304,
                            ),
                            zoom: 20.0,
                          ),
                      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                        new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
                      ].toSet(),
                      onMapCreated: (GoogleMapController _) {
                        controller.completer.complete(_);
                      },
                      markers: controller.marker,
                      onTap: (latlng) {
                        controller.changePosition(latlng);
                      },
                    ),
                  );
                },
              ),
              Positioned(
                right: MediaQuery.of(context).size.width / 3,
                bottom: 25,
                child: GestureDetector(
                  onTap: () {
                    controller.getAddressFromGoogle();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "Add via Map",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ])
          ],
        );
      },
    );
  }
}
