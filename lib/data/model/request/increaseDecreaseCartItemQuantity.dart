// To parse this JSON data, do
//
//     final addReduceItemQuantityOnCartRequest = addReduceItemQuantityOnCartRequestFromJson(jsonString);

import 'dart:convert';

AddReduceItemQuantityOnCartRequest addReduceItemQuantityOnCartRequestFromJson(String str) => AddReduceItemQuantityOnCartRequest.fromJson(json.decode(str));

String addReduceItemQuantityOnCartRequestToJson(AddReduceItemQuantityOnCartRequest data) => json.encode(data.toJson());

class AddReduceItemQuantityOnCartRequest {
  String itemCode;
  int quantity;

  AddReduceItemQuantityOnCartRequest({
    required this.itemCode,
    required this.quantity,
  });

  factory AddReduceItemQuantityOnCartRequest.fromJson(Map<String, dynamic> json) => AddReduceItemQuantityOnCartRequest(
    itemCode: json["itemCode"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "itemCode": itemCode,
    "quantity": quantity,
  };
}
