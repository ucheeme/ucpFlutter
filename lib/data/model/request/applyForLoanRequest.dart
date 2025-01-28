// To parse this JSON data, do
//
//     final applyForLoanRequest = applyForLoanRequestFromJson(jsonString);

import 'dart:convert';

ApplyForLoanRequest applyForLoanRequestFromJson(String str) => ApplyForLoanRequest.fromJson(json.decode(str));

String applyForLoanRequestToJson(ApplyForLoanRequest data) => json.encode(data.toJson());

class ApplyForLoanRequest {
  String loanProduct;
  dynamic loanAmount;
  String tenor;
  String frequency;
  String narration;
  int netMonthlyPay;
  List<String> gaurators;

  ApplyForLoanRequest({
    required this.loanProduct,
    required this.loanAmount,
    required this.tenor,
    required this.frequency,
    required this.narration,
    required this.netMonthlyPay,
    required this.gaurators,
  });

  factory ApplyForLoanRequest.fromJson(Map<String, dynamic> json) => ApplyForLoanRequest(
    loanProduct: json["loanProduct"],
    loanAmount: json["loanAmount"],
    tenor: json["tenor"],
    frequency: json["frequency"],
    narration: json["narration"],
    netMonthlyPay: json["netMonthlyPay"],
    gaurators: List<String>.from(json["gaurators"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "loanProduct": loanProduct,
    "loanAmount": loanAmount,
    "tenor": tenor,
    "frequency": frequency,
    "narration": narration,
    "netMonthlyPay": netMonthlyPay,
    "gaurators": List<dynamic>.from(gaurators.map((x) => x)),
  };
}
