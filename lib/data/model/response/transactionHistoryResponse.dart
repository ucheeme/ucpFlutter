// To parse this JSON data, do
//
//     final transactionResponse = transactionResponseFromJson(jsonString);

import 'dart:convert';

TransactionResponse transactionResponseFromJson(String str) => TransactionResponse.fromJson(json.decode(str));

String transactionResponseToJson(TransactionResponse data) => json.encode(data.toJson());

class TransactionResponse {
  int pageSize;
  int pageNumber;
  int totalCount;
  List<UserTransaction> transactionList;

  TransactionResponse({
    required this.pageSize,
    required this.pageNumber,
    required this.totalCount,
    required this.transactionList,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) => TransactionResponse(
    pageSize: json["pageSize"],
    pageNumber: json["pageNumber"],
    totalCount: json["totalCount"],
    transactionList: List<UserTransaction>.from(json["modelResult"].map((x) => UserTransaction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageSize": pageSize,
    "pageNumber": pageNumber,
    "totalCount": totalCount,
    "modelResult": List<dynamic>.from(transactionList.map((x) => x.toJson())),
  };
}

class UserTransaction {
  DateTime? trandate;
  String narration;
  dynamic debit;
  dynamic credit;
  dynamic bkBalance;

  UserTransaction({
    required this.trandate,
    required this.narration,
    required this.debit,
    required this.credit,
    required this.bkBalance,
  });

  factory UserTransaction.fromJson(Map<String, dynamic> json) => UserTransaction(
    trandate:json["trandate"]==null?null: DateTime.parse(json["trandate"]),
    narration: json["narration"],
    debit: json["debit"],
    credit: json["credit"],
    bkBalance: json["bkBalance"],
  );

  Map<String, dynamic> toJson() => {
    "trandate": trandate?.toIso8601String(),
    "narration": narration,
    "debit": debit,
    "credit": credit,
    "bkBalance": bkBalance,
  };
}
