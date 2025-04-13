// To parse this JSON data, do
//
//     final checkIfCooperativeIsSetUpForElection = checkIfCooperativeIsSetUpForElectionFromJson(jsonString);

import 'dart:convert';

CheckIfCooperativeIsSetUpForElection checkIfCooperativeIsSetUpForElectionFromJson(String str) => CheckIfCooperativeIsSetUpForElection.fromJson(json.decode(str));

String checkIfCooperativeIsSetUpForElectionToJson(CheckIfCooperativeIsSetUpForElection data) => json.encode(data.toJson());

class CheckIfCooperativeIsSetUpForElection {
  int id;
  String tenantName;
  List<Privilegde> privilegdes;

  CheckIfCooperativeIsSetUpForElection({
    required this.id,
    required this.tenantName,
    required this.privilegdes,
  });

  factory CheckIfCooperativeIsSetUpForElection.fromJson(Map<String, dynamic> json) => CheckIfCooperativeIsSetUpForElection(
    id: json["id"],
    tenantName: json["tenantName"],
    privilegdes: List<Privilegde>.from(json["privilegdes"].map((x) => Privilegde.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenantName": tenantName,
    "privilegdes": List<dynamic>.from(privilegdes.map((x) => x.toJson())),
  };
}

class Privilegde {
  String menuId;
  String menuName;
  bool isAssigned;

  Privilegde({
    required this.menuId,
    required this.menuName,
    required this.isAssigned,
  });

  factory Privilegde.fromJson(Map<String, dynamic> json) => Privilegde(
    menuId: json["menuId"],
    menuName: json["menuName"],
    isAssigned: json["isAssigned"],
  );

  Map<String, dynamic> toJson() => {
    "menuId": menuId,
    "menuName": menuName,
    "isAssigned": isAssigned,
  };
}
