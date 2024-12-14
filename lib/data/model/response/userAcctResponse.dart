// To parse this JSON data, do
//
//     final userAccounts = userAccountsFromJson(jsonString);

import 'dart:convert';

List<UserAccounts> userAccountsFromJson(String str) => List<UserAccounts>.from(json.decode(str).map((x) => UserAccounts.fromJson(x)));

String userAccountsToJson(List<UserAccounts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserAccounts {
  String accountNumber;
  String accountProduct;

  UserAccounts({
    required this.accountNumber,
    required this.accountProduct,
  });

  factory UserAccounts.fromJson(Map<String, dynamic> json) => UserAccounts(
    accountNumber: json["accountNumber"],
    accountProduct: json["accountProduct"],
  );

  Map<String, dynamic> toJson() => {
    "accountNumber": accountNumber,
    "accountProduct": accountProduct,
  };
}
