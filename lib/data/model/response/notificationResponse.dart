// To parse this JSON data, do
//
//     final ucpNotification = ucpNotificationFromJson(jsonString);

import 'dart:convert';

List<UcpNotification> ucpNotificationFromJson(String str) => List<UcpNotification>.from(json.decode(str).map((x) => UcpNotification.fromJson(x)));

String ucpNotificationToJson(List<UcpNotification> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UcpNotification {
  String id;
  String entityId;
  String message;
  String category;
  bool isRead;
  DateTime createdOn;

  UcpNotification({
    required this.id,
    required this.entityId,
    required this.message,
    required this.category,
    required this.isRead,
    required this.createdOn,
  });

  factory UcpNotification.fromJson(Map<String, dynamic> json) => UcpNotification(
    id: json["id"],
    entityId: json["entityId"],
    message: json["message"],
    category: json["category"],
    isRead: json["isRead"],
    createdOn: DateTime.parse(json["createdOn"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "entityId": entityId,
    "message": message,
    "category": category,
    "isRead": isRead,
    "createdOn": createdOn.toIso8601String(),
  };
}
