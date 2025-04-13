// To parse this JSON data, do
//
//     final castVote = castVoteFromJson(jsonString);

import 'dart:convert';

CastVote castVoteFromJson(String str) => CastVote.fromJson(json.decode(str));

String castVoteToJson(CastVote data) => json.encode(data.toJson());

class CastVote {
  String electionId;
  String positionId;
  List<String> contestantIds;

  CastVote({
    required this.electionId,
    required this.positionId,
    required this.contestantIds,
  });

  factory CastVote.fromJson(Map<String, dynamic> json) => CastVote(
    electionId: json["electionId"],
    positionId: json["positionId"],
    contestantIds: List<String>.from(json["contestantIds"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "electionId": electionId,
    "positionId": positionId,
    "contestantIds": List<dynamic>.from(contestantIds.map((x) => x)),
  };
}
