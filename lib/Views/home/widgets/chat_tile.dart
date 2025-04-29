import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:realtime_chat/Views/chat/chat_view.dart';
import 'package:realtime_chat/my_app.dart';

class ChatTile extends StatelessWidget {
  final String userEmail;
  final String recieverEmail;
  final String userUid;
  final String receverUid;
  final bool isOnline;
  const ChatTile({
    super.key,
    required this.isOnline,
    required this.userEmail,
    required this.recieverEmail,
    required this.userUid,
    required this.receverUid,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap:
          () => navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder:
                  (_) => ChatView(
                    recieverEmail: recieverEmail,
                    recieverUid: receverUid,
                    userEmail: userEmail,
                    userUid: userUid,
                  ),
            ),
          ),
      leading: CircleAvatar(
        backgroundColor: Colors.black,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(recieverEmail),
      trailing: CircleAvatar(
        radius: 5,
        backgroundColor: isOnline ? Colors.green.shade700 : Colors.red.shade700,
      ),
    );
  }
}
