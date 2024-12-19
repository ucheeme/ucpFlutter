// To parse this JSON data, do
//
//     final userSavingAccounts = userSavingAccountsFromJson(jsonString);

import 'dart:convert';

List<UserSavingAccounts> userSavingAccountsFromJson(String str) => List<UserSavingAccounts>.from(json.decode(str).map((x) => UserSavingAccounts.fromJson(x)));

String userSavingAccountsToJson(List<UserSavingAccounts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserSavingAccounts {
  String accountNumber;
  String accountProduct;

  UserSavingAccounts({
    required this.accountNumber,
    required this.accountProduct,
  });

  factory UserSavingAccounts.fromJson(Map<String, dynamic> json) => UserSavingAccounts(
    accountNumber: json["accountNumber"],
    accountProduct: json["accountProduct"],
  );

  Map<String, dynamic> toJson() => {
    "accountNumber": accountNumber,
    "accountProduct": accountProduct,
  };
}
