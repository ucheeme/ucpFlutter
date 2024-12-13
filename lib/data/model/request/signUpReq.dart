// To parse this JSON data, do
//
//     final signupRequest = signupRequestFromJson(jsonString);

import 'dart:convert';

SignupRequest signupRequestFromJson(String str) => SignupRequest.fromJson(json.decode(str));

String signupRequestToJson(SignupRequest data) => json.encode(data.toJson());

class SignupRequest {
  int cooperativeId;
  String username;
  String memberNo;
  String firstName;
  String lastName;
  String gender;
  String phoneNumber;
  String emailAddress;
  dynamic contributionAmount;
  String address;
  String country;
  String state;

  SignupRequest({
    required this.cooperativeId,
    required this.username,
    required this.memberNo,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.phoneNumber,
    required this.emailAddress,
    required this.contributionAmount,
    required this.address,
    required this.country,
    required this.state,
  });

  factory SignupRequest.fromJson(Map<String, dynamic> json) => SignupRequest(
    cooperativeId: json["cooperativeId"],
    username: json["username"],
    memberNo: json["memberNo"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    gender: json["gender"],
    phoneNumber: json["phoneNumber"],
    emailAddress: json["emailAddress"],
    contributionAmount: json["contributionAmount"],
    address: json["address"],
    country: json["country"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "cooperativeId": cooperativeId,
    "username": username,
    "memberNo": memberNo,
    "firstName": firstName,
    "lastName": lastName,
    "gender": gender,
    "phoneNumber": phoneNumber,
    "emailAddress": emailAddress,
    "contributionAmount": contributionAmount,
    "address": address,
    "country": country,
    "state": state,
  };
}
