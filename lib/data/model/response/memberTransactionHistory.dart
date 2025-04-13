// To parse this JSON data, do
//
//     final memberTransactionReport = memberTransactionReportFromJson(jsonString);

import 'dart:convert';

List<MemberTransactionReport> memberTransactionReportFromJson(String str) => List<MemberTransactionReport>.from(json.decode(str).map((x) => MemberTransactionReport.fromJson(x)));

String memberTransactionReportToJson(List<MemberTransactionReport> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MemberTransactionReport {
  String accountNumber;
  String accountTitle;
  DateTime trandate;
  String product;
  dynamic branchAddress;
  dynamic branchName;
  DateTime valueDate;
  String module;
  String narration;
  dynamic fullName;
  dynamic mobile;
  dynamic address;
  dynamic debitacct;
  dynamic creditAcct;
  dynamic totalAmount;

  MemberTransactionReport({
    required this.accountNumber,
    required this.accountTitle,
    required this.trandate,
    required this.product,
    required this.branchAddress,
    required this.branchName,
    required this.valueDate,
    required this.module,
    required this.narration,
    required this.fullName,
    required this.mobile,
    required this.address,
    required this.debitacct,
    required this.creditAcct,
    required this.totalAmount,
  });

  factory MemberTransactionReport.fromJson(Map<String, dynamic> json) => MemberTransactionReport(
    accountNumber: json["accountNumber"],
    accountTitle: json["accountTitle"],
    trandate: DateTime.parse(json["trandate"]),
    product: json["product"],
    branchAddress: json["branchAddress"],
    branchName: json["branchName"],
    valueDate: DateTime.parse(json["valueDate"]),
    module: json["module"],
    narration: json["narration"],
    fullName: json["fullName"],
    mobile: json["mobile"],
    address: json["address"],
    debitacct: json["debitacct"],
    creditAcct: json["creditAcct"],
    totalAmount: json["totalAmount"],
  );

  Map<String, dynamic> toJson() => {
    "accountNumber": accountNumber,
    "accountTitle": accountTitle,
    "trandate": trandate.toIso8601String(),
    "product": product,
    "branchAddress": branchAddress,
    "branchName": branchName,
    "valueDate": valueDate.toIso8601String(),
    "module": module,
    "narration": narration,
    "fullName": fullName,
    "mobile": mobile,
    "address": address,
    "debitacct": debitacct,
    "creditAcct": creditAcct,
    "totalAmount": totalAmount,
  };
}
