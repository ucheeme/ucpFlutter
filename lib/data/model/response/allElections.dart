// To parse this JSON data, do
//
//     final allElections = allElectionsFromJson(jsonString);

import 'dart:convert';

AllElections allElectionsFromJson(String str) => AllElections.fromJson(json.decode(str));

String allElectionsToJson(AllElections data) => json.encode(data.toJson());

class AllElections {
  int pageSize;
  int pageNumber;
  int totalCount;
  List<PositionEligible> modelResult;

  AllElections({
    required this.pageSize,
    required this.pageNumber,
    required this.totalCount,
    required this.modelResult,
  });

  factory AllElections.fromJson(Map<String, dynamic> json) => AllElections(
    pageSize: json["pageSize"],
    pageNumber: json["pageNumber"],
    totalCount: json["totalCount"],
    modelResult: List<PositionEligible>.from(json["modelResult"].map((x) => PositionEligible.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageSize": pageSize,
    "pageNumber": pageNumber,
    "totalCount": totalCount,
    "modelResult": List<dynamic>.from(modelResult.map((x) => x.toJson())),
  };
}

class PositionEligible {
  String positionId;
  String electionTitle;
  String electionId;
  DateTime electionStartDate;
  DateTime electionEndDate;
  DateTime dateCreated;
  String electionTime;
  bool allowMemberToViewResult;
  bool isVotingAllowed;
  bool countingVote;
  String electionGuidline;
  int status;
  String statusText;
  String positionName;

  PositionEligible({
    required this.positionId,
    required this.electionTitle,
    required this.electionId,
    required this.electionStartDate,
    required this.electionEndDate,
    required this.dateCreated,
    required this.electionTime,
    required this.allowMemberToViewResult,
    required this.isVotingAllowed,
    required this.countingVote,
    required this.electionGuidline,
    required this.status,
    required this.statusText,
    required this.positionName,
  });

  factory PositionEligible.fromJson(Map<String, dynamic> json) => PositionEligible(
    positionId: json["positionId"],
    electionTitle: json["electionTitle"],
    electionId: json["electionId"],
    electionStartDate: DateTime.parse(json["electionStartDate"]),
    electionEndDate: DateTime.parse(json["electionEndDate"]),
    dateCreated: DateTime.parse(json["dateCreated"]),
    electionTime: json["electionTime"],
    allowMemberToViewResult: json["allowMemberToViewResult"],
    isVotingAllowed: json["isVotingAllowed"],
    countingVote: json["countingVote"],
    electionGuidline: json["electionGuidline"],
    status: json["status"],
    statusText: json["statusText"],
    positionName: json["positionName"],
  );

  Map<String, dynamic> toJson() => {
    "positionId": positionId,
    "electionTitle": electionTitle,
    "electionId": electionId,
    "electionStartDate": electionStartDate.toIso8601String(),
    "electionEndDate": electionEndDate.toIso8601String(),
    "dateCreated": dateCreated.toIso8601String(),
    "electionTime": electionTime,
    "allowMemberToViewResult": allowMemberToViewResult,
    "isVotingAllowed": isVotingAllowed,
    "countingVote": countingVote,
    "electionGuidline": electionGuidline,
    "status": status,
    "statusText": statusText,
    "positionName": positionName,
  };
}
