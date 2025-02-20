// To parse this JSON data, do
//
//     final contestantInfo = contestantInfoFromJson(jsonString);

import 'dart:convert';

ContestantInfoResponse contestantInfoFromJson(String str) => ContestantInfoResponse.fromJson(json.decode(str));

String contestantInfoToJson(ContestantInfoResponse data) => json.encode(data.toJson());

class ContestantInfoResponse {
  int nodeId;
  String id;
  String positionId;
  String electionId;
  dynamic fullName;
  dynamic memberId;
  dynamic profileImage;
  dynamic manifestoDocument;
  dynamic positionName;
  dynamic electionName;
  dynamic profileImageBase64;

  ContestantInfoResponse({
    required this.nodeId,
    required this.id,
    required this.positionId,
    required this.electionId,
    required this.fullName,
    required this.memberId,
    required this.profileImage,
    required this.manifestoDocument,
    required this.positionName,
    required this.electionName,
    required this.profileImageBase64,
  });

  factory ContestantInfoResponse.fromJson(Map<String, dynamic> json) => ContestantInfoResponse(
    nodeId: json["nodeId"],
    id: json["id"],
    positionId: json["positionId"],
    electionId: json["electionId"],
    fullName: json["fullName"],
    memberId: json["memberId"],
    profileImage: json["profileImage"],
    manifestoDocument: json["manifestoDocument"],
    positionName: json["positionName"],
    electionName: json["electionName"],
    profileImageBase64: json["profileImageBase64"],
  );

  Map<String, dynamic> toJson() => {
    "nodeId": nodeId,
    "id": id,
    "positionId": positionId,
    "electionId": electionId,
    "fullName": fullName,
    "memberId": memberId,
    "profileImage": profileImage,
    "manifestoDocument": manifestoDocument,
    "positionName": positionName,
    "electionName": electionName,
    "profileImageBase64": profileImageBase64,
  };
}


class ElectionPositionRequest{
  String? positionId;
  String? electionId;
  ElectionPositionRequest({this.electionId,this.positionId});
}