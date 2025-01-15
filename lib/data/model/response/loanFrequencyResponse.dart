// To parse this JSON data, do
//
//     final loanFrequencyList = loanFrequencyListFromJson(jsonString);

import 'dart:convert';

List<LoanFrequencyList> loanFrequencyListFromJson(String str) => List<LoanFrequencyList>.from(json.decode(str).map((x) => LoanFrequencyList.fromJson(x)));

String loanFrequencyListToJson(List<LoanFrequencyList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoanFrequencyList {
  String freqCode;
  String freqName;

  LoanFrequencyList({
    required this.freqCode,
    required this.freqName,
  });

  factory LoanFrequencyList.fromJson(Map<String, dynamic> json) => LoanFrequencyList(
    freqCode: json["freqCode"],
    freqName: json["freqName"],
  );

  Map<String, dynamic> toJson() => {
    "freqCode": freqCode,
    "freqName": freqName,
  };
}
