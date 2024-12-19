// To parse this JSON data, do
//
//     final nextMemberId = nextMemberIdFromJson(jsonString);

import 'dart:convert';

NextMemberId nextMemberIdFromJson(String str) => NextMemberId.fromJson(json.decode(str));

String nextMemberIdToJson(NextMemberId data) => json.encode(data.toJson());

class NextMemberId {
  int nextMemberNo;
  CooperativePaymentRequirement cooperativePaymentRequirement;

  NextMemberId({
    required this.nextMemberNo,
    required this.cooperativePaymentRequirement,
  });

  factory NextMemberId.fromJson(Map<String, dynamic> json) => NextMemberId(
    nextMemberNo: json["nextMemberNo"],
    cooperativePaymentRequirement: CooperativePaymentRequirement.fromJson(json["cooperativePaymentRequirement"]),
  );

  Map<String, dynamic> toJson() => {
    "nextMemberNo": nextMemberNo,
    "cooperativePaymentRequirement": cooperativePaymentRequirement.toJson(),
  };
}

class CooperativePaymentRequirement {
  int registrationFee;
  int registrationFeeMode;

  CooperativePaymentRequirement({
    required this.registrationFee,
    required this.registrationFeeMode,
  });

  factory CooperativePaymentRequirement.fromJson(Map<String, dynamic> json) => CooperativePaymentRequirement(
    registrationFee: json["registrationFee"],
    registrationFeeMode: json["registrationFeeMode"],
  );

  Map<String, dynamic> toJson() => {
    "registrationFee": registrationFee,
    "registrationFeeMode": registrationFeeMode,
  };
}
