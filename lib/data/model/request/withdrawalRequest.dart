// To parse this JSON data, do
//
//     final withdrawalRequest = withdrawalRequestFromJson(jsonString);

import 'dart:convert';

WithdrawalRequest withdrawalRequestFromJson(String str) => WithdrawalRequest.fromJson(json.decode(str));

String withdrawalRequestToJson(WithdrawalRequest data) => json.encode(data.toJson());

class WithdrawalRequest {
  String productAccountNumber;
  double amount;
  int modeOfPayment;

  WithdrawalRequest({
    required this.productAccountNumber,
    required this.amount,
    required this.modeOfPayment,
  });

  factory WithdrawalRequest.fromJson(Map<String, dynamic> json) => WithdrawalRequest(
    productAccountNumber: json["productAccountNumber"],
    amount: json["amount"],
    modeOfPayment: json["modeOfPayment"],
  );

  Map<String, dynamic> toJson() => {
    "productAccountNumber": productAccountNumber,
    "amount": amount,
    "modeOfPayment": modeOfPayment,
  };
}
