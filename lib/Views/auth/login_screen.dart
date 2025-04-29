import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:realtime_chat/Controllers/authentication_controller.dart';
import 'package:realtime_chat/Views/auth/registration.dart';
import 'package:realtime_chat/Views/custom%20widgets/text_field.dart';
import 'package:realtime_chat/Views/home/home_screen.dart';
import 'package:realtime_chat/my_app.dart';
import 'package:realtime_chat/utils/email_validation.dart';
import 'package:realtime_chat/utils/snack_bar.dart';
import 'package:realtime_chat/utils/text_styles.dart';
import 'package:realtime_chat/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  ValueNotifier<bool> obscure = ValueNotifier(true);
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final AuthenticationController authenticationController = Get.put(
    AuthenticationController(),
  );

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
          child: Form(
            key: formkey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Obx(
                  //   () => Text(
                  //     '${authenticationController.count}',
                  //     style: Theme.of(context).textTheme.headlineMedium,
                  //   ),
                  // ),
                  const SizedBox(height: 100),
                  const Text(
                    "Hello, Welcome Back! 👋",
                    // textAlign: TextAlign.center,
                    textScaleFactor: 1.2,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 50),

                  Text("Email", style: bodyTextStyle),
                  const SizedBox(height: 5),
                  CustomTextField(
                    prefixIcon: Icons.email,
                    controller: _emailController,
                    isNumber: false,
                  ),
                  Text("Password", style: bodyTextStyle),
                  const SizedBox(height: 5),
                  ValueListenableBuilder(
                    valueListenable: obscure,
                    builder: (context, v, _) {
                      return Stack(
                        children: [
                          CustomTextField(
                            obscureText: v,
                            prefixIcon: Icons.password,

                            controller: _passwordController,
                            isNumber: false,
                          ),

                          Positioned(
                            right: 3,
                            child: IconButton(
                              onPressed: () => obscure.value = !obscure.value,
                              icon: Icon(
                                v ? Icons.visibility_off : Icons.visibility,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 7),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not yet regidtered? "),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                        onPressed:
                            () => navigatorKey.currentState?.push(
                              MaterialPageRoute(builder: (_) => Registration()),
                            ),
                        child: Text("Sign up"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Obx(
                    () => Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.1,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(size.width, 45),
                        ),
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            validation(context);
                          }
                          // authenticationController.increment();
                        },
                        child:
                            authenticationController.isLoading.value
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text("Login"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //*********************************** */
  validation(BuildContext context) async {
    if (!isValidEmail(_emailController.text.trim())) {
      showSnackBar(context, "Enter valid email");
      return;
    }

    String? res = await authenticationController.loginUser(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (res != null && res == 'success') {
      showToast("Login Sucess", true);

      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
      );
    } else {
      log(res.toString());
      showToast("Login failed $res", false);
    }
  }
}
