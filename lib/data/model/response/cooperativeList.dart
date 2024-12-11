// To parse this JSON data, do
//
//     final cooperativeListResponse = cooperativeListResponseFromJson(jsonString);

import 'dart:convert';

List<CooperativeListResponse> cooperativeListResponseFromJson(String str) => List<CooperativeListResponse>.from(json.decode(str).map((x) => CooperativeListResponse.fromJson(x)));

String cooperativeListResponseToJson(List<CooperativeListResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CooperativeListResponse {
  int nodeId;
  String tenantName;
  String? contactPersonPhone;
  String? contactPersonEmail;
  int status;

  CooperativeListResponse({
    required this.nodeId,
    required this.tenantName,
     this.contactPersonPhone,
     this.contactPersonEmail,
    required this.status,
  });

  factory CooperativeListResponse.fromJson(Map<String, dynamic> json) => CooperativeListResponse(
    nodeId: json["nodeId"],
    tenantName: json["tenantName"],
    contactPersonPhone: json["contactPersonPhone"],
    contactPersonEmail: json["contactPersonEmail"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "nodeId": nodeId,
    "tenantName": tenantName,
    "contactPersonPhone": contactPersonPhone,
    "contactPersonEmail": contactPersonEmail,
    "status": status,
  };
}
