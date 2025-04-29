import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  final bool isUser;
  final String message;
  final String dateTime;
  const MessageBox({
    super.key,
    required this.isUser,
    required this.message,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    // return

    // DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
    //     message.createdAt.millisecondsSinceEpoch);

    // String formattedDate = DateFormat('dd-MMM-yyyy').format(dateTime);
    // String todayDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    // String screenDate = todayDate == formattedDate ? "Today" : formattedDate;
    // String formattedTime = DateFormat('hh:mm a').format(dateTime);

    // bool isMe =
    //     message.senderId == user!.userId && message.senderType == 'customer'
    //         ? true
    //         : false;
    return Column(
      children: [
        // isSameDate
        //     ? const SizedBox.shrink()
        //     : Container(
        //         width: 100,
        //         alignment: Alignment.center,
        //         margin: const EdgeInsets.only(top: 5, bottom: 5),
        //         padding: const EdgeInsets.all(3),
        //         decoration: BoxDecoration(
        //             color: Colors.grey.shade300,
        //             borderRadius: BorderRadius.circular(10)),
        //         child: Text(
        //           screenDate,
        //           style: const TextStyle(fontSize: 10, color: Colors.black),
        //         )),
        Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              shadowColor: Colors.blueGrey.shade50,
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              child: Container(
                constraints: BoxConstraints(maxWidth: size.width * 0.7),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 4,
                      // blurStyle: BlurStyle.inner,
                      color: Colors.grey.shade200,
                      // Color(0xff7090B0),
                    ),
                  ],
                  color: isUser ? const Color(0xff006C52) : Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(isUser ? 12 : 0),
                    bottomRight: Radius.circular(isUser ? 0 : 12),
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 13,
                        color: isUser ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateTime,
                      style: TextStyle(
                        fontSize: 9,
                        color: isUser ? Colors.white : Colors.grey.shade500,
                      ),
                    ),
                    // isUser
                    //     ? Icon(
                    //         Icons.done_all,
                    //         color: message.isSeen == false
                    //             ? Colors.white
                    //             : Colors.blue.shade500,
                    //         size: 14,
                    //       )
                    //     : const SizedBox.shrink()
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
