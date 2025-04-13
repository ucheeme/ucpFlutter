// To parse this JSON data, do
//
//     final memberDetails = memberDetailsFromJson(jsonString);

import 'dart:convert';

MemberDetails memberDetailsFromJson(String str) => MemberDetails.fromJson(json.decode(str));

String memberDetailsToJson(MemberDetails data) => json.encode(data.toJson());

class MemberDetails {
  String employeeId;
  String bank;
  String firstName;
  String lastName;
  String otherName;
  String email;
  String bvn;
  String nextName;
  String occupation;
  String nextAddress;
  String acctName;
  String bankAccountNumber;
  String phone;
  String nextPhone;
  DateTime dob;
  String gender;
  String residentCountry;
  String residentState;
  String nextCountry;
  String nextState;
  String memberImage;

  MemberDetails({
    required this.employeeId,
    required this.bank,
    required this.firstName,
    required this.lastName,
    required this.otherName,
    required this.email,
    required this.bvn,
    required this.nextName,
    required this.occupation,
    required this.nextAddress,
    required this.acctName,
    required this.bankAccountNumber,
    required this.phone,
    required this.nextPhone,
    required this.dob,
    required this.gender,
    required this.residentCountry,
    required this.residentState,
    required this.nextCountry,
    required this.nextState,
    required this.memberImage,
  });

  factory MemberDetails.fromJson(Map<String, dynamic> json) => MemberDetails(
    employeeId: json["employeeID"],
    bank: json["bank"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    otherName: json["otherName"],
    email: json["email"],
    bvn: json["bvn"],
    nextName: json["nextName"],
    occupation: json["occupation"],
    nextAddress: json["nextAddress"],
    acctName: json["acctName"],
    bankAccountNumber: json["bankAccountNumber"],
    phone: json["phone"],
    nextPhone: json["nextPhone"],
    dob: DateTime.parse(json["dob"]),
    gender: json["gender"],
    residentCountry: json["residentCountry"],
    residentState: json["residentState"],
    nextCountry: json["nextCountry"],
    nextState: json["nextState"],
    memberImage: json["memberImage"],
  );

  Map<String, dynamic> toJson() => {
    "employeeID": employeeId,
    "bank": bank,
    "firstName": firstName,
    "lastName": lastName,
    "otherName": otherName,
    "email": email,
    "bvn": bvn,
    "nextName": nextName,
    "occupation": occupation,
    "nextAddress": nextAddress,
    "acctName": acctName,
    "bankAccountNumber": bankAccountNumber,
    "phone": phone,
    "nextPhone": nextPhone,
    "dob": dob.toIso8601String(),
    "gender": gender,
    "residentCountry": residentCountry,
    "residentState": residentState,
    "nextCountry": nextCountry,
    "nextState": nextState,
    "memberImage": memberImage,
  };
}
