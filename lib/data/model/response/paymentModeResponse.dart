// To parse this JSON data, do
//
//     final paymentModes = paymentModesFromJson(jsonString);

import 'dart:convert';

List<PaymentModes> paymentModesFromJson(String str) => List<PaymentModes>.from(json.decode(str).map((x) => PaymentModes.fromJson(x)));

String paymentModesToJson(List<PaymentModes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentModes {
  int modeOfPayId;
  String modeOfPayment;

  PaymentModes({
    required this.modeOfPayId,
    required this.modeOfPayment,
  });

  factory PaymentModes.fromJson(Map<String, dynamic> json) => PaymentModes(
    modeOfPayId: json["modeOfPayID"],
    modeOfPayment: json["modeOfPayment"],
  );

  Map<String, dynamic> toJson() => {
    "modeOfPayID": modeOfPayId,
    "modeOfPayment": modeOfPayment,
  };
}
