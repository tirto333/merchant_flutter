import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:winn_merchant_flutter/controllers/Profile/chat.dart';
import 'package:winn_merchant_flutter/models/chat_model.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  /*TextEditingController nameCon = TextEditingController();
  TextEditingController chatTextCon = TextEditingController();*/
  final ChatController controller = Get.put(ChatController());

  @override
  void initState() {
    controller.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Chat",
          style: TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_outlined),
        ),
        actions: [
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 10),
              child: Text(
                "End",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            GetBuilder<ChatController>(
              id: 'chat',
              builder: (_) {
                return Expanded(
                  child: controller.userController.user == null
                      ? Center(child: CircularProgressIndicator())
                      : Stack(
                          children: [
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                stream: controller.getMessages(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData == false) {
                                    return SizedBox();
                                  }
                                  if (snapshot.data!.docs.isNotEmpty) {
                                    Future.delayed(500.milliseconds, () {
                                      controller.jumpToBottom();
                                    });
                                  }
                                  return ListView.builder(
                                    controller: controller.scrollController,
                                    padding:
                                        EdgeInsets.fromLTRB(14, 24, 14, 10),
                                    itemCount: snapshot.data?.docs.length,
                                    itemBuilder: (context, index) {
                                      MessageElement message =
                                          MessageElement.fromJson(snapshot
                                              .data!.docs[index]
                                              .data());
                                      if (message.role == Role.ADMIN) {
                                        return adminMsg(message.messageAdmin!);
                                      } else {
                                        return merchantMsg(
                                            message.messageUser ?? '');
                                      }
                                    },
                                  );
                                }),
                            /*controller.loader
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : SizedBox(),*/
                          ],
                        ),
                );
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width - 10,
              margin: EdgeInsets.only(left: 5, right: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Divider(
                    thickness: 1,
                    color: Color(0xFFBDBDBD),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      border: Border.all(
                        color: Color(0xffbdbdbd),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: controller.msgController,
                        style: TextStyle(color: Colors.black),
                        textInputAction: TextInputAction.newline,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type your replay",
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          contentPadding: EdgeInsets.all(5),
                          suffixIcon: InkWell(
                            onTap: controller.sendMsg,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Send",
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 9)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget adminMsg(String msg) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.adminName,
              style: TextStyle(
                color: Color(0xFFACACAC),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 3),
            Container(
              constraints: BoxConstraints(
                minWidth: 10,
                maxWidth: Get.width - 28,
              ),
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: Color(0xFF2D368B),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Text(
                msg,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(height: 14),
          ],
        ),
      ],
    );
  }

  Widget merchantMsg(String msg) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "ME",
              style: TextStyle(
                color: Color(0xFFACACAC),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 3),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              constraints: BoxConstraints(
                minWidth: 10,
                maxWidth: Get.width - 28,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: Color(0xFFECECEC),
                  width: 1,
                ),
              ),
              child: Text(
                msg,
                style: TextStyle(
                  color: Color(0xFF292929),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(height: 14),
          ],
        ),
      ],
    );
  }
}
