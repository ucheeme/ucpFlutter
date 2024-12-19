// To parse this JSON data, do
//
//     final loginSendOtp = loginSendOtpFromJson(jsonString);

import 'dart:convert';

LoginSendOtpRequest loginSendOtpFromJson(String str) => LoginSendOtpRequest.fromJson(json.decode(str));

String loginSendOtpToJson(LoginSendOtpRequest data) => json.encode(data.toJson());

class LoginSendOtpRequest {
  int cooperativeId;
  String username;

  LoginSendOtpRequest({
    required this.cooperativeId,
    required this.username,
  });

  factory LoginSendOtpRequest.fromJson(Map<String, dynamic> json) => LoginSendOtpRequest(
    cooperativeId: json["cooperativeId"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "cooperativeId": cooperativeId,
    "username": username,
  };
}
