// To parse this JSON data, do
//
//     final profileUpdateResponse = profileUpdateResponseFromJson(jsonString);

import 'dart:convert';

ProfileUpdateResponse profileUpdateResponseFromJson(String str) => ProfileUpdateResponse.fromJson(json.decode(str));

String profileUpdateResponseToJson(ProfileUpdateResponse data) => json.encode(data.toJson());

class ProfileUpdateResponse {
  int retval;
  String retmsg;
  int behav;
  dynamic loanAcct;

  ProfileUpdateResponse({
    required this.retval,
    required this.retmsg,
    required this.behav,
    required this.loanAcct,
  });

  factory ProfileUpdateResponse.fromJson(Map<String, dynamic> json) => ProfileUpdateResponse(
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
