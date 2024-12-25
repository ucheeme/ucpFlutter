// To parse this JSON data, do
//
//     final allPurchasedItems = allPurchasedItemsFromJson(jsonString);

import 'dart:convert';

AllPurchasedItems allPurchasedItemsFromJson(String str) => AllPurchasedItems.fromJson(json.decode(str));

String allPurchasedItemsToJson(AllPurchasedItems data) => json.encode(data.toJson());

class AllPurchasedItems {
  int pageSize;
  int pageNumber;
  int totalCount;
  List<ModelResult> modelResult;

  AllPurchasedItems({
    required this.pageSize,
    required this.pageNumber,
    required this.totalCount,
    required this.modelResult,
  });

  factory AllPurchasedItems.fromJson(Map<String, dynamic> json) => AllPurchasedItems(
    pageSize: json["pageSize"],
    pageNumber: json["pageNumber"],
    totalCount: json["totalCount"],
    modelResult: List<ModelResult>.from(json["modelResult"].map((x) => ModelResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageSize": pageSize,
    "pageNumber": pageNumber,
    "totalCount": totalCount,
    "modelResult": List<dynamic>.from(modelResult.map((x) => x.toJson())),
  };
}

class ModelResult {
  String itemName;
  int quantity;
  int unitPrice;
  DateTime purchasedDate;
  String paymentMode;
  String status;

  ModelResult({
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
    required this.purchasedDate,
    required this.paymentMode,
    required this.status,
  });

  factory ModelResult.fromJson(Map<String, dynamic> json) => ModelResult(
    itemName: json["itemName"],
    quantity: json["quantity"],
    unitPrice: json["unitPrice"],
    purchasedDate: DateTime.parse(json["purchasedDate"]),
    paymentMode: json["paymentMode"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "itemName": itemName,
    "quantity": quantity,
    "unitPrice": unitPrice,
    "purchasedDate": purchasedDate.toIso8601String(),
    "paymentMode": paymentMode,
    "status": status,
  };
}
