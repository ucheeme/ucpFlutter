// To parse this JSON data, do
//
//     final buyItemsOnCartRequest = buyItemsOnCartRequestFromJson(jsonString);

import 'dart:convert';

BuyItemsOnCartRequest buyItemsOnCartRequestFromJson(String str) => BuyItemsOnCartRequest.fromJson(json.decode(str));

String buyItemsOnCartRequestToJson(BuyItemsOnCartRequest data) => json.encode(data.toJson());

class BuyItemsOnCartRequest {
  int transactionOptionId;
  int totalAmount;

  BuyItemsOnCartRequest({
    required this.transactionOptionId,
    required this.totalAmount,
  });

  factory BuyItemsOnCartRequest.fromJson(Map<String, dynamic> json) => BuyItemsOnCartRequest(
    transactionOptionId: json["transactionOptionId"],
    totalAmount: json["totalAmount"],
  );

  Map<String, dynamic> toJson() => {
    "transactionOptionId": transactionOptionId,
    "totalAmount": totalAmount,
  };
}
