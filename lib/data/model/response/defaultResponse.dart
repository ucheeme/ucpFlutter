// To parse this JSON data, do
//
//     final ucpDefaultResponse = ucpDefaultResponseFromJson(jsonString);

import 'dart:convert';

UcpDefaultResponse ucpDefaultResponseFromJson(String str) => UcpDefaultResponse.fromJson(json.decode(str));

String ucpDefaultResponseToJson(UcpDefaultResponse data) => json.encode(data.toJson());

class UcpDefaultResponse {
  bool isSuccessful;
  String message;
  List<String> errors;
  int statusCode;
  dynamic data;

  UcpDefaultResponse({
    required this.isSuccessful,
    required this.message,
    required this.errors,
    required this.statusCode,
    required this.data,
  });

  factory UcpDefaultResponse.fromJson(Map<String, dynamic> json) => UcpDefaultResponse(
    isSuccessful: json["isSuccessful"],
    message: json["message"],
    errors: List<String>.from(json["errors"].map((x) => x)),
    statusCode: json["statusCode"],
    data:json["data"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccessful": isSuccessful,
    "message": message,
    "errors": List<dynamic>.from(errors.map((x) => x)),
    "statusCode": statusCode,
    "data": data,
  };
}

