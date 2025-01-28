// To parse this JSON data, do
//
//     final loanRequestBreakdownList = loanRequestBreakdownListFromJson(jsonString);

import 'dart:convert';

List<LoanRequestBreakdownList> loanRequestBreakdownListFromJson(String str) => List<LoanRequestBreakdownList>.from(json.decode(str).map((x) => LoanRequestBreakdownList.fromJson(x)));

String loanRequestBreakdownListToJson(List<LoanRequestBreakdownList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoanRequestBreakdownList {
  String date;
  dynamic principal;
  dynamic interest;
  dynamic total;
  dynamic balance;
  dynamic instalDue;

  LoanRequestBreakdownList({
    required this.date,
    required this.principal,
    required this.interest,
    required this.total,
    required this.balance,
    required this.instalDue,
  });

  factory LoanRequestBreakdownList.fromJson(Map<String, dynamic> json) => LoanRequestBreakdownList(
    date: json["date"],
    principal: json["principal"],
    interest: json["interest"],
    total: json["total"],
    balance: json["balance"],
    instalDue: json["instalDue"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "principal": principal,
    "interest": interest,
    "total": total,
    "balance": balance,
    "instalDue": instalDue,
  };
}
