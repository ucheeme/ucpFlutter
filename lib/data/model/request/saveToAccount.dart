// To parse this JSON data, do
//
//     final saveToAccountRequest = saveToAccountRequestFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

SaveToAccountRequest saveToAccountRequestFromJson(String str) => SaveToAccountRequest.fromJson(json.decode(str));

String saveToAccountRequestToJson(SaveToAccountRequest data) => json.encode(data.toJson());

class SaveToAccountRequest {
  String amount;
  String modeOfpayment;
  String description;
  String accountNumber;
  String bank;
  String bankAccountNumber;
  String bankTeller;
  String paidDate;
  File? uploadTeller;

  SaveToAccountRequest({
    required this.amount,
    required this.modeOfpayment,
    required this.description,
    required this.accountNumber,
    required this.bank,
    required this.bankAccountNumber,
    required this.bankTeller,
    required this.paidDate,
    required this.uploadTeller,
  });

  factory SaveToAccountRequest.fromJson(Map<String, dynamic> json) => SaveToAccountRequest(
    amount: json["amount"],
    modeOfpayment: json["modeOfpayment"],
    description: json["description"],
    accountNumber: json["accountNumber"],
    bank: json["bank"],
    bankAccountNumber: json["bankAccountNumber"],
    bankTeller: json["bankTeller"],
    paidDate: json["paidDate"],
    uploadTeller: json["uploadTeller"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "modeOfpayment": modeOfpayment,
    "description": description,
    "accountNumber": accountNumber,
    "bank": bank,
    "bankAccountNumber": bankAccountNumber,
    "bankTeller": bankTeller,
    "paidDate": paidDate,
    "uploadTeller": uploadTeller?.path,
  };
}
