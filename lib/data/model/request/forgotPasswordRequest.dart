// To parse this JSON data, do
//
//     final forgotPasswordRequest = forgotPasswordRequestFromJson(jsonString);

import 'dart:convert';

ForgotPasswordRequest forgotPasswordRequestFromJson(String str) => ForgotPasswordRequest.fromJson(json.decode(str));

String forgotPasswordRequestToJson(ForgotPasswordRequest data) => json.encode(data.toJson());

class ForgotPasswordRequest {
  String email;
  String username;
  int cooperativeId;

  ForgotPasswordRequest({
    required this.email,
    required this.username,
    required this.cooperativeId,
  });

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) => ForgotPasswordRequest(
    email: json["email"],
    username: json["username"],
    cooperativeId: json["cooperativeId"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "username": username,
    "cooperativeId": cooperativeId,
  };
}
