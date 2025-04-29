// import 'package:flutter/material.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:realtime_chat/Views/chat/chat_view.dart';
// import 'package:realtime_chat/my_app.dart';

// class ChatTile extends StatelessWidget {
//   final String userEmail;
//   final String recieverEmail;
//   final String userUid;
//   final String receverUid;
//   final bool isOnline;
//   const ChatTile({
//     super.key,
//     required this.isOnline,
//     required this.userEmail,
//     required this.recieverEmail,
//     required this.userUid,
//     required this.receverUid,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap:
//           () => navigatorKey.currentState?.push(
//             MaterialPageRoute(
//               builder:
//                   (_) => ChatView(
//                     recieverEmail: recieverEmail,
//                     recieverUid: receverUid,
//                     userEmail: userEmail,
//                     userUid: userUid,
//                   ),
//             ),
//           ),
//       leading: CircleAvatar(
//         backgroundColor: Colors.black,
//         child: Icon(Icons.person, color: Colors.white),
//       ),
//       title: Text(recieverEmail),
//       trailing: CircleAvatar(
//         radius: 5,
//         backgroundColor: isOnline ? Colors.green.shade700 : Colors.red.shade700,
//       ),
//     );
//   }
// }
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
    final String displayName = recieverEmail.split('@').first;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey[800]!, Colors.black],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    displayName[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                                isOnline ? Colors.green[400] : Colors.red[400],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isOnline ? 'Online' : 'Offline',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }
}
