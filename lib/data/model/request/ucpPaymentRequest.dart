// To parse this JSON data, do
//
//     final ucpMakePaymentRequest = ucpMakePaymentRequestFromJson(jsonString);

import 'dart:convert';

UcpMakePaymentRequest ucpMakePaymentRequestFromJson(String str) => UcpMakePaymentRequest.fromJson(json.decode(str));

String ucpMakePaymentRequestToJson(UcpMakePaymentRequest data) => json.encode(data.toJson());

class UcpMakePaymentRequest {
  int modeOfPayment;
  String accountNumber;
  int amount;
  String paidDate;
  String bankTeller;
  String bankAccountNumber;
  String bank;
  String description;

  UcpMakePaymentRequest({
    required this.modeOfPayment,
    required this.accountNumber,
    required this.amount,
    required this.paidDate,
    required this.bankTeller,
    required this.bankAccountNumber,
    required this.bank,
    required this.description,
  });

  factory UcpMakePaymentRequest.fromJson(Map<String, dynamic> json) => UcpMakePaymentRequest(
    modeOfPayment: json["ModeOfPayment"],
    accountNumber: json["AccountNumber"],
    amount: json["Amount"],
    paidDate: json["PaidDate"],
    bankTeller: json["BankTeller"],
    bankAccountNumber: json["BankAccountNumber"],
    bank: json["Bank"],
    description: json["Description"],
  );

  Map<String, dynamic> toJson() => {
    "ModeOfPayment": modeOfPayment,
    "AccountNumber": accountNumber,
    "Amount": amount,
    "PaidDate": paidDate,
    "BankTeller": bankTeller,
    "BankAccountNumber": bankAccountNumber,
    "Bank": bank,
    "Description": description,
  };
}
