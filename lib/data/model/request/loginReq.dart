// To parse this JSON data, do
//
//     final loginRequest = loginRequestFromJson(jsonString);

import 'dart:convert';

LoginRequest loginRequestFromJson(String str) => LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest {
  int nodeId;
  String username;
  String password;

  LoginRequest({
    required this.nodeId,
    required this.username,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
    nodeId: json["nodeId"],
    username: json["username"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "nodeId": nodeId,
    "username": username,
    "password": password,
  };
}
