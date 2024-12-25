// To parse this JSON data, do
//
//     final itemsOnCart = itemsOnCartFromJson(jsonString);

import 'dart:convert';

List<ItemsOnCart> itemsOnCartFromJson(String str) => List<ItemsOnCart>.from(json.decode(str).map((x) => ItemsOnCart.fromJson(x)));

String itemsOnCartToJson(List<ItemsOnCart> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemsOnCart {
  int id;
  String itemcode;
  int quantity;
  String accountnumber;
  String username;
  DateTime createDate;
  String status;
  String itemName;
  dynamic sellprice;
  dynamic totalprice;
  String? customerId;
  String? transOption;

  ItemsOnCart({
    required this.id,
    required this.itemcode,
    required this.quantity,
    required this.accountnumber,
    required this.username,
    required this.createDate,
    required this.status,
    required this.itemName,
    required this.sellprice,
    required this.totalprice,
     this.customerId,
     this.transOption,
  });

  factory ItemsOnCart.fromJson(Map<String, dynamic> json) => ItemsOnCart(
    id: json["id"],
    itemcode: json["itemcode"],
    quantity: json["quantity"],
    accountnumber: json["accountnumber"],
    username: json["username"],
    createDate: DateTime.parse(json["createDate"]),
    status: json["status"],
    itemName: json["itemName"],
    sellprice: json["sellprice"],
    totalprice: json["totalprice"],
    customerId: json["customerId"],
    transOption: json["transOption"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "itemcode": itemcode,
    "quantity": quantity,
    "accountnumber": accountnumber,
    "username": username,
    "createDate": createDate.toIso8601String(),
    "status": status,
    "itemName": itemName,
    "sellprice": sellprice,
    "totalprice": totalprice,
    "customerId": customerId,
    "transOption": transOption,
  };
}
