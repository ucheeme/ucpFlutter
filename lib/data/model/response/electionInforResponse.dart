// To parse this JSON data, do
//
//     final electionInfoResponse = electionInfoResponseFromJson(jsonString);

import 'dart:convert';

ElectionInfoResponse electionInfoResponseFromJson(String str) => ElectionInfoResponse.fromJson(json.decode(str));

String electionInfoResponseToJson(ElectionInfoResponse data) => json.encode(data.toJson());

class ElectionInfoResponse {
  String electionId;
  String electionTitle;
  String positionName;
  String positionId;
  List<Contestant> contestants;

  ElectionInfoResponse({
    required this.electionId,
    required this.electionTitle,
    required this.positionName,
    required this.positionId,
    required this.contestants,
  });

  factory ElectionInfoResponse.fromJson(Map<String, dynamic> json) => ElectionInfoResponse(
    electionId: json["electionId"],
    electionTitle: json["electionTitle"],
    positionName: json["positionName"],
    positionId: json["positionId"],
    contestants: List<Contestant>.from(json["contestants"].map((x) => Contestant.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "electionId": electionId,
    "electionTitle": electionTitle,
    "positionName": positionName,
    "positionId": positionId,
    "contestants": List<dynamic>.from(contestants.map((x) => x.toJson())),
  };
}

class Contestant {
  String id;
  String fullName;
  int approvalStatus;
  String approvalStatusTest;
  String image;
  String manifestoDocument;
  String memberId;
  DateTime dateCreated;
  String profileImageBase64;
  String positionId;
  String positionName;

  Contestant({
    required this.id,
    required this.fullName,
    required this.approvalStatus,
    required this.approvalStatusTest,
    required this.image,
    required this.manifestoDocument,
    required this.memberId,
    required this.dateCreated,
    required this.profileImageBase64,
    required this.positionId,
    required this.positionName,
  });

  factory Contestant.fromJson(Map<String, dynamic> json) => Contestant(
    id: json["id"],
    fullName: json["fullName"],
    approvalStatus: json["approvalStatus"],
    approvalStatusTest: json["approvalStatusTest"],
    image: json["image"],
    manifestoDocument: json["manifestoDocument"],
    memberId: json["memberId"],
    dateCreated: DateTime.parse(json["dateCreated"]),
    profileImageBase64: json["profileImageBase64"],
    positionId: json["positionId"],
    positionName: json["positionName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "approvalStatus": approvalStatus,
    "approvalStatusTest": approvalStatusTest,
    "image": image,
    "manifestoDocument": manifestoDocument,
    "memberId": memberId,
    "dateCreated": dateCreated.toIso8601String(),
    "profileImageBase64": profileImageBase64,
    "positionId": positionId,
    "positionName": positionName,
  };
}
