// To parse this JSON data, do
//
//     final allCountriesResponse = allCountriesResponseFromJson(jsonString);

import 'dart:convert';

List<AllCountriesResponse> allCountriesResponseFromJson(String str) => List<AllCountriesResponse>.from(json.decode(str).map((x) => AllCountriesResponse.fromJson(x)));

String allCountriesResponseToJson(List<AllCountriesResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllCountriesResponse {
  String countryCode;
  String countryName;

  AllCountriesResponse({
    required this.countryCode,
    required this.countryName,
  });

  factory AllCountriesResponse.fromJson(Map<String, dynamic> json) => AllCountriesResponse(
    countryCode: json["countryCode"],
    countryName: json["countryName"],
  );

  Map<String, dynamic> toJson() => {
    "countryCode": countryCode,
    "countryName": countryName,
  };
}
