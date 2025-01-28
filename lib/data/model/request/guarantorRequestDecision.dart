// To parse this JSON data, do
//
//     final guarantorRequestDecision = guarantorRequestDecisionFromJson(jsonString);

import 'dart:convert';

GuarantorRequestDecision guarantorRequestDecisionFromJson(String str) => GuarantorRequestDecision.fromJson(json.decode(str));

String guarantorRequestDecisionToJson(GuarantorRequestDecision data) => json.encode(data.toJson());

class GuarantorRequestDecision {
  int id;

  GuarantorRequestDecision({
    required this.id,
  });

  factory GuarantorRequestDecision.fromJson(Map<String, dynamic> json) => GuarantorRequestDecision(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}
