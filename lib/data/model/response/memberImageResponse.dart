// To parse this JSON data, do
//
//     final memberImageResponse = memberImageResponseFromJson(jsonString);

import 'dart:convert';

MemberImageResponse memberImageResponseFromJson(String str) => MemberImageResponse.fromJson(json.decode(str));

String memberImageResponseToJson(MemberImageResponse data) => json.encode(data.toJson());

class MemberImageResponse {
  String profileImage;

  MemberImageResponse({
    required this.profileImage,
  });

  factory MemberImageResponse.fromJson(Map<String, dynamic> json) => MemberImageResponse(
    profileImage: json["profileImage"],
  );

  Map<String, dynamic> toJson() => {
    "profileImage": profileImage,
  };
}
