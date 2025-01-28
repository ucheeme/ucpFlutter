// To parse this JSON data, do
//
//     final userLoansResponse = userLoansResponseFromJson(jsonString);

import 'dart:convert';

UserLoansResponse userLoansResponseFromJson(String str) => UserLoansResponse.fromJson(json.decode(str));

String userLoansResponseToJson(UserLoansResponse data) => json.encode(data.toJson());

class UserLoansResponse {
  int pageSize;
  int pageNumber;
  int totalCount;
  List<UserLoans> modelResult;

  UserLoansResponse({
    required this.pageSize,
    required this.pageNumber,
    required this.totalCount,
    required this.modelResult,
  });

  factory UserLoansResponse.fromJson(Map<String, dynamic> json) => UserLoansResponse(
    pageSize: json["pageSize"],
    pageNumber: json["pageNumber"],
    totalCount: json["totalCount"],
    modelResult: List<UserLoans>.from(json["modelResult"].map((x) => UserLoans.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageSize": pageSize,
    "pageNumber": pageNumber,
    "totalCount": totalCount,
    "modelResult": List<dynamic>.from(modelResult.map((x) => x.toJson())),
  };
}

class UserLoans {
  String accountNumber;
  String accountProduct;
  dynamic loanAmount;
  String status;
  DateTime createdDate;

  UserLoans({
    required this.accountNumber,
    required this.accountProduct,
    required this.loanAmount,
    required this.status,
    required this.createdDate,
  });

  factory UserLoans.fromJson(Map<String, dynamic> json) => UserLoans(
    accountNumber: json["accountNumber"],
    accountProduct: json["accountProduct"],
    loanAmount: json["loanAmount"],
    status: json["status"],
    createdDate: DateTime.parse(json["createdDate"]),
  );

  Map<String, dynamic> toJson() => {
    "accountNumber": accountNumber,
    "accountProduct": accountProduct,
    "loanAmount": loanAmount,
    "status": status,
    "createdDate": createdDate.toIso8601String(),
  };
}
