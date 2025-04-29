import 'dart:developer';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController extends GetxController {
  var isLoading = false.obs;

  Future<void> sendMessage({
    required String senderUid,
    required String receiverUid,
    required String senderEmail,
    required String receiverEmail,
    required String message,
  }) async {
    isLoading.value = true;
    final chatDocId = generateChatDocId(senderUid, receiverUid);
    final chatRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatDocId);

    final newMessage = {
      'senderuid': senderUid,
      'receiveruid': receiverUid,
      'message': message,
      'timestamp': Timestamp.now(),
    };

    final usersMap = {
      'senderuid': senderUid,
      'receiveruid': receiverUid,
      'senderemail': senderEmail,
      'receiveremail': receiverEmail,
    };

    try {
      final doc = await chatRef.get();

      if (doc.exists) {
        // Update existing document
        await chatRef.update({
          'conversations': FieldValue.arrayUnion([newMessage]),
          'lastupdated': Timestamp.now(),
        });
        isLoading.value = false;
      } else {
        // Create new document
        await chatRef.set({
          'users': usersMap,
          'conversations': [newMessage],
          'lastupdated': Timestamp.now(),
        });
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;

      log('Failed to send message: $e');
    }
  }

  String generateChatDocId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }
}
