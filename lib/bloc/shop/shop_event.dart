part of 'shop_bloc.dart';

sealed class ShopEvent extends Equatable {
  const ShopEvent();
}
class GetShopItemsEvent extends ShopEvent {
  const GetShopItemsEvent();
  @override
  List<Object> get props => [];
}

class GetAllItemOnCartEvent extends ShopEvent {
  const GetAllItemOnCartEvent();
  @override
  List<Object> get props => [];
}

class GetAllFavoriteItemsEvent extends ShopEvent {
  PaginationRequest request;
   GetAllFavoriteItemsEvent(this.request);
  @override
  List<Object> get props => [];
}

class AddItemToCartEvent extends ShopEvent {
  AddItemToCartRequest request;
  AddItemToCartEvent(this.request);
  @override
  List<Object> get props => [];
}

class RemoveReduceItemQuantityFromCartEvent extends ShopEvent {
  AddReduceItemQuantityOnCartRequest request;
  RemoveReduceItemQuantityFromCartEvent(this.request);
  @override
  List<Object> get props => [];
}

class IncreaseItemQuantityOnCartEvent extends ShopEvent {
  AddReduceItemQuantityOnCartRequest request;
  IncreaseItemQuantityOnCartEvent(this.request);
  @override
  List<Object> get props => [];
}


class MarkItemAsFavoriteEvent extends ShopEvent {
  MarkAsFavoriteRequest request;
  MarkItemAsFavoriteEvent(this.request);
  @override
  List<Object> get props => [];
}
class RemoveItemAsFavEvent extends ShopEvent {
  RemoveItemAsFavRequest request;
  RemoveItemAsFavEvent(this.request);
  @override
  List<Object> get props => [];
}
class GetPurchasedItemRequestItemsEvent extends ShopEvent {
  PaginationRequest request;
  GetPurchasedItemRequestItemsEvent(this.request);
  @override
  List<Object> get props => [];
}
class GetAllItemInPurchasedSummaryEvent extends ShopEvent {
  PaginationRequest request;
  GetAllItemInPurchasedSummaryEvent(this.request);
  @override
  List<Object> get props => [];
}

class PayForItemInCartEvent extends ShopEvent {
  PaymentRequest request;
  PayForItemInCartEvent(this.request);
  @override
  List<Object> get props => [];
}