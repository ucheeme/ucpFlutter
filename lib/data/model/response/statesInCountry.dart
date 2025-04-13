// To parse this JSON data, do
//
//     final allStateResponse = allStateResponseFromJson(jsonString);

import 'dart:convert';

List<AllStateResponse> allStateResponseFromJson(String str) => List<AllStateResponse>.from(json.decode(str).map((x) => AllStateResponse.fromJson(x)));

String allStateResponseToJson(List<AllStateResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllStateResponse {
  String stateCode;
  String stateName;

  AllStateResponse({
    required this.stateCode,
    required this.stateName,
  });

  factory AllStateResponse.fromJson(Map<String, dynamic> json) => AllStateResponse(
    stateCode: json["stateCode"],
    stateName: json["stateName"],
  );

  Map<String, dynamic> toJson() => {
    "stateCode": stateCode,
    "stateName": stateName,
  };
}
