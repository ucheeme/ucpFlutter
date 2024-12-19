// To parse this JSON data, do
//
//     final listOfBank = listOfBankFromJson(jsonString);

import 'dart:convert';

List<ListOfBank> listOfBankFromJson(String str) => List<ListOfBank>.from(json.decode(str).map((x) => ListOfBank.fromJson(x)));

String listOfBankToJson(List<ListOfBank> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ListOfBank {
  String bankCode;
  String bankName;

  ListOfBank({
    required this.bankCode,
    required this.bankName,
  });

  factory ListOfBank.fromJson(Map<String, dynamic> json) => ListOfBank(
    bankCode: json["bankCode"],
    bankName: json["bankName"],
  );

  Map<String, dynamic> toJson() => {
    "bankCode": bankCode,
    "bankName": bankName,
  };
}
