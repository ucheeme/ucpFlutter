// To parse this JSON data, do
//
//     final loanProductList = loanProductListFromJson(jsonString);

import 'dart:convert';

List<LoanProductList> loanProductListFromJson(String str) => List<LoanProductList>.from(json.decode(str).map((x) => LoanProductList.fromJson(x)));

String loanProductListToJson(List<LoanProductList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoanProductList {
  String productCode;
  String productName;

  LoanProductList({
    required this.productCode,
    required this.productName,
  });

  factory LoanProductList.fromJson(Map<String, dynamic> json) => LoanProductList(
    productCode: json["productCode"],
    productName: json["productName"],
  );

  Map<String, dynamic> toJson() => {
    "productCode": productCode,
    "productName": productName,
  };
}
