// To parse this JSON data, do
//
//     final allFavoriteItems = allFavoriteItemsFromJson(jsonString);

import 'dart:convert';

AllFavoriteItems allFavoriteItemsFromJson(String str) => AllFavoriteItems.fromJson(json.decode(str));

String allFavoriteItemsToJson(AllFavoriteItems data) => json.encode(data.toJson());

class AllFavoriteItems {
  int pageSize;
  int pageNumber;
  int totalCount;
  List<FavoriteItem> modelResult;

  AllFavoriteItems({
    required this.pageSize,
    required this.pageNumber,
    required this.totalCount,
    required this.modelResult,
  });

  factory AllFavoriteItems.fromJson(Map<String, dynamic> json) => AllFavoriteItems(
    pageSize: json["pageSize"],
    pageNumber: json["pageNumber"],
    totalCount: json["totalCount"],
    modelResult: List<FavoriteItem>.from(json["modelResult"].map((x) => FavoriteItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pageSize": pageSize,
    "pageNumber": pageNumber,
    "totalCount": totalCount,
    "modelResult": List<dynamic>.from(modelResult.map((x) => x.toJson())),
  };
}

class FavoriteItem {
  String itemCode;
  String itemName;
  dynamic itemPrice;
  int quantity;
  dynamic sellingPrice;
  int status;

  FavoriteItem({
    required this.itemCode,
    required this.itemName,
    required this.itemPrice,
    required this.quantity,
    required this.sellingPrice,
    required this.status,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) => FavoriteItem(
    itemCode: json["itemCode"],
    itemName: json["itemName"],
    itemPrice: json["itemPrice"],
    quantity: json["quantity"],
    sellingPrice: json["sellingPrice"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "itemCode": itemCode,
    "itemName": itemName,
    "itemPrice": itemPrice,
    "quantity": quantity,
    "sellingPrice": sellingPrice,
    "status": status,
  };
}
