// To parse this JSON data, do
//
//     final withdrawAccountBalanceInfo = withdrawAccountBalanceInfoFromJson(jsonString);

import 'dart:convert';

WithdrawAccountBalanceInfo withdrawAccountBalanceInfoFromJson(String str) => WithdrawAccountBalanceInfo.fromJson(json.decode(str));

String withdrawAccountBalanceInfoToJson(WithdrawAccountBalanceInfo data) => json.encode(data.toJson());

class WithdrawAccountBalanceInfo {
  dynamic accountBalance;
  double loanInterest;
  double retirementAmt;
  double loanPrinicpal;

  WithdrawAccountBalanceInfo({
    required this.accountBalance,
    required this.loanInterest,
    required this.retirementAmt,
    required this.loanPrinicpal,
  });

  factory WithdrawAccountBalanceInfo.fromJson(Map<String, dynamic> json) => WithdrawAccountBalanceInfo(
    accountBalance: json["accountBalance"],
    loanInterest: json["loanInterest"]?.toDouble(),
    retirementAmt: json["retirementAmt"]?.toDouble(),
    loanPrinicpal: json["loanPrinicpal"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "accountBalance": accountBalance,
    "loanInterest": loanInterest,
    "retirementAmt": retirementAmt,
    "loanPrinicpal": loanPrinicpal,
  };
}
