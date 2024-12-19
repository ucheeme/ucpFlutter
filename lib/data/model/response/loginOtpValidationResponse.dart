// To parse this JSON data, do
//
//     final loginOtpValidationResponse = loginOtpValidationResponseFromJson(jsonString);

import 'dart:convert';

OTPValidationResponse loginOtpValidationResponseFromJson(String str) => OTPValidationResponse.fromJson(json.decode(str));

String loginOtpValidationResponseToJson(OTPValidationResponse data) => json.encode(data.toJson());

class OTPValidationResponse {
  String otp;

  OTPValidationResponse({
    required this.otp,
  });

  factory OTPValidationResponse.fromJson(Map<String, dynamic> json) => OTPValidationResponse(
    otp: json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "otp": otp,
  };
}
