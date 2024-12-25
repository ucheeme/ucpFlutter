import 'dart:convert';

import 'package:ucp/data/repository/FinanceRepo.dart';
import 'package:ucp/data/repository/defaultRepository.dart';

import '../../app/apiService/apiService.dart';
import '../../app/apiService/appUrl.dart';
import '../model/request/addToCartRequest.dart';
import '../model/request/increaseDecreaseCartItemQuantity.dart';
import '../model/request/markAsFavorite.dart';
import '../model/response/defaultResponse.dart';
import '../model/response/favoriteItemsResponse.dart';
import '../model/response/itemsOnCart.dart';
import '../model/response/shopList.dart';

class ShoppingRepository extends DefaultRepository{
  Future<Object> getShopItems() async {
    var response = await postRequest(
      null,
      UCPUrls.getShopItems,
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        List<ShopItemList> res = shopItemListFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> getItemsOnCart() async {
    var response = await postRequest(
      null,
      UCPUrls.getAllItemOnCart,
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        List<ItemsOnCart> res = itemsOnCartFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> getAllFavoriteItems(PaginationRequest request) async {
    var response = await postRequest(
      null,
      "${UCPUrls.getAllFavouriteItems}?PageSize=${request.pageSize}&PageNumber=${request.currentPage}",
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        AllFavoriteItems res = allFavoriteItemsFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> increaseItemCountOnCart(AddReduceItemQuantityOnCartRequest request) async {
    var response = await postRequest(
      request,
      UCPUrls.increaseItemCountOnCart,
      true,
      HttpMethods.post,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        UcpDefaultResponse res = ucpDefaultResponseFromJson(json.encode(r));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
  Future<Object> addToCart(AddItemToCartRequest request) async {
    var response = await postRequest(
      request,
      UCPUrls.addItemToCart,
      true,
      HttpMethods.post,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        UcpDefaultResponse res = ucpDefaultResponseFromJson(json.encode(r));
        return res;
      } else {
        handleErrorResponse(r);
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
  Future<Object> markAsFavorite(MarkAsFavoriteRequest request) async {
    var response = await postRequest(
      request,
      UCPUrls.addItemToCart,
      true,
      HttpMethods.post,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        UcpDefaultResponse res = ucpDefaultResponseFromJson(json.encode(r));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
  Future<Object> decreaseItemCountOnCart(AddReduceItemQuantityOnCartRequest request) async {
    var response = await postRequest(
      request,
      UCPUrls.decreaseItemCountOnCart,
      true,
      HttpMethods.post,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        UcpDefaultResponse res = ucpDefaultResponseFromJson(json.encode(r));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
}