// To parse this JSON data, do
//
//     final loanGuantorsList = loanGuantorsListFromJson(jsonString);

import 'dart:convert';

List<LoanGuantorsList> loanGuantorsListFromJson(String str) => List<LoanGuantorsList>.from(json.decode(str).map((x) => LoanGuantorsList.fromJson(x)));

String loanGuantorsListToJson(List<LoanGuantorsList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoanGuantorsList {
  String employeeId;
  String employeeName;

  LoanGuantorsList({
    required this.employeeId,
    required this.employeeName,
  });

  factory LoanGuantorsList.fromJson(Map<String, dynamic> json) => LoanGuantorsList(
    employeeId: json["employeeId"],
    employeeName: json["employeeName"],
  );

  Map<String, dynamic> toJson() => {
    "employeeId": employeeId,
    "employeeName": employeeName,
  };
}
