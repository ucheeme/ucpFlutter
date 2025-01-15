// To parse this JSON data, do
//
//     final loanRequestsList = loanRequestsListFromJson(jsonString);

import 'dart:convert';

LoanRequestsList loanRequestsListFromJson(String str) => LoanRequestsList.fromJson(json.decode(str));

String loanRequestsListToJson(LoanRequestsList data) => json.encode(data.toJson());

class LoanRequestsList {
  int pageSize;
  int pageNumber;
  int totalCount;
  List<LoanRequests> modelResult;

  LoanRequestsList({
    required this.pageSize,
    required this.pageNumber,
    required this.totalCount,
    required this.modelResult,
  });

  factory LoanRequestsList.fromJson(Map<String, dynamic> json) => LoanRequestsList(
    pageSize: json["pageSize"],
    pageNumber: json["pageNumber"],
    totalCount: json["totalCount"],
    modelResult: List<LoanRequests>.from(json["modelResult"].map((x) => LoanRequests.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageSize": pageSize,
    "pageNumber": pageNumber,
    "totalCount": totalCount,
    "modelResult": List<dynamic>.from(modelResult.map((x) => x.toJson())),
  };
}

class LoanRequests {
  String applicationNumber;
  String productName;
  dynamic loanAmount;
  int duration;
  String status;
  DateTime date;
  dynamic interestRate;
  String frequency;

  LoanRequests({
    required this.applicationNumber,
    required this.productName,
    required this.loanAmount,
    required this.duration,
    required this.status,
    required this.date,
    required this.interestRate,
    required this.frequency,
  });

  factory LoanRequests.fromJson(Map<String, dynamic> json) => LoanRequests(
    applicationNumber: json["applicationNumber"],
    productName: json["productName"]!,
    loanAmount: json["loanAmount"],
    duration: json["duration"],
    status: json["status"]!,
    date: DateTime.parse(json["date"]),
    interestRate: json["interestRate"],
    frequency: json["frequency"]!,
  );

  Map<String, dynamic> toJson() => {
    "applicationNumber": applicationNumber,
    "productName": productName,
    "loanAmount": loanAmount,
    "duration": duration,
    "status":status,
    "date": date.toIso8601String(),
    "interestRate": interestRate,
    "frequency":frequency,
  };
}


