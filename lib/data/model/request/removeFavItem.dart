// To parse this JSON data, do
//
//     final removeItemAsFavRequest = removeItemAsFavRequestFromJson(jsonString);

import 'dart:convert';

RemoveItemAsFavRequest removeItemAsFavRequestFromJson(String str) => RemoveItemAsFavRequest.fromJson(json.decode(str));

String removeItemAsFavRequestToJson(RemoveItemAsFavRequest data) => json.encode(data.toJson());

class RemoveItemAsFavRequest {
  String id;

  RemoveItemAsFavRequest({
    required this.id,
  });

  factory RemoveItemAsFavRequest.fromJson(Map<String, dynamic> json) => RemoveItemAsFavRequest(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}
