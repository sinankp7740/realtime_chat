import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realtime_chat/Controllers/authentication_controller.dart';
import 'package:realtime_chat/Controllers/chat_controller.dart';
import 'package:realtime_chat/Models/chat_model.dart';
import 'package:realtime_chat/Views/chat/widgets/message_box.dart';
import 'package:realtime_chat/my_app.dart';
import 'package:realtime_chat/utils/timestamp_format_conversion.dart';

class ChatView extends StatefulWidget {
  final String recieverEmail;
  final String recieverUid;

  final String userEmail;
  final String userUid;

  ChatView({
    super.key,
    required this.userEmail,
    required this.recieverEmail,
    required this.recieverUid,
    required this.userUid,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with WidgetsBindingObserver {
  final TextEditingController messageCtrl = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final ChatController chatController = Get.put(ChatController());
  final AuthenticationController authenticationController = Get.put(
    AuthenticationController(),
  );

  String chatDocId = "";
  @override
  void initState() {
    super.initState();
    chatDocId = chatController.generateChatDocId(
      widget.recieverUid,
      widget.userUid,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        authenticationController.updateUserStatus(widget.userUid, true);

        break;
      case AppLifecycleState.paused:
        authenticationController.updateUserStatus(widget.userUid, false);

        break;
      case AppLifecycleState.inactive:
        authenticationController.updateUserStatus(widget.userUid, false);

        break;
      case AppLifecycleState.detached:
        authenticationController.updateUserStatus(widget.userUid, false);

        break;
      case AppLifecycleState.hidden:
        authenticationController.updateUserStatus(widget.userUid, false);

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        leadingWidth: 70,
        leading: Container(
          margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () => navigatorKey.currentState?.pop(),
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
        title: Text(
          widget.recieverEmail.split("@").first,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[850], height: 1),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
          right: size.width * 0.04,
          left: size.width * 0.04,
          bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          top: 8,
        ),
        child: Row(
          children: [
            // Text input field
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.grey[900],
                ),
                child: TextField(
                  controller: messageCtrl,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Message...',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.grey[500],
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Send button
            Obx(
              () => InkWell(
                onTap: () async {
                  if (messageCtrl.text.trim().isNotEmpty) {
                    await chatController.sendMessage(
                      senderUid: widget.userUid,
                      receiverUid: widget.recieverUid,
                      senderEmail: widget.userEmail,
                      receiverEmail: widget.recieverEmail,
                      message: messageCtrl.text.trim(),
                    );
                    messageCtrl.clear();
                  }
                },
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey[800]!, Colors.black],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child:
                        chatController.isLoading.value
                            ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // bottomNavigationBar: Container(
      //   margin: EdgeInsets.only(
      //     right: size.width * 0.02,
      //     left: size.width * 0.02,
      //     bottom: MediaQuery.of(context).viewInsets.bottom,
      //   ),
      //   child: Row(
      //     children: [
      //       Expanded(
      //         flex: 5,
      //         child: Card(
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(20),
      //           ),
      //           child: Container(
      //             width: size.width,
      //             padding: const EdgeInsets.symmetric(
      //               vertical: 10,
      //               horizontal: 12,
      //             ),
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(20),
      //               color: Colors.white,
      //               boxShadow: [
      //                 BoxShadow(
      //                   spreadRadius: 1,
      //                   blurRadius: 4,
      //                   // blurStyle: BlurStyle.inner,
      //                   color: Colors.grey.shade300,
      //                   // Color(0xff7090B0),
      //                 ),
      //               ],
      //             ),
      //             child: TextField(
      //               controller: messageCtrl,
      //               style: const TextStyle(
      //                 fontWeight: FontWeight.w400,
      //                 fontSize: 13,
      //               ),
      //               decoration: const InputDecoration(
      //                 isDense: true,
      //                 hintText: 'Type here ....',
      //                 hintStyle: TextStyle(
      //                   fontWeight: FontWeight.w400,
      //                   fontSize: 13,
      //                 ),
      //                 border: InputBorder.none,
      //                 enabledBorder: InputBorder.none,
      //                 focusedBorder: InputBorder.none,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),

      //       Obx(
      //         () => Expanded(
      //           child: InkWell(
      //             onTap: () async {
      //               if (messageCtrl.text.trim().isNotEmpty) {
      //                 await chatController.sendMessage(
      //                   senderUid: widget.userUid,
      //                   receiverUid: widget.recieverUid,
      //                   senderEmail: widget.userEmail,
      //                   receiverEmail: widget.recieverEmail,
      //                   message: messageCtrl.text.trim(),
      //                 );
      //                 messageCtrl.clear();
      //               }
      //             },
      //             child: Container(
      //               padding: const EdgeInsets.all(12),
      //               decoration: BoxDecoration(
      //                 color: Colors.black,
      //                 shape: BoxShape.circle,
      //                 boxShadow: [
      //                   BoxShadow(
      //                     spreadRadius: 1,
      //                     blurRadius: 4,
      //                     // blurStyle: BlurStyle.inner,
      //                     color: Colors.grey.shade200,
      //                     // Color(0xff7090B0),
      //                   ),
      //                 ],
      //               ),
      //               child:
      //                   chatController.isLoading.value
      //                       ? CircularProgressIndicator(
      //                         color: Colors.white,
      //                         strokeWidth: 1,
      //                       )
      //                       : const Icon(Icons.send, color: Colors.white),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: SafeArea(
        bottom: true,
        child: StreamBuilder(
          // initialData: chats.messages,
          stream:
              FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatDocId)
                  .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 1),
                  curve: Curves.fastOutSlowIn,
                );
              });
              Map<String, dynamic>? data = snapshot.data!.data();
              ChatModel? message;
              if (data != null) {
                message = ChatModel.fromJson(data);
              }
              return message == null
                  ? Center(child: Text("Chat seems empty"))
                  : ListView.builder(
                    shrinkWrap: true,
                    controller: scrollController,

                    itemCount: message.messages.length,
                    itemBuilder: (context, index) {
                      Message currentMessage = message!.messages[index];
                      String formattedTime = formatTimestamp(
                        currentMessage.timestamp,
                      );
                      return MessageBox(
                        isUser: currentMessage.senderuid == widget.userUid,
                        message: currentMessage.message,
                        dateTime: formattedTime,
                      );
                    },
                  );
            } else if (snapshot.hasError) {
              return Text("Something went wrong");
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  //************************** */
}
