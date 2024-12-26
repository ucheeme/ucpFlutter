// To parse this JSON data, do
//
//     final memberProfileData = memberProfileDataFromJson(jsonString);

import 'dart:convert';

MemberProfileData memberProfileDataFromJson(String str) => MemberProfileData.fromJson(json.decode(str));

String memberProfileDataToJson(MemberProfileData data) => json.encode(data.toJson());

class MemberProfileData {
  String? employeeId;
  String? bank;
  String? firstName;
  String? lastName;
  String? otherName;
  String? email;
  String? bvn;
  String? nextName;
  String? occupation;
  String? nextAddress;
  String? acctName;
  String? bankAccountNumber;
  String? phone;
  String? nextPhone;
  DateTime? dob;
  String? gender;
  String? residentCountry;
  String? residentState;
  String? nextCountry;
  String? nextState;
  String? profileImage;

  MemberProfileData({
     this.employeeId,
     this.bank,
     this.firstName,
     this.lastName,
     this.otherName,
     this.email,
     this.bvn,
     this.nextName,
     this.occupation,
     this.nextAddress,
     this.acctName,
     this.bankAccountNumber,
     this.phone,
     this.nextPhone,
     this.dob,
     this.gender,
     this.residentCountry,
     this.residentState,
     this.nextCountry,
     this.nextState,
     this.profileImage,
  });

  factory MemberProfileData.fromJson(Map<String, dynamic> json) => MemberProfileData(
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
    dob: json["dob"]==null?DateTime.now():DateTime.parse(json["dob"]),
    gender: json["gender"],
    residentCountry: json["residentCountry"],
    residentState: json["residentState"],
    nextCountry: json["nextCountry"],
    nextState: json["nextState"],
    profileImage: json["profileImage"],
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
    "dob": dob?.toIso8601String(),
    "gender": gender,
    "residentCountry": residentCountry,
    "residentState": residentState,
    "nextCountry": nextCountry,
    "nextState": nextState,
    "profileImage": profileImage,
  };
}
