// To parse this JSON data, do
//
//     final paymentSuccessfulResponse = paymentSuccessfulResponseFromJson(jsonString);

import 'dart:convert';

PaymentSuccessfulResponse paymentSuccessfulResponseFromJson(String str) => PaymentSuccessfulResponse.fromJson(json.decode(str));

String paymentSuccessfulResponseToJson(PaymentSuccessfulResponse data) => json.encode(data.toJson());

class PaymentSuccessfulResponse {
  PayStackResponse? payStackResponse;
  String message;

  PaymentSuccessfulResponse({
     this.payStackResponse,
    required this.message,
  });

  factory PaymentSuccessfulResponse.fromJson(Map<String, dynamic> json) => PaymentSuccessfulResponse(
    payStackResponse: json["payStackResponse"]==null?null:PayStackResponse.fromJson(json["payStackResponse"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "payStackResponse": payStackResponse?.toJson(),
    "message": message,
  };
}

class PayStackResponse {
  String authorizationUrl;
  String accessCode;
  String reference;

  PayStackResponse({
    required this.authorizationUrl,
    required this.accessCode,
    required this.reference,
  });

  factory PayStackResponse.fromJson(Map<String, dynamic> json) => PayStackResponse(
    authorizationUrl: json["authorization_url"],
    accessCode: json["access_code"],
    reference: json["reference"],
  );

  Map<String, dynamic> toJson() => {
    "authorization_url": authorizationUrl,
    "access_code": accessCode,
    "reference": reference,
  };
}
