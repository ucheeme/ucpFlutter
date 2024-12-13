// To parse this JSON data, do
//
//     final signUpResponse = signUpResponseFromJson(jsonString);

import 'dart:convert';

SignUpResponse signUpResponseFromJson(String str) => SignUpResponse.fromJson(json.decode(str));

String signUpResponseToJson(SignUpResponse data) => json.encode(data.toJson());

class SignUpResponse {
  int retval;
  String retmsg;
  int behav;
  dynamic loanAcct;

  SignUpResponse({
    required this.retval,
    required this.retmsg,
    required this.behav,
    required this.loanAcct,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) => SignUpResponse(
    retval: json["retval"],
    retmsg: json["retmsg"],
    behav: json["behav"],
    loanAcct: json["loanAcct"],
  );

  Map<String, dynamic> toJson() => {
    "retval": retval,
    "retmsg": retmsg,
    "behav": behav,
    "loanAcct": loanAcct,
  };
}
