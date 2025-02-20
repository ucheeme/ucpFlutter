// To parse this JSON data, do
//
//     final applyAsContestantForElectionRequest = applyAsContestantForElectionRequestFromJson(jsonString);

import 'dart:convert';

ApplyAsContestantForElectionRequest applyAsContestantForElectionRequestFromJson(String str) => ApplyAsContestantForElectionRequest.fromJson(json.decode(str));

String applyAsContestantForElectionRequestToJson(ApplyAsContestantForElectionRequest data) => json.encode(data.toJson());

class ApplyAsContestantForElectionRequest {
  String positionId;
  String electionId;

  ApplyAsContestantForElectionRequest({
    required this.positionId,
    required this.electionId,
  });

  factory ApplyAsContestantForElectionRequest.fromJson(Map<String, dynamic> json) => ApplyAsContestantForElectionRequest(
    positionId: json["PositionId"],
    electionId: json["ElectionId"],
  );

  Map<String, dynamic> toJson() => {
    "PositionId": positionId,
    "ElectionId": electionId,
  };
}
