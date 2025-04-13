// To parse this JSON data, do
//
//     final memberSignUpCost = memberSignUpCostFromJson(jsonString);

import 'dart:convert';

MemberSignUpCost memberSignUpCostFromJson(String str) => MemberSignUpCost.fromJson(json.decode(str));

String memberSignUpCostToJson(MemberSignUpCost data) => json.encode(data.toJson());

class MemberSignUpCost {
  dynamic regFee;
  int? regStatus;

  MemberSignUpCost({
     this.regFee,
     this.regStatus,
  });

  factory MemberSignUpCost.fromJson(Map<String, dynamic> json) => MemberSignUpCost(
    regFee: json["regFee"],
    regStatus: json["regStatus"],
  );

  Map<String, dynamic> toJson() => {
    "regFee": regFee,
    "regStatus": regStatus,
  };
}
