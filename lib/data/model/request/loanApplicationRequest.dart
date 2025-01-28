// To parse this JSON data, do
//
//     final loanApplicationRequest = loanApplicationRequestFromJson(jsonString);

import 'dart:convert';

LoanApplicationRequest loanApplicationRequestFromJson(String str) => LoanApplicationRequest.fromJson(json.decode(str));

String loanApplicationRequestToJson(LoanApplicationRequest data) => json.encode(data.toJson());

class LoanApplicationRequest {
  String loanProduct;
  dynamic loanAmount;
  String tenor;
  String frequency;
  String narration;
  dynamic netMonthlyPay;
  List<String> gaurators;

  LoanApplicationRequest({
    required this.loanProduct,
    required this.loanAmount,
    required this.tenor,
    required this.frequency,
    required this.narration,
    required this.netMonthlyPay,
    required this.gaurators,
  });

  factory LoanApplicationRequest.fromJson(Map<String, dynamic> json) => LoanApplicationRequest(
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
