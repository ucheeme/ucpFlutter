// To parse this JSON data, do
//
//     final saveToAccountRequest = saveToAccountRequestFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

PaymentRequest paymentRequestFromJson(String str) => PaymentRequest.fromJson(json.decode(str));

String paymentRequestsToJson(PaymentRequest data) => json.encode(data.toJson());

class PaymentRequest {
  String amount;
  String modeOfpayment;
  String description;
  String? accountNumber;
  String? bank;
  String? bankAccountNumber;
  String? bankTeller;
  String? paidDate;
  String? contributionAcctNumber;
  // File? uploadTeller;

  PaymentRequest({
    required this.amount,
    required this.modeOfpayment,
    required this.description,
     this.accountNumber,
     this.bank,
     this.bankAccountNumber,
     this.bankTeller,
     this.paidDate,
    this.contributionAcctNumber,
    // required this.uploadTeller,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) => PaymentRequest(
    amount: json["amount"],
    modeOfpayment: json["modeOfpayment"],
    description: json["description"],
    accountNumber: json["accountNumber"],
    bank: json["bank"],
    bankAccountNumber: json["bankAccountNumber"],
    bankTeller: json["bankTeller"],
    paidDate: json["paidDate"],
    contributionAcctNumber: json["contributionAccountNumber"],
    // uploadTeller: json["uploadTeller"],
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
    "contributionAccountNumber": contributionAcctNumber,
    // "uploadTeller": uploadTeller?.path,
  };
}
