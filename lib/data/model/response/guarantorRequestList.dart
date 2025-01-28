// To parse this JSON data, do
//
//     final guarantorRequestList = guarantorRequestListFromJson(jsonString);

import 'dart:convert';

GuarantorRequestList guarantorRequestListFromJson(String str) => GuarantorRequestList.fromJson(json.decode(str));

String guarantorRequestListToJson(GuarantorRequestList data) => json.encode(data.toJson());

class GuarantorRequestList {
  int pageSize;
  int pageNumber;
  int totalCount;
  List<GuarantorRequestsLoanApplicant> modelResult;

  GuarantorRequestList({
    required this.pageSize,
    required this.pageNumber,
    required this.totalCount,
    required this.modelResult,
  });

  factory GuarantorRequestList.fromJson(Map<String, dynamic> json) => GuarantorRequestList(
    pageSize: json["pageSize"],
    pageNumber: json["pageNumber"],
    totalCount: json["totalCount"],
    modelResult: List<GuarantorRequestsLoanApplicant>.from(json["modelResult"].map((x) => GuarantorRequestsLoanApplicant.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageSize": pageSize,
    "pageNumber": pageNumber,
    "totalCount": totalCount,
    "modelResult": List<dynamic>.from(modelResult.map((x) => x.toJson())),
  };
}

class GuarantorRequestsLoanApplicant {
  String loanApplicant;
  int id;
  String applicationNumber;
  String productName;
  dynamic loanAmount;
  int duration;
  String status;
  DateTime date;
  dynamic interestRate;
  String memberId;
  String gaurantorName;
  String profileImage;

  GuarantorRequestsLoanApplicant({
    required this.loanApplicant,
    required this.id,
    required this.applicationNumber,
    required this.productName,
    required this.loanAmount,
    required this.duration,
    required this.status,
    required this.date,
    required this.interestRate,
    required this.memberId,
    required this.gaurantorName,
    required this.profileImage,
  });

  factory GuarantorRequestsLoanApplicant.fromJson(Map<String, dynamic> json) => GuarantorRequestsLoanApplicant(
    loanApplicant: json["loanApplicant"],
    id: json["id"],
    applicationNumber: json["applicationNumber"],
    productName: json["productName"],
    loanAmount: json["loanAmount"],
    duration: json["duration"],
    status: json["status"],
    date: DateTime.parse(json["date"]),
    interestRate: json["interestRate"],
    memberId: json["memberId"],
    gaurantorName: json["gaurantorName"],
    profileImage: json["profileImage"],
  );

  Map<String, dynamic> toJson() => {
    "loanApplicant": loanApplicant,
    "id": id,
    "applicationNumber": applicationNumber,
    "productName": productName,
    "loanAmount": loanAmount,
    "duration": duration,
    "status": status,
    "date": date.toIso8601String(),
    "interestRate": interestRate,
    "memberId": memberId,
    "gaurantorName": gaurantorName,
    "profileImage": profileImage,
  };
}
