// To parse this JSON data, do
//
//     final withdrawTransaction = withdrawTransactionFromJson(jsonString);

import 'dart:convert';

WithdrawTransaction withdrawTransactionFromJson(String str) => WithdrawTransaction.fromJson(json.decode(str));

String withdrawTransactionToJson(WithdrawTransaction data) => json.encode(data.toJson());

class WithdrawTransaction {
  int pageSize;
  int pageNumber;
  int totalCount;
  List<WithdrawTransactionHistory> modelResult;

  WithdrawTransaction({
    required this.pageSize,
    required this.pageNumber,
    required this.totalCount,
    required this.modelResult,
  });

  factory WithdrawTransaction.fromJson(Map<String, dynamic> json) => WithdrawTransaction(
    pageSize: json["pageSize"],
    pageNumber: json["pageNumber"],
    totalCount: json["totalCount"],
    modelResult: List<WithdrawTransactionHistory>.from(json["modelResult"].map((x) => WithdrawTransactionHistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageSize": pageSize,
    "pageNumber": pageNumber,
    "totalCount": totalCount,
    "modelResult": List<dynamic>.from(modelResult.map((x) => x.toJson())),
  };
}

class WithdrawTransactionHistory {
  int id;
  String accountName;
  String accountNumber;
  DateTime date;
  dynamic accountBalance;
  String paymentMode;
  dynamic charges;
  String status;

  WithdrawTransactionHistory({
    required this.id,
    required this.accountName,
    required this.accountNumber,
    required this.date,
    required this.accountBalance,
    required this.paymentMode,
    required this.charges,
    required this.status,
  });

  factory WithdrawTransactionHistory.fromJson(Map<String, dynamic> json) => WithdrawTransactionHistory(
    id: json["id"],
    accountName: json["accountName"],
    accountNumber: json["accountNumber"],
    date: DateTime.parse(json["date"]),
    accountBalance: json["accountBalance"],
    paymentMode: json["paymentMode"],
    charges: json["charges"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "accountName": accountName,
    "accountNumber": accountNumber,
    "date": date.toIso8601String(),
    "accountBalance": accountBalance,
    "paymentMode": paymentMode,
    "charges": charges,
    "status": status,
  };
}
