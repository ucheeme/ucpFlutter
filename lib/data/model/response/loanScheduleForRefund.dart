// To parse this JSON data, do
//
//     final loanScheduleForRefundResponse = loanScheduleForRefundResponseFromJson(jsonString);

import 'dart:convert';

List<LoanScheduleForRefundResponse> loanScheduleForRefundResponseFromJson(String str) => List<LoanScheduleForRefundResponse>.from(json.decode(str).map((x) => LoanScheduleForRefundResponse.fromJson(x)));

String loanScheduleForRefundResponseToJson(List<LoanScheduleForRefundResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoanScheduleForRefundResponse {
  int loanScheduleId;
  String accountNumber;
  String accountName;
  String productName;
  DateTime dueDate;
  dynamic principalAmount;
  dynamic interestRate;
  dynamic totalAmount;
  String status;
  String loanTerm;
  dynamic payOrder;
  String paymentStatus;
  String iPaid;
  String pPaid;
  String repayMode;
  String loanScheduleDescription;
  DateTime firstPaymentDate;
  DateTime startDate;
  DateTime maturityDate;
  dynamic totalPrincipal;
  dynamic totalInterest;
  dynamic totalPrincipalInterest;
  dynamic totalInstallments;
  double totalRepayAmount;
  dynamic interestAmount;

  LoanScheduleForRefundResponse({
    required this.loanScheduleId,
    required this.accountNumber,
    required this.accountName,
    required this.productName,
    required this.dueDate,
    required this.principalAmount,
    required this.interestRate,
    required this.totalAmount,
    required this.status,
    required this.loanTerm,
    required this.payOrder,
    required this.paymentStatus,
    required this.iPaid,
    required this.pPaid,
    required this.repayMode,
    required this.loanScheduleDescription,
    required this.firstPaymentDate,
    required this.startDate,
    required this.maturityDate,
    required this.totalPrincipal,
    required this.totalInterest,
    required this.totalPrincipalInterest,
    required this.totalInstallments,
    required this.totalRepayAmount,
    required this.interestAmount,
  });

  factory LoanScheduleForRefundResponse.fromJson(Map<String, dynamic> json) => LoanScheduleForRefundResponse(
    loanScheduleId: json["loanScheduleId"],
    accountNumber: json["accountNumber"],
    accountName: json["accountName"],
    productName: json["productName"],
    dueDate: DateTime.parse(json["dueDate"]),
    principalAmount: json["principalAmount"]?.toDouble(),
    interestRate: json["interestRate"],
    totalAmount: json["totalAmount"],
    status: json["status"],
    loanTerm: json["loanTerm"],
    payOrder: json["payOrder"],
    paymentStatus: json["paymentStatus"],
    iPaid: json["i_paid"],
    pPaid: json["p_paid"],
    repayMode: json["repayMode"],
    loanScheduleDescription: json["loanScheduleDescription"],
    firstPaymentDate: DateTime.parse(json["firstPaymentDate"]),
    startDate: DateTime.parse(json["startDate"]),
    maturityDate: DateTime.parse(json["maturityDate"]),
    totalPrincipal: json["totalPrincipal"],
    totalInterest: json["totalInterest"],
    totalPrincipalInterest: json["totalPrincipalInterest"],
    totalInstallments: json["totalInstallments"],
    totalRepayAmount: json["totalRepayAmount"]?.toDouble(),
    interestAmount: json["interestAmount"],
  );

  Map<String, dynamic> toJson() => {
    "loanScheduleId": loanScheduleId,
    "accountNumber": accountNumber,
    "accountName": accountName,
    "productName": productName,
    "dueDate": dueDate.toIso8601String(),
    "principalAmount": principalAmount,
    "interestRate": interestRate,
    "totalAmount": totalAmount,
    "status": status,
    "loanTerm": loanTerm,
    "payOrder": payOrder,
    "paymentStatus": paymentStatus,
    "i_paid": iPaid,
    "p_paid": pPaid,
    "repayMode": repayMode,
    "loanScheduleDescription": loanScheduleDescription,
    "firstPaymentDate": firstPaymentDate.toIso8601String(),
    "startDate": startDate.toIso8601String(),
    "maturityDate": maturityDate.toIso8601String(),
    "totalPrincipal": totalPrincipal,
    "totalInterest": totalInterest,
    "totalPrincipalInterest": totalPrincipalInterest,
    "totalInstallments": totalInstallments,
    "totalRepayAmount": totalRepayAmount,
    "interestAmount": interestAmount,
  };
}
