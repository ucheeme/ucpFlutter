// To parse this JSON data, do
//
//     final loanProductDetail = loanProductDetailFromJson(jsonString);

import 'dart:convert';

LoanProductDetail loanProductDetailFromJson(String str) => LoanProductDetail.fromJson(json.decode(str));

String loanProductDetailToJson(LoanProductDetail data) => json.encode(data.toJson());

class LoanProductDetail {
  dynamic interestRate;
  String frequency;

  LoanProductDetail({
    required this.interestRate,
    required this.frequency,
  });

  factory LoanProductDetail.fromJson(Map<String, dynamic> json) => LoanProductDetail(
    interestRate: json["interestRate"],
    frequency: json["frequency"],
  );

  Map<String, dynamic> toJson() => {
    "interestRate": interestRate,
    "frequency": frequency,
  };
}
