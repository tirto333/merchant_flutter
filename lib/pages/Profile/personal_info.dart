import 'package:cached_network_image/cached_network_image.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Profile/personal_info.dart';
import 'package:winn_merchant_flutter/helpers/custom_date.dart';
import 'package:winn_merchant_flutter/pages/Address/saved_address.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';
import 'package:winn_merchant_flutter/widgets/custom_appbar.dart';
import 'package:winn_merchant_flutter/widgets/custom_button.dart';
import 'package:winn_merchant_flutter/widgets/custom_form_field.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';
import 'package:winn_merchant_flutter/widgets/general_text.dart';

class PersonalInfoPage extends StatelessWidget {
  final PersonalInfoController controller = Get.put(PersonalInfoController());

  @override
  Widget build(BuildContext context) {
    print("DIPANGGIL + PersonalInfoPage");
    return Scaffold(
      appBar: CustomAppBar().generalAppBar(
        title: "Merchant Information",
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () => Get.back(),
        ),
        // elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: GetBuilder<PersonalInfoController>(
            id: 'user-info',
            builder: (_) {
              return ListView(
                children: [
                  buildProfilePhoto(context),
                  SizedBox(height: 5),
                  buildProfileInfo(context),
                ],
              );
            }),
      ),
    );
  }

  Future editField(BuildContext context) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 3,
                  width: 40,
                  decoration: ShapeDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "CHANGE ${controller.info[controller.stringEdited ?? 0]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 10,
                  thickness: 1.5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 10.0,
                  ),
                  child:
                      // controller.stringEdited == 2
                      //     ? Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           WinnGeneralText(
                      //             title: 'date of birth'.toUpperCase(),
                      //             border: TextDecoration.none,
                      //             colorTitle: Colors.black,
                      //           ),
                      //           SizedBox(height: 5),
                      //           Container(
                      //             height: 60,
                      //             decoration: BoxDecoration(
                      //               color: Colors.grey[300],
                      //               borderRadius: BorderRadius.circular(20),
                      //             ),
                      //             child: Padding(
                      //               padding: const EdgeInsets.symmetric(
                      //                 horizontal: 15,
                      //               ),
                      //               child: Center(
                      //                 child: DateTimeField(
                      //                   onChanged: (val) {
                      //                     // controller.checkField();
                      //                   },
                      //                   controller: controller.edited,
                      //                   format: DateFormat('dd/MM/yyyy'),
                      //                   onShowPicker:
                      //                       (context, currentValue) async {
                      //                     CustomShowDialog().calendarDate(
                      //                       context,
                      //                       () {
                      //                         if (controller.edited?.text == '') {
                      //                           controller.datePickerChange(
                      //                               DateTime.now());
                      //                         }
                      //                         Get.back();
                      //                       },
                      //                       (date) {
                      //                         controller.datePickerChange(date);
                      //                       },
                      //                       controller.edited?.text != ''
                      //                           ? DateTime.parse(
                      //                               CustomDate().dateParse(
                      //                                 controller.edited?.text,
                      //                               ),
                      //                             )
                      //                           : null,
                      //                     );
                      //                   },
                      //                   decoration: InputDecoration(
                      //                     hintText: 'dd/mm/yyyy',
                      //                     hintStyle: TextStyle(
                      //                       color: Colors.black,
                      //                     ),
                      //                     border: UnderlineInputBorder(
                      //                       borderSide: BorderSide(
                      //                         color: Colors.transparent,
                      //                       ),
                      //                     ),
                      //                     enabledBorder: UnderlineInputBorder(
                      //                       borderSide: BorderSide(
                      //                         color: Colors.transparent,
                      //                       ),
                      //                     ),
                      //                     focusedBorder: UnderlineInputBorder(
                      //                       borderSide: BorderSide(
                      //                         color: Colors.transparent,
                      //                       ),
                      //                     ),
                      //                     suffixIcon: Icon(
                      //                       Icons.calendar_today_sharp,
                      //                       size: 18,
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       )
                      //     :
                      WinnFormField(
                    controller: controller.edited,
                    title: controller.info[controller.stringEdited ?? 0],
                    colorTitle: Color(0xFF292929),
                    fillColor: Color(0xFFF2F2F2),
                    textInputType: controller.stringEdited == 3
                        ? TextInputType.emailAddress
                        : (controller.stringEdited == 2 ||
                                controller.stringEdited == 5 ||
                                controller.stringEdited == 6)
                            ? TextInputType.number
                            : TextInputType.text,
                    textInputAction: TextInputAction.done,
                    hint: controller.info[controller.stringEdited ?? 0],
                  ),
                ),
                CustomButton(
                  text: 'Save Changes',
                  textColor: Colors.white,
                  borderSideColor: primaryColor,
                  colorButton: primaryColor,
                  sizeHeight: 50,
                  sizeWidth: MediaQuery.of(context).size.width / 1.1,
                  fontSize: 14,
                  borderRadiusSize: 10,
                  onPressed: () {
                    Get.back();
                    controller.submit(context);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Column buildProfileInfo(BuildContext context) {
    return Column(
      children: List.generate(
        controller.info.length,
        (index) {
          return Column(
            children: [
              ListTile(
                title: WinnGeneralText(
                  title: controller.info[index],
                  fontSize: 12,
                  colorTitle: Color(0xFF737373),
                  border: TextDecoration.none,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.start,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: WinnGeneralText(
                    title: controller.userInfo?[index],
                    fontSize: 16,
                    colorTitle: Colors.black,
                    border: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start,
                  ),
                ),
                trailing: controller.info[index] != "COMPANY EMAIL"
                    ? Text(
                        "Edit",
                        style: TextStyle(
                          color: primaryColor,
                        ),
                      )
                    : null,
                onTap: () async {
                  if (controller.info[index] != "COMPANY EMAIL") {
                    controller.selectedIndex(index: index);
                    editField(context);
                  }
                },
                visualDensity: VisualDensity(
                  horizontal: 0,
                  vertical: -3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Divider(
                  height: 3,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Container buildProfilePhoto(context) {
    return Container(
      // height: 200,
      width: double.infinity,
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 10),
            Stack(children: [
              controller.user?.photo != null
                  ? GestureDetector(
                      onTap: () {
                        openProfileMenu(context);
                      },
                      child: Container(
                        width: 140.0,
                        height: 140.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: controller.api.content +
                              '/merchant/profile_merchant/${controller.user?.photo}',
                          imageBuilder: (context, imageProvider) => Container(
                            width: 140.0,
                            height: 140.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/avatar-img.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        openProfileMenu(context);
                      },
                      child: CachedNetworkImage(
                        imageUrl: controller.api.content +
                            '/merchant/profile_merchant/default-profile.jpg',
                        imageBuilder: (context, imageProvider) => Container(
                          width: 140.0,
                          height: 140.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/avatar-img.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      /*CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage(
                          'assets/images/maskot.png',
                        ),
                        backgroundColor: Colors.transparent,
                      ),*/
                    ),
              Positioned(
                  right: 10,
                  bottom: 1,
                  child: GestureDetector(
                    onTap: () {
                      openProfileMenu(context);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                      ),
                      child: Center(
                        child: SvgPicture.asset('assets/icons/bi_camera.svg'),
                      ),
                    ),
                  ))
            ]),
            SizedBox(height: 10),
            Text(
              "Change photo",
              style: TextStyle(
                fontSize: 16,
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future openProfileMenu(BuildContext context) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 3,
                    width: 40,
                    decoration: ShapeDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Change Profile Picture',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 10,
                    thickness: 1.5,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await controller.getImageFromCamera(context);
                      Navigator.pop(context);
                    },
                    // onTap: controller.user?.photo == null
                    //     ? () async {
                    //         //await controller.getImageFromCamera(context);
                    //         Navigator.of(context).pop();
                    //       }
                    //     : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: WinnGeneralText(
                        title: 'Take Photo',
                        border: TextDecoration.none,
                        textAlign: TextAlign.center,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        colorTitle: primaryColor,
                      ),
                    ),
                  ),
                  Divider(
                    height: 10,
                    thickness: 1.5,
                  ),
                  GestureDetector(
                    onTap: () async {
                      controller.getImageFromGallery(context);
                      Navigator.pop(context);
                    },
                    // onTap: controller.user?.photo == null
                    //     ? () async {
                    //        // controller.getImageFromGallery(context);
                    //         Navigator.pop(context);
                    //       }
                    //     : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: WinnGeneralText(
                        title: 'Open Gallery',
                        border: TextDecoration.none,
                        textAlign: TextAlign.center,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        colorTitle: primaryColor,
                      ),
                    ),
                  ),
                  Divider(
                    height: 10,
                    thickness: 1.5,
                  ),
                  GestureDetector(
                    onTap: controller.user?.photo != null
                        ? () async {
                            await controller.removeProfile(context);
                            Navigator.pop(context);
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: WinnGeneralText(
                        title: 'Remove Profile Picture',
                        border: TextDecoration.none,
                        textAlign: TextAlign.center,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        colorTitle: controller.user?.photo != null
                            ? primaryColor
                            : Colors.grey[400],
                      ),
                    ),
                  ),
                  Divider(
                    height: 10,
                    thickness: 1.5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: WinnGeneralText(
                        title: 'Cancel',
                        border: TextDecoration.none,
                        textAlign: TextAlign.center,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        colorTitle: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
