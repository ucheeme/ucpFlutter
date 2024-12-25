// To parse this JSON data, do
//
//     final shopItemList = shopItemListFromJson(jsonString);

import 'dart:convert';

List<ShopItemList> shopItemListFromJson(String str) => List<ShopItemList>.from(json.decode(str).map((x) => ShopItemList.fromJson(x)));

String shopItemListToJson(List<ShopItemList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShopItemList {
  String itemCode;
  String itemName;
  dynamic itemPrice;
  int? quantity;
  dynamic itemImage;
  bool? isFavourite;

  ShopItemList({
    required this.itemCode,
    required this.itemName,
    required this.itemPrice,
    this.quantity,
    this.isFavourite,
    this.itemImage,
  });

  factory ShopItemList.fromJson(Map<String, dynamic> json) => ShopItemList(
    itemCode: json["itemCode"],
    itemName: json["itemName"],
    itemPrice: json["itemPrice"],
    quantity: json["quantity"],
    isFavourite: json["isFavourite"],
    itemImage: json["itemImage"],
  );

  Map<String, dynamic> toJson() => {
    "itemCode": itemCode,
    "itemName": itemName,
    "itemPrice": itemPrice,
    "quantity": quantity,
    "isFavourite": isFavourite,
    "itemImage": itemImage,
  };
}
