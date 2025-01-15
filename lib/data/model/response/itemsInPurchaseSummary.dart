// To parse this JSON data, do
//
//     final itemsInPurchasedSummary = itemsInPurchasedSummaryFromJson(jsonString);

import 'dart:convert';

ItemsInPurchasedSummary itemsInPurchasedSummaryFromJson(String str) => ItemsInPurchasedSummary.fromJson(json.decode(str));

String itemsInPurchasedSummaryToJson(ItemsInPurchasedSummary data) => json.encode(data.toJson());

class ItemsInPurchasedSummary {
  int pageSize;
  int pageNumber;
  int totalCount;
  List<ItemInSummary> modelResult;

  ItemsInPurchasedSummary({
    required this.pageSize,
    required this.pageNumber,
    required this.totalCount,
    required this.modelResult,
  });

  factory ItemsInPurchasedSummary.fromJson(Map<String, dynamic> json) => ItemsInPurchasedSummary(
    pageSize: json["pageSize"],
    pageNumber: json["pageNumber"],
    totalCount: json["totalCount"],
    modelResult: List<ItemInSummary>.from(json["modelResult"].map((x) => ItemInSummary.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageSize": pageSize,
    "pageNumber": pageNumber,
    "totalCount": totalCount,
    "modelResult": List<dynamic>.from(modelResult.map((x) => x.toJson())),
  };
}

class ItemInSummary {
  String itemName;
  int quantity;
  dynamic unitPrice;
  DateTime purchasedDate;
  dynamic paymentMode;
  String status;

  ItemInSummary({
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
    required this.purchasedDate,
    required this.paymentMode,
    required this.status,
  });

  factory ItemInSummary.fromJson(Map<String, dynamic> json) => ItemInSummary(
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
