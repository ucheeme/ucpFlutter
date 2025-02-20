// To parse this JSON data, do
//
//     final ucpDefaultResponse = ucpDefaultResponseFromJson(jsonString);

import 'dart:convert';

PositionApplied ucpDefaultResponseFromJson(String str) => PositionApplied.fromJson(json.decode(str));

String ucpDefaultResponseToJson(PositionApplied data) => json.encode(data.toJson());

class PositionApplied {
  bool isSuccessful;
  String message;
  List<String> errors;
  int statusCode;
  dynamic data;

  PositionApplied({
    required this.isSuccessful,
    required this.message,
    required this.errors,
    required this.statusCode,
    required this.data,
  });

  factory PositionApplied.fromJson(Map<String, dynamic> json) => PositionApplied(
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

