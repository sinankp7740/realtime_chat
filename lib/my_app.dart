import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realtime_chat/Views/auth/login_screen.dart';
import 'package:realtime_chat/Views/splash_screen.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      showSemanticsDebugger: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        dialogBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.black),
            foregroundColor: WidgetStateProperty.all(Colors.white),
          ),
        ),

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: SplashScreen(),
    );
  }
}
