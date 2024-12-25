// To parse this JSON data, do
//
//     final addItemToCartRequest = addItemToCartRequestFromJson(jsonString);

import 'dart:convert';

AddItemToCartRequest addItemToCartRequestFromJson(String str) => AddItemToCartRequest.fromJson(json.decode(str));

String addItemToCartRequestToJson(AddItemToCartRequest data) => json.encode(data.toJson());

class AddItemToCartRequest {
  String itemCode;
  int quantity;
  int transactionOptionId;

  AddItemToCartRequest({
    required this.itemCode,
    required this.quantity,
    required this.transactionOptionId,
  });

  factory AddItemToCartRequest.fromJson(Map<String, dynamic> json) => AddItemToCartRequest(
    itemCode: json["itemCode"],
    quantity: json["quantity"],
    transactionOptionId: json["transactionOptionId"],
  );

  Map<String, dynamic> toJson() => {
    "itemCode": itemCode,
    "quantity": quantity,
    "transactionOptionId": transactionOptionId,
  };
}
