// To parse this JSON data, do
//
//     final positionIds = positionIdsFromJson(jsonString);

import 'dart:convert';

PositionIds positionIdsFromJson(String str) => PositionIds.fromJson(json.decode(str));

String positionIdsToJson(PositionIds data) => json.encode(data.toJson());

class PositionIds {
  List<PositionID> positions;

  PositionIds({
    required this.positions,
  });

  factory PositionIds.fromJson(Map<String, dynamic> json) => PositionIds(
    positions: List<PositionID>.from(json["positions"].map((x) => PositionID.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "positions": List<dynamic>.from(positions.map((x) => x.toJson())),
  };
}

class PositionID {
  String id;
  String name;

  PositionID({
    required this.id,
    required this.name,
  });

  factory PositionID.fromJson(Map<String, dynamic> json) => PositionID(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
