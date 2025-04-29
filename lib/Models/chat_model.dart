import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  List<Message> messages;
  Users users;
  Timestamp lastupdated;

  ChatModel({
    required this.messages,
    required this.users,
    required this.lastupdated,
  });

  factory ChatModel.fromJson(Map<dynamic, dynamic> json) => ChatModel(
    lastupdated: json["lastupdated"] ?? Timestamp.now(),
    messages: List<Message>.from(
      json["conversations"].map((x) => Message.fromJson(x)),
    ),
    users: Users.fromJson(json["users"]),
  );

  Map<String, dynamic> toJson() => {
    "lastupdated": Timestamp.now(),
    "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
    "users": users.toJson(),
  };
}

class Message {
  Timestamp timestamp;
  String senderuid;
  String recieveruid;
  String message;

  Message({
    required this.senderuid,
    required this.recieveruid,
    required this.message,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    senderuid: json["senderuid"],
    recieveruid: json["receiveruid"],
    timestamp: json["timestamp"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "senderuid": senderuid,
    "receiveruid": recieveruid,
    "message": message,
    "timestamp": timestamp,
  };
}

class Users {
  String recievermail;
  String recieveruid;
  String senderuid;
  String sendermail;

  Users({
    required this.recievermail,
    required this.recieveruid,
    required this.sendermail,
    required this.senderuid,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    recievermail: json["receivermail"] ?? "",
    recieveruid: json["receiveruid"] ?? "",
    sendermail: json["sendermail"] ?? "",
    senderuid: json["senderuid"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "receivermail": recievermail,
    "receiveruid": recieveruid,
    "sendermail": sendermail,
    "senderuid": senderuid,
  };
}
