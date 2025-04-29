import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realtime_chat/Controllers/authentication_controller.dart';
import 'package:realtime_chat/Views/auth/login_screen.dart';
import 'package:realtime_chat/Views/custom%20widgets/text_field.dart';
import 'package:realtime_chat/my_app.dart';
import 'package:realtime_chat/utils/email_validation.dart';
import 'package:realtime_chat/utils/snack_bar.dart';
import 'package:realtime_chat/utils/text_styles.dart';
import 'package:realtime_chat/utils/toast.dart';

class Registration extends StatelessWidget {
  Registration({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final AuthenticationController authenticationController = Get.put(
    AuthenticationController(),
  );
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              const Text(
                "Sign Up",
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

              CustomTextField(
                prefixIcon: Icons.password,

                controller: _passwordController,
                isNumber: false,
              ),
              Text("Confirm Password", style: bodyTextStyle),
              const SizedBox(height: 5),

              CustomTextField(
                prefixIcon: Icons.password,

                controller: _rePasswordController,
                isNumber: false,
              ),
              Obx(
                () => Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(size.width, 45),
                    ),
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        validation(context);
                      } else {
                        log("****");
                      }
                    },
                    child:
                        authenticationController.isLoading.value
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("Register"),
                  ),
                ),
              ),
            ],
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

    if (_passwordController.text.trim() != _rePasswordController.text.trim()) {
      showSnackBar(context, "Password Does not match");
      return;
    }

    String? res = await authenticationController.registerUser(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (res != null && res == 'success') {
      showToast("Registration Sucess", true);

      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    } else {
      log(res.toString());
      showToast("Registration failed $res", false);
    }
  }

  //******************************** */
}
