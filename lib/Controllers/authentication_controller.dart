import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realtime_chat/Views/auth/login_screen.dart';
import 'package:realtime_chat/my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //********************* */

  var count = 0.obs;

  void increment() {
    count++;
  }

  //********************* */
  var isLoading = false.obs;

  Future<String?> registerUser(String email, String password) async {
    try {
      isLoading.value = true;
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'password': password,
          'status': 'offline',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      isLoading.value = false;

      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        isLoading.value = false;

        return 'This email is already registered. Please login.';
      } else if (e.code == 'invalid-email') {
        isLoading.value = false;

        return 'Invalid email address format.';
      } else {
        isLoading.value = false;

        return e.message;
      }
    } catch (e) {
      isLoading.value = false;

      return 'An unexpected error occurred';
    }
  }

  //************************************************ */
  Future<String?> loginUser(String email, String password) async {
    try {
      isLoading.value = true;

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        //**************  store uid in local storage

        await _firestore.collection('users').doc(user.uid).set({
          'status': 'online',
        }, SetOptions(merge: true));

        //store uid in local storage
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString("useremail", user.email ?? "");
        sp.setString("useruid", user.uid);
        isLoading.value = false;

        return 'success';
      } else {
        isLoading.value = false;
        return 'Login failed. Please try again.';
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;

      if (e.code == 'user-not-found') {
        isLoading.value = false;

        return 'No user found for this email.';
      } else if (e.code == 'wrong-password') {
        isLoading.value = false;

        return 'Incorrect password.';
      } else if (e.code == 'invalid-email') {
        isLoading.value = false;

        return 'Invalid email address format.';
      } else {
        isLoading.value = false;

        return e.message;
      }
    } catch (e) {
      isLoading.value = false;
      return 'An unexpected error occurred';
    }
  }

  //******************************************  */
  Future<bool> logout() async {
    try {
      isLoading.value = true;
      SharedPreferences sp = await SharedPreferences.getInstance();
      String? userUid = sp.getString('useruid');

      await _firestore.collection('users').doc(userUid).set({
        'status': 'offline',
      }, SetOptions(merge: true));

      sp.remove("useruid");
      sp.remove("useremail");
      await _auth.signOut();
      isLoading.value = false;

      return true;
    } catch (e) {
      isLoading.value = false;

      return false;
    }
  }

  //******************************** */
  updateUserStatus(String userUid, bool isOnline) async {
    String status = isOnline ? "online" : "offline";
    await _firestore.collection('users').doc(userUid).set({
      'status': status,
    }, SetOptions(merge: true));
  }
}
