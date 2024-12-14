// To parse this JSON data, do
//
//     final dashboardResponse = dashboardResponseFromJson(jsonString);

import 'dart:convert';

DashboardResponse dashboardResponseFromJson(String str) => DashboardResponse.fromJson(json.decode(str));

String dashboardResponseToJson(DashboardResponse data) => json.encode(data.toJson());

class DashboardResponse {
  dynamic totalContribution;
  dynamic monthlyContribution;
  dynamic loanBalance;
  dynamic shopInventory;
  dynamic totalProduct;
  String byeLaw;
  List<Account> accounts;

  DashboardResponse({
    required this.totalContribution,
    required this.monthlyContribution,
    required this.loanBalance,
    required this.shopInventory,
    required this.totalProduct,
    required this.byeLaw,
    required this.accounts,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) => DashboardResponse(
    totalContribution: json["totalContribution"],
    monthlyContribution: json["monthlyContribution"],
    loanBalance: json["loanBalance"],
    shopInventory: json["shopInventory"],
    totalProduct: json["totalProduct"],
    byeLaw: json["byeLaw"],
    accounts: List<Account>.from(json["accounts"].map((x) => Account.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalContribution": totalContribution,
    "monthlyContribution": monthlyContribution,
    "loanBalance": loanBalance,
    "shopInventory": shopInventory,
    "totalProduct": totalProduct,
    "byeLaw": byeLaw,
    "accounts": List<dynamic>.from(accounts.map((x) => x.toJson())),
  };
}

class Account {
  String acctProduct;
  double bookbalance;

  Account({
    required this.acctProduct,
    required this.bookbalance,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    acctProduct: json["acctProduct"],
    bookbalance: json["bookbalance"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "acctProduct": acctProduct,
    "bookbalance": bookbalance,
  };
}
