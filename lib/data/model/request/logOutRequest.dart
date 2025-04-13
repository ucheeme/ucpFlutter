// To parse this JSON data, do
//
//     final logOutRequest = logOutRequestFromJson(jsonString);

import 'dart:convert';

LogOutRequest logOutRequestFromJson(String str) => LogOutRequest.fromJson(json.decode(str));

String logOutRequestToJson(LogOutRequest data) => json.encode(data.toJson());

class LogOutRequest {
  String refreshToken;
  String deviceId;

  LogOutRequest({
    required this.refreshToken,
    required this.deviceId,
  });

  factory LogOutRequest.fromJson(Map<String, dynamic> json) => LogOutRequest(
    refreshToken: json["refreshToken"],
    deviceId: json["deviceId"],
  );

  Map<String, dynamic> toJson() => {
    "refreshToken": refreshToken,
    "deviceId": deviceId,
  };
}
