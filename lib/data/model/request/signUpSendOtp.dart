// To parse this JSON data, do
//
//     final signupOtp = signupOtpFromJson(jsonString);

import 'dart:convert';

SignupOtpRequest signupOtpFromJson(String str) => SignupOtpRequest.fromJson(json.decode(str));

String signupOtpToJson(SignupOtpRequest data) => json.encode(data.toJson());

class SignupOtpRequest {
  int cooperativeId;
  String emailAddress;
  String username;
  String fullName;

  SignupOtpRequest({
    required this.cooperativeId,
    required this.emailAddress,
    required this.username,
    required this.fullName,
  });

  factory SignupOtpRequest.fromJson(Map<String, dynamic> json) => SignupOtpRequest(
    cooperativeId: json["cooperativeId"],
    emailAddress: json["emailAddress"],
    username: json["username"],
    fullName: json["fullName"],
  );

  Map<String, dynamic> toJson() => {
    "cooperativeId": cooperativeId,
    "emailAddress": emailAddress,
    "username": username,
    "fullName": fullName,
  };
}
