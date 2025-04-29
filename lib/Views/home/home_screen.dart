import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realtime_chat/Controllers/authentication_controller.dart';
import 'package:realtime_chat/Views/auth/login_screen.dart';
import 'package:realtime_chat/Views/home/widgets/chat_tile.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Chats")),

//       body: ChatTile(email: "SinanKp7740", isOnline: true),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realtime_chat/my_app.dart';
import 'package:realtime_chat/utils/snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  String userUid = "";
  String userEmail = "";
  getUserUid() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userUid = sp.getString("useruid") ?? "";
    userEmail = sp.getString("useremail") ?? "";
  }

  final AuthenticationController authenticationController = Get.put(
    AuthenticationController(),
  );

  @override
  void initState() {
    getUserUid();
    WidgetsBinding.instance.addObserver(this);
    authenticationController.updateUserStatus(userUid, true);
    super.initState();
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
        authenticationController.updateUserStatus(userUid, true);

        break;
      case AppLifecycleState.paused:
        authenticationController.updateUserStatus(userUid, false);

        break;
      case AppLifecycleState.inactive:
        authenticationController.updateUserStatus(userUid, false);

        break;
      case AppLifecycleState.detached:
        authenticationController.updateUserStatus(userUid, false);

        break;
      case AppLifecycleState.hidden:
        authenticationController.updateUserStatus(userUid, false);

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        centerTitle: false,
        title: const Text(
          'Chats',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => showLogoutDialog(context),
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 22,
              ),
              tooltip: 'Logout',
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[850], height: 1),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .orderBy('createdAt', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong!: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          } else {
            // Filter out the excluded UID
            final users =
                snapshot.data!.docs
                    .where((doc) => doc['uid'] != userUid)
                    .toList();

            if (users.isEmpty) {
              return const Center(child: Text('No other users found.'));
            }

            return ListView.builder(
              itemCount: users.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final user = users[index];
                final email = user['email'] ?? 'No Email';
                final uid = user['uid'] ?? 'No UID';
                final status = user['status'] ?? "offline";
                return ChatTile(
                  userEmail: userEmail,
                  userUid: userUid,
                  recieverEmail: email,
                  receverUid: uid,
                  isOnline: status == "online" ? true : false,
                );
                // ListTile(
                //   leading: const Icon(Icons.person),
                //   title: Text(email),
                //   subtitle: Text('UID: $uid'),
                // );
              },
            );
          }
        },
      ),
    );
  }

  //**************************** */

  Future<void> showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                navigatorKey.currentState?.pop();
              },
            ),
            Obx(
              () => ElevatedButton(
                child:
                    authenticationController.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : const Text('Yes'),
                onPressed: () async {
                  bool isLoggedOut = await authenticationController.logout();
                  if (isLoggedOut) {
                    navigatorKey.currentState?.pop();
                    navigatorKey.currentState?.pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                      (route) => false,
                    );
                  } else {
                    navigatorKey.currentState?.pop();

                    if (context.mounted) {
                      showSnackBar(context, "Failed to Logged out");
                    }
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
