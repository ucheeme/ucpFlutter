// To parse this JSON data, do
//
//     final addBankDetailRequest = addBankDetailRequestFromJson(jsonString);

import 'dart:convert';

AddBankDetailRequest addBankDetailRequestFromJson(String str) => AddBankDetailRequest.fromJson(json.decode(str));

String addBankDetailRequestToJson(AddBankDetailRequest data) => json.encode(data.toJson());

class AddBankDetailRequest {
  String bank;
  String bankAccountNumber;
  String bankAccountName;
  String bankAddress;

  AddBankDetailRequest({
    required this.bank,
    required this.bankAccountNumber,
    required this.bankAccountName,
    required this.bankAddress,
  });

  factory AddBankDetailRequest.fromJson(Map<String, dynamic> json) => AddBankDetailRequest(
    bank: json["bank"],
    bankAccountNumber: json["bankAccountNumber"],
    bankAccountName: json["bankAccountName"],
    bankAddress: json["bankAddress"],
  );

  Map<String, dynamic> toJson() => {
    "bank": bank,
    "bankAccountNumber": bankAccountNumber,
    "bankAccountName": bankAccountName,
    "bankAddress": bankAddress,
  };
}
