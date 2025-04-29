import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:realtime_chat/Views/auth/login_screen.dart';
import 'package:realtime_chat/Views/home/home_screen.dart';
import 'package:realtime_chat/my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<bool> checkIsLoggedInOrNot() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? useruid = sp.getString("useruid");
    log(useruid.toString(), name: "uid");
    if (useruid != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkIsLoggedInOrNot(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LinearProgressIndicator(color: Colors.white),
            );
          } else if (snapshot.hasData) {
            bool isLoggedIn = snapshot.data!;
            // Navigate based on login status
            Future.microtask(() {
              isLoggedIn
                  ? navigatorKey.currentState?.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                    (route) => false,
                  )
                  : navigatorKey.currentState?.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                    (route) => false,
                  );
            });
            return const SizedBox(); // temporary widget while navigating
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: Text('Something went wrong.'));
          }
        },
      ),
    );
  }
}
