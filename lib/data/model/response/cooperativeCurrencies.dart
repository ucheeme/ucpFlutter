// To parse this JSON data, do
//
//     final cooperativeCurrencies = cooperativeCurrenciesFromJson(jsonString);

import 'dart:convert';

List<CooperativeCurrencies> cooperativeCurrenciesFromJson(String str) => List<CooperativeCurrencies>.from(json.decode(str).map((x) => CooperativeCurrencies.fromJson(x)));

String cooperativeCurrenciesToJson(List<CooperativeCurrencies> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CooperativeCurrencies {
  String countryCode;
  String currencyName;

  CooperativeCurrencies({
    required this.countryCode,
    required this.currencyName,
  });

  factory CooperativeCurrencies.fromJson(Map<String, dynamic> json) => CooperativeCurrencies(
    countryCode: json["countryCode"],
    currencyName: json["currencyName"],
  );

  Map<String, dynamic> toJson() => {
    "countryCode": countryCode,
    "currencyName": currencyName,
  };
}
