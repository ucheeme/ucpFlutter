// To parse this JSON data, do
//
//     final markAsFavoriteRequest = markAsFavoriteRequestFromJson(jsonString);

import 'dart:convert';

MarkAsFavoriteRequest markAsFavoriteRequestFromJson(String str) => MarkAsFavoriteRequest.fromJson(json.decode(str));

String markAsFavoriteRequestToJson(MarkAsFavoriteRequest data) => json.encode(data.toJson());

class MarkAsFavoriteRequest {
  String itemCode;

  MarkAsFavoriteRequest({
    required this.itemCode,
  });

  factory MarkAsFavoriteRequest.fromJson(Map<String, dynamic> json) => MarkAsFavoriteRequest(
    itemCode: json["itemCode"],
  );

  Map<String, dynamic> toJson() => {
    "itemCode": itemCode,
  };
}
