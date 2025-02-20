// To parse this JSON data, do
//
//     final addReduceItemQuantityOnCartRequest = addReduceItemQuantityOnCartRequestFromJson(jsonString);

import 'dart:convert';

AddReduceItemQuantityOnCartRequest addReduceItemQuantityOnCartRequestFromJson(String str) => AddReduceItemQuantityOnCartRequest.fromJson(json.decode(str));

String addReduceItemQuantityOnCartRequestToJson(AddReduceItemQuantityOnCartRequest data) => json.encode(data.toJson());

class AddReduceItemQuantityOnCartRequest {
  int itemCode;
  int quantity;

  AddReduceItemQuantityOnCartRequest({
    required this.itemCode,
    required this.quantity,
  });

  factory AddReduceItemQuantityOnCartRequest.fromJson(Map<String, dynamic> json) => AddReduceItemQuantityOnCartRequest(
    itemCode: json["itemRequestId"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "itemRequestId": itemCode,
    "quantity": quantity,
  };
}
