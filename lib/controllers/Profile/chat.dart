import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:winn_merchant_flutter/controllers/Profile/personal_info.dart';
import 'package:winn_merchant_flutter/controllers/utilities/rest_api.dart';
import 'package:winn_merchant_flutter/models/chat_model.dart';
import 'package:winn_merchant_flutter/models/error.dart';
import 'package:winn_merchant_flutter/widgets/custom_show_dialog.dart';

class ChatController extends GetxController {
  TextEditingController msgController = TextEditingController();

  RestApi api = Get.find<RestApi>();
  String adminMsg = '';
  int adminId = 0;
  ChatModel chatModel = ChatModel();
  List<MessageElement> messages = [];
  GetStorage storage = GetStorage();
  PersonalInfoController userController = Get.put(PersonalInfoController());
  ScrollController scrollController = ScrollController();
  bool loader = true;
  RefreshController refreshController = RefreshController();
  String chatId = '';
  String adminName = '';

  void init() {
    getInitData();
  }

  Future<void> getInitData() async {
    if (userController.user == null) {
      await userController.getPersonalData();
    }
    adminId = storage.read("${userController.user!.id}" + "_adminId");
    chatId = storage.read("${userController.user!.id}" + "_chatId");
    adminName = storage.read("${userController.user!.id}" + "_adminName");

    Stream<QuerySnapshot<Map<String, dynamic>>> stream = getMessages();
    stream.listen((event) {
      if(event.docs.isEmpty || adminId == null){
        callInputChat();
      }else{
        update(['chat']);
      }
    });
    /*if (adminId == null) {
      callInputChat();
    } else {
      getChats();
    }*/
  }

  Future<void> callInputChat() async {
    try {
      var response = await api.dynamicPost(
        endpoint: '',
        section: 'chat',
        data: {},
        page: 'order-confirm',
        contentType: 'application/json',
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data as Map<String, dynamic>;
        adminMsg = data['data']['message_admin'];
        adminId = data['data']['admin_id'];
        chatId = data['data']['chat_id'];
        adminName = data['data']['name_admin'];
        storage.write("${userController.user!.id}" + "_adminId", adminId);
        storage.write("${userController.user!.id}" + "_chatId", chatId);
        storage.write("${userController.user!.id}" + "_adminName", adminName);
        update(['chat']);
      }
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

  /*Future<void> getChats() async {
    try {
      var response = await api.dynamicGet(
        endpoint: '/$adminId',
        section: 'chat',
        page: 'order-confirm',
        contentType: 'application/json',
      );

      if (response.statusCode == 200) {
        chatModel = ChatModel.fromJson(response.data);
        fillMessageList();
        loader = false;
        refreshController.refreshCompleted();
        update(['chat']);
        */
  /*Future.delayed(100.milliseconds, () {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });*//*
      }
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

  void fillMessageList() {
    messages = [];
    if (chatModel.messageUser?.message != null) {
      messages.addAll(chatModel.messageUser?.message ?? []);
    }
    if (chatModel.messageAdmin?.message != null) {
      messages.addAll(chatModel.messageAdmin?.message ?? []);
    }
    messages.sort((a, b) => a.sentAt!.compareTo(b.sentAt!));
  }*/

  Future<void> sendMsg() async {
    try {
     /* Map<String, dynamic> data = {
        'admin_id': adminId,
        'message': msgController.text
      };
      MessageElement msg = MessageElement(
        adminId: adminId,
        messageUser: msgController.text,
        isActive: false,
        userId: userController.user!.id,
        sentAt: DateTime.now().millisecondsSinceEpoch,
        role: Role.USER,
        seenAt: '',
      );
      msgController.clear();

      await FirebaseFirestore.instance
          .collection('chat_users')
          .doc(docId)
          .collection('message').add(msg.toJson());*/
      Map<String, dynamic> data = {
        'admin_id': adminId,
        'message': msgController.text
      };
      msgController.clear();
      loader = true;
      update(['chat']);
      var response = await api.dynamicPost(
        endpoint: '/send',
        section: 'chat',
        data: data,
        page: 'order-confirm',
        contentType: 'application/json',
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data as Map<String, dynamic>;
        update(['chat']);
      }
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

  void jumpToBottom(){
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages() {
    // docId = '"GGVYGHwGOzG+stWpYWVVMABwkR+oJaftBb0uDwxJl3M="-${userController.user!.id}';
    print(chatId);
    return FirebaseFirestore.instance
        .collection('chat_merchants')
        .doc(chatId)
        .collection('message').orderBy('sentAt')
        .snapshots();
  }

}
