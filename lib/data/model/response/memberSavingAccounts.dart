// To parse this JSON data, do
//
//     final memberSavingAccounts = memberSavingAccountsFromJson(jsonString);

import 'dart:convert';

List<MemberSavingAccounts> memberSavingAccountsFromJson(String str) => List<MemberSavingAccounts>.from(json.decode(str).map((x) => MemberSavingAccounts.fromJson(x)));

String memberSavingAccountsToJson(List<MemberSavingAccounts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MemberSavingAccounts {
  String accountNumber;
  String accountProduct;
  dynamic accountBalance;

  MemberSavingAccounts({
    required this.accountNumber,
    required this.accountProduct,
    required this.accountBalance,
  });

  factory MemberSavingAccounts.fromJson(Map<String, dynamic> json) => MemberSavingAccounts(
    accountNumber: json["accountNumber"],
    accountProduct: json["accountProduct"],
    accountBalance: json["accountBalance"],
  );

  Map<String, dynamic> toJson() => {
    "accountNumber": accountNumber,
    "accountProduct": accountProduct,
    "accountBalance": accountBalance,
  };
}
