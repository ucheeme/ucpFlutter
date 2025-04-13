// To parse this JSON data, do
//
//     final electionDetails = electionDetailsFromJson(jsonString);

import 'dart:convert';

ElectionDetails electionDetailsFromJson(String str) => ElectionDetails.fromJson(json.decode(str));

String electionDetailsToJson(ElectionDetails data) => json.encode(data.toJson());

class ElectionDetails {
  String id;
  dynamic title;
  dynamic description;
  DateTime startDateAndTime;
  DateTime endDateAndTime;
  dynamic electionGuideLine;
  int electionStatus;
  bool allowMemberToViewElectionDetails;
  bool allowMemberToViewResult;
  List<Contestant> contestants;

  ElectionDetails({
    required this.id,
     this.title,
    required this.description,
    required this.startDateAndTime,
    required this.endDateAndTime,
    required this.electionGuideLine,
    required this.electionStatus,
    required this.allowMemberToViewElectionDetails,
    required this.allowMemberToViewResult,
    required this.contestants,
  });

  factory ElectionDetails.fromJson(Map<String, dynamic> json) => ElectionDetails(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    startDateAndTime: DateTime.parse(json["startDateAndTime"]),
    endDateAndTime: DateTime.parse(json["endDateAndTime"]),
    electionGuideLine: json["electionGuideLine"],
    electionStatus: json["electionStatus"],
    allowMemberToViewElectionDetails: json["allowMemberToViewElectionDetails"],
    allowMemberToViewResult: json["allowMemberToViewResult"],
    contestants: json["contestants"] == null ? [] : List<Contestant>.from(json["contestants"].map((x) => Contestant.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "startDateAndTime": startDateAndTime.toIso8601String(),
    "endDateAndTime": endDateAndTime.toIso8601String(),
    "electionGuideLine": electionGuideLine,
    "electionStatus": electionStatus,
    "allowMemberToViewElectionDetails": allowMemberToViewElectionDetails,
    "allowMemberToViewResult": allowMemberToViewResult,
    "contestants":contestants == null ? [] : List<dynamic>.from(contestants!.map((x) => x.toJson())),
  };
}

class Contestant {
  int nodeId;
  String id;
  String fullName;
  int approvalStatus;
  String approvalStatusTest;
  String image;
  String positionName;
  String manifestoDocument;
  String electionName;
  String memberId;
  DateTime dateCreated;
  String profileImageBase64;

  Contestant({
    required this.nodeId,
    required this.id,
    required this.fullName,
    required this.approvalStatus,
    required this.approvalStatusTest,
    required this.image,
    required this.positionName,
    required this.manifestoDocument,
    required this.electionName,
    required this.memberId,
    required this.dateCreated,
    required this.profileImageBase64,
  });

  factory Contestant.fromJson(Map<String, dynamic> json) => Contestant(
    nodeId: json["nodeId"],
    id: json["id"],
    fullName: json["fullName"],
    approvalStatus: json["approvalStatus"],
    approvalStatusTest: json["approvalStatusTest"],
    image: json["image"],
    positionName: json["positionName"],
    manifestoDocument: json["manifestoDocument"],
    electionName: json["electionName"],
    memberId: json["memberId"],
    dateCreated: DateTime.parse(json["dateCreated"]),
    profileImageBase64: json["profileImageBase64"],
  );

  Map<String, dynamic> toJson() => {
    "nodeId": nodeId,
    "id": id,
    "fullName": fullName,
    "approvalStatus": approvalStatus,
    "approvalStatusTest": approvalStatusTest,
    "image": image,
    "positionName": positionName,
    "manifestoDocument": manifestoDocument,
    "electionName": electionName,
    "memberId": memberId,
    "dateCreated": dateCreated.toIso8601String(),
    "profileImageBase64": profileImageBase64,
  };
}
