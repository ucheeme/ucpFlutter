// To parse this JSON data, do
//
//     final purxhasedItemSummaryReport = purxhasedItemSummaryReportFromJson(jsonString);

import 'dart:convert';

PurxhasedItemSummaryReport purxhasedItemSummaryReportFromJson(String str) => PurxhasedItemSummaryReport.fromJson(json.decode(str));

String purxhasedItemSummaryReportToJson(PurxhasedItemSummaryReport data) => json.encode(data.toJson());

class PurxhasedItemSummaryReport {
  int pageSize;
  int pageNumber;
  int totalCount;
  List<PurchasedSummary> modelResult;

  PurxhasedItemSummaryReport({
    required this.pageSize,
    required this.pageNumber,
    required this.totalCount,
    required this.modelResult,
  });

  factory PurxhasedItemSummaryReport.fromJson(Map<String, dynamic> json) => PurxhasedItemSummaryReport(
    pageSize: json["pageSize"],
    pageNumber: json["pageNumber"],
    totalCount: json["totalCount"],
    modelResult: List<PurchasedSummary>.from(json["modelResult"].map((x) => PurchasedSummary.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageSize": pageSize,
    "pageNumber": pageNumber,
    "totalCount": totalCount,
    "modelResult": List<dynamic>.from(modelResult.map((x) => x.toJson())),
  };
}

class PurchasedSummary {
  String orderId;
  int itemCount;
  int quantity;
  dynamic totalPrice;
  DateTime purchasedDate;
  Status status;

  PurchasedSummary({
    required this.orderId,
    required this.itemCount,
    required this.quantity,
    required this.totalPrice,
    required this.purchasedDate,
    required this.status,
  });

  factory PurchasedSummary.fromJson(Map<String, dynamic> json) => PurchasedSummary(
    orderId: json["orderId"],
    itemCount: json["itemCount"],
    quantity: json["quantity"],
    totalPrice: json["totalPrice"],
    purchasedDate: DateTime.parse(json["purchasedDate"]),
    status: statusValues.map[json["status"]]!,
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "itemCount": itemCount,
    "quantity": quantity,
    "totalPrice": totalPrice,
    "purchasedDate": purchasedDate.toIso8601String(),
    "status": statusValues.reverse[status],
  };
}

enum Status {
  APPROVED,
  PAID,
  PENDING
}

final statusValues = EnumValues({
  "Approved": Status.APPROVED,
  "Paid": Status.PAID,
  "Pending": Status.PENDING
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
