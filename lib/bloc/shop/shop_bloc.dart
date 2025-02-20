import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ucp/data/model/request/saveToAccount.dart';
import 'package:ucp/data/repository/FinanceRepo.dart';

import '../../data/model/request/addToCartRequest.dart';
import '../../data/model/request/increaseDecreaseCartItemQuantity.dart';
import '../../data/model/request/markAsFavorite.dart';
import '../../data/model/request/removeFavItem.dart';
import '../../data/model/response/defaultResponse.dart';
import '../../data/model/response/favoriteItemsResponse.dart';
import '../../data/model/response/itemsInPurchaseSummary.dart';
import '../../data/model/response/itemsOnCart.dart';
import '../../data/model/response/paymentResponse.dart';
import '../../data/model/response/purchasedItemSummartResponse.dart';
import '../../data/model/response/shopList.dart';
import '../../data/repository/shoppingRepo.dart';
import '../../utils/apputils.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  ShoppingRepository repo = ShoppingRepository();
  var errorObs = PublishSubject<String>();

  ShopBloc(this.repo) : super(ShopInitial()) {
    on<ShopEvent>((event, emit) {});
    on<GetShopItemsEvent>((event, emit) {
      handleGetShopItemsEvent();
    });
    on<GetAllItemOnCartEvent>((event, emit) {
      handleGetAllItemOnCartEvent();
    });
    on<GetAllFavoriteItemsEvent>((event, emit) {
      handleGetAllFavoriteItemsEvent(event);
    });
    on<RemoveReduceItemQuantityFromCartEvent>((event, emit) {
      handleRemoveReduceItemQuantityFromCartEvent(event);
    });
    on<IncreaseItemQuantityOnCartEvent>((event, emit) {
      handleIncreaseItemQuantityOnCartEvent(event);
    });
    on<MarkItemAsFavoriteEvent>((event, emit) {
      handleMarkItemAsFavoriteEvent(event);
    });
    on<AddItemToCartEvent>((event, emit) {
      handleAddItemToCartEvent(event);
    });
    on<RemoveItemAsFavEvent>((event, emit) {
      handleRemoveItemAsFavEvent(event);
    });
    on<GetPurchasedItemRequestItemsEvent>((event, emit) {
      handleGetPurchasedItemRequestItemsEvent(event);
    });
    on<GetAllItemInPurchasedSummaryEvent>((event, emit) {
      handleGetAllItemInPurchasedSummaryEvent(event);
    });
    on<PayForItemInCartEvent>((event, emit) {
      handlePayForItemInCartEvent(event);
    });
  }

  void handleGetShopItemsEvent() async {
    emit(ShopIsLoading());
    try {
      final response = await repo.getShopItems();
      if (response is List<ShopItemList>) {
        emit(ShopItemsLoaded(response));
        AppUtils.debug("success");
      } else {
        emit(ShopError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    } catch (e, trace) {
      print(trace);
      print(e);
      emit(ShopError(
          AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }

  void handleGetAllItemOnCartEvent() async {
    emit(ShopIsLoading());
    try {
      final response = await repo.getItemsOnCart();
      if (response is List<ItemsOnCart>) {
        emit(ShopAllItemsInCartLoaded(response));
        AppUtils.debug("success");
      } else {
        emit(ShopError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    } catch (e, trace) {
      print(trace);
      print(e);
      emit(ShopError(
          AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }

  void handleGetAllFavoriteItemsEvent(event) async {
    emit(ShopIsLoading());
    try {
      final response = await repo.getAllFavoriteItems(event.request);
      if (response is AllFavoriteItems) {
        emit(ShopAllFavoriteItemsLoaded(response));
        AppUtils.debug("success");
      } else {
        emit(ShopError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    } catch (e, trace) {
      print(trace);
      print(e);
      emit(ShopError(
          AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }

  void handleRemoveReduceItemQuantityFromCartEvent(event) async {
    emit(ShopIsIncreasingDecreasingItemQuantityOnCartLoading());
    try {
      final response = await repo.decreaseItemCountOnCart(event.request);
      if (response is UcpDefaultResponse && response.isSuccessful == true) {
        emit(ShopItemQuantityDecreased(response));
        AppUtils.debug("success");
      } else {
        emit(ShopError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    } catch (e, trace) {
      print(trace);
      print(e);
      emit(ShopError(
          AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }

  void handleIncreaseItemQuantityOnCartEvent(event) async {
    emit(ShopIsIncreasingDecreasingItemQuantityOnCartLoading());
    try {
      final response = await repo.increaseItemCountOnCart(event.request);
      if (response is UcpDefaultResponse && response.isSuccessful == true) {
        emit(ShopItemQuantityIncreased(response));
        AppUtils.debug("success");
      } else {
        emit(ShopError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    } catch (e, trace) {
      print(trace);
      emit(ShopError(
          AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }

  void handleMarkItemAsFavoriteEvent(event) async {
    // emit(ShopIsIncreasingDecreasingItemQuantityOnCartLoading());
    try {
      final response = await repo.markAsFavorite(event.request);
      if (response is UcpDefaultResponse && response.isSuccessful == true) {
        emit(ShopItemMarkedAsFavorite(response));
        AppUtils.debug("success");
      } else {
        emit(ShopError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    } catch (e, trace) {
      print(trace);
      emit(ShopError(
          AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }

  void handleRemoveItemAsFavEvent(event) async {
    // emit(ShopIsIncreasingDecreasingItemQuantityOnCartLoading());
    try {
      final response = await repo.unMarkAsFavorite(event.request);
      if (response is UcpDefaultResponse && response.isSuccessful == true) {
        emit(ShopItemUnMarkedAsFavorite(response));
        AppUtils.debug("success");
      } else {
        emit(ShopError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    } catch (e, trace) {
      print(trace);
      emit(ShopError(
          AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }

  void handleAddItemToCartEvent(event) async {
    emit(ShopIsAddingToCartLoading());
    try {
      final response = await repo.addToCart(event.request);
      if (response is UcpDefaultResponse && response.isSuccessful == true) {
        emit(ShopItemAddedToCart(response));
        AppUtils.debug("success");
      } else {
        emit(ShopError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    } catch (e, trace) {
      print(trace);
      print("The answer");
      emit(ShopError(
          AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }

  void handleGetPurchasedItemRequestItemsEvent(event) async {
    emit(ShopIsLoading());
    try {
      final response = await repo.getAllPurchasedItemSummary(event.request);
      if (response is PurxhasedItemSummaryReport) {
        emit(ShopPurchasedItemsSummaryLoaded(response));
        AppUtils.debug("success");
      } else {
        emit(ShopError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    } catch (e, trace) {
      print(trace);
      print("The answer");
      emit(ShopError(
          AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }

  void handleGetAllItemInPurchasedSummaryEvent(event) async {
    emit(ShopIsLoading());
    try {
      final response = await repo.getAllItemInPurchasedSummary(event.request);
      if (response is ItemsInPurchasedSummary) {
        emit(ShopPurchasedItemRequestItemsLoaded(response));
        AppUtils.debug("success");
      } else {
        emit(ShopError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    } catch (e, trace) {
      print(trace);
      print("The answer");
      emit(ShopError(
          AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }

  // ShopPurchasedItemsSummaryLoaded
  initial() {
    emit(ShopInitial());
  }

  void handlePayForItemInCartEvent(PayForItemInCartEvent event) async {
    emit(ShopIsLoading());
    try {
      final response = await repo.payForItemInCart(event.request);
      if (response is PaymentSuccessfulResponse) {
        emit(ShopItemPurchased(response));
        AppUtils.debug("success");
      } else {
        emit(ShopError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    } catch (e, trace) {
      print(trace);
      print("The answer");
      emit(ShopError(
          AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }
}