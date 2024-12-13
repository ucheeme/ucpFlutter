// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  MemberLoginDetails memberLoginDetails;
  dynamic referralcode;
  String token;
  String refreshToken;
  dynamic responseCode;
  DateTime refreshTokenExpiration;
  dynamic message;

  LoginResponse({
    required this.memberLoginDetails,
    required this.referralcode,
    required this.token,
    required this.refreshToken,
    required this.responseCode,
    required this.refreshTokenExpiration,
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    memberLoginDetails: MemberLoginDetails.fromJson(json["memberLoginDetails"]),
    referralcode: json["referralcode"],
    token: json["token"],
    refreshToken: json["refreshToken"],
    responseCode: json["responseCode"],
    refreshTokenExpiration: DateTime.parse(json["refreshTokenExpiration"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "memberLoginDetails": memberLoginDetails.toJson(),
    "referralcode": referralcode,
    "token": token,
    "refreshToken": refreshToken,
    "responseCode": responseCode,
    "refreshTokenExpiration": refreshTokenExpiration.toIso8601String(),
    "message": message,
  };
}

class MemberLoginDetails {
  String email;
  String employeeName;
  String username;
  String employeeId;
  String customerId;
  int enforcepassword;
  String nodeId;
  String phone;
  dynamic redirectUrl;
  int memberUniqueId;

  MemberLoginDetails({
    required this.email,
    required this.employeeName,
    required this.username,
    required this.employeeId,
    required this.customerId,
    required this.enforcepassword,
    required this.nodeId,
    required this.phone,
    required this.redirectUrl,
    required this.memberUniqueId,
  });

  factory MemberLoginDetails.fromJson(Map<String, dynamic> json) => MemberLoginDetails(
    email: json["email"],
    employeeName: json["employeeName"],
    username: json["username"],
    employeeId: json["employeeId"],
    customerId: json["customerId"],
    enforcepassword: json["enforcepassword"],
    nodeId: json["nodeId"],
    phone: json["phone"],
    redirectUrl: json["redirectUrl"],
    memberUniqueId: json["memberUniqueId"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "employeeName": employeeName,
    "username": username,
    "employeeId": employeeId,
    "customerId": customerId,
    "enforcepassword": enforcepassword,
    "nodeId": nodeId,
    "phone": phone,
    "redirectUrl": redirectUrl,
    "memberUniqueId": memberUniqueId,
  };
}
