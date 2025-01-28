// To parse this JSON data, do
//
//     final updateProfileRequest = updateProfileRequestFromJson(jsonString);

import 'dart:convert';

UpdateProfileRequest updateProfileRequestFromJson(String str) => UpdateProfileRequest.fromJson(json.decode(str));

String updateProfileRequestToJson(UpdateProfileRequest data) => json.encode(data.toJson());

class UpdateProfileRequest {
  String residentState;
  String nextAddress;
  String lastName;
  String gender;
  String nextCountry;
  String residentCountry;
  String employeeId;
  String occupation;
  String phone;
  String dob;
  String bvn;
  String bankAccountNumber;
  String firstName;
  String otherName;
  String nextPhone;
  String bank;
  String email;
  String nextName;
  String nextState;
  String acctName;

  UpdateProfileRequest({
    required this.residentState,
    required this.nextAddress,
    required this.lastName,
    required this.gender,
    required this.nextCountry,
    required this.residentCountry,
    required this.employeeId,
    required this.occupation,
    required this.phone,
    required this.dob,
    required this.bvn,
    required this.bankAccountNumber,
    required this.firstName,
    required this.otherName,
    required this.nextPhone,
    required this.bank,
    required this.email,
    required this.nextName,
    required this.nextState,
    required this.acctName,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) => UpdateProfileRequest(
    residentState: json["ResidentState"],
    nextAddress: json["NextAddress"],
    lastName: json["LastName"],
    gender: json["Gender"],
    nextCountry: json["NextCountry"],
    residentCountry: json["ResidentCountry"],
    employeeId: json["EmployeeID"],
    occupation: json["Occupation"],
    phone: json["Phone"],
    dob: json["DOB"],
    bvn: json["BVN"],
    bankAccountNumber: json["BankAccountNumber"],
    firstName: json["FirstName"],
    otherName: json["OtherName"],
    nextPhone: json["NextPhone"],
    bank: json["Bank"],
    email: json["Email"],
    nextName: json["NextName"],
    nextState: json["NextState"],
    acctName: json["AcctName"],
  );

  Map<String, dynamic> toJson() => {
    "ResidentState": residentState,
    "NextAddress": nextAddress,
    "LastName": lastName,
    "Gender": gender,
    "NextCountry": nextCountry,
    "ResidentCountry": residentCountry,
    "EmployeeID": employeeId,
    "Occupation": occupation,
    "Phone": phone,
    "DOB": dob,
    "BVN": bvn,
    "BankAccountNumber": bankAccountNumber,
    "FirstName": firstName,
    "OtherName": otherName,
    "NextPhone": nextPhone,
    "Bank": bank,
    "Email": email,
    "NextName": nextName,
    "NextState": nextState,
    "AcctName": acctName,
  };
}
