// To parse this JSON data, do
//
//     final electionResult = electionResultFromJson(jsonString);

import 'dart:convert';

ElectionResult electionResultFromJson(String str) => ElectionResult.fromJson(json.decode(str));

String electionResultToJson(ElectionResult data) => json.encode(data.toJson());

class ElectionResult {
  String electionTitle;
  int totalVotes;
  List<ElectionGeneralReport> electionGeneralReport;

  ElectionResult({
    required this.electionTitle,
    required this.totalVotes,
    required this.electionGeneralReport,
  });

  factory ElectionResult.fromJson(Map<String, dynamic> json) => ElectionResult(
    electionTitle: json["electionTitle"],
    totalVotes: json["totalVotes"],
    electionGeneralReport: List<ElectionGeneralReport>.from(json["electionGeneralReport"].map((x) => ElectionGeneralReport.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "electionTitle": electionTitle,
    "totalVotes": totalVotes,
    "electionGeneralReport": List<dynamic>.from(electionGeneralReport.map((x) => x.toJson())),
  };
}

class ElectionGeneralReport {
  String candidateName;
  int numberOfVotes;
  int position;
  bool isWinner;

  ElectionGeneralReport({
    required this.candidateName,
    required this.numberOfVotes,
    required this.position,
    required this.isWinner,
  });

  factory ElectionGeneralReport.fromJson(Map<String, dynamic> json) => ElectionGeneralReport(
    candidateName: json["candidateName"],
    numberOfVotes: json["numberOfVotes"],
    position: json["position"],
    isWinner: json["isWinner"],
  );

  Map<String, dynamic> toJson() => {
    "candidateName": candidateName,
    "numberOfVotes": numberOfVotes,
    "position": position,
    "isWinner": isWinner,
  };
}
