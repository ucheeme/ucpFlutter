part of 'shop_bloc.dart';

sealed class ShopState extends Equatable {
  const ShopState();
}

final class ShopInitial extends ShopState {
  @override
  List<Object> get props => [];
}
class ShopIsLoading extends ShopState{
  @override
  List<Object> get props => [];
}
class ShopIsAddingToCartLoading extends ShopState{
  @override
  List<Object> get props => [];
}
class ShopIsIncreasingDecreasingItemQuantityOnCartLoading extends ShopState{
  @override
  List<Object> get props => [];
}
class ShopError extends ShopState{
  UcpDefaultResponse errorResponse;
  ShopError(this.errorResponse);
  @override
  List<Object> get props => [errorResponse];
}

class ShopItemsLoaded extends ShopState {
  List<ShopItemList> shopItemsList;

  ShopItemsLoaded(this.shopItemsList);

  @override
  List<Object> get props => [shopItemsList];
}

class ShopAllItemsInCartLoaded extends ShopState {
  List<ItemsOnCart> shopItemsList;

  ShopAllItemsInCartLoaded(this.shopItemsList);

  @override
  List<Object> get props => [shopItemsList];
}

class ShopAllFavoriteItemsLoaded extends ShopState {
    AllFavoriteItems allFavoriteItems;
  ShopAllFavoriteItemsLoaded(this.allFavoriteItems);
  @override
  List<Object> get props => [allFavoriteItems];
}

class ShopItemAddedToCart extends ShopState{
  UcpDefaultResponse response;
  ShopItemAddedToCart(this.response);
  @override
  List<Object> get props => [response];
}
class ShopItemQuantityIncreased extends ShopState{
  UcpDefaultResponse response;
  ShopItemQuantityIncreased(this.response);
  @override
  List<Object> get props => [response];
}
class ShopItemQuantityDecreased extends ShopState{
  UcpDefaultResponse response;
  ShopItemQuantityDecreased(this.response);
  @override
  List<Object> get props => [response];
}

class ShopItemMarkedAsFavorite extends ShopState{
  UcpDefaultResponse response;
  ShopItemMarkedAsFavorite(this.response);
  @override
  List<Object> get props => [response];
}
class ShopItemUnMarkedAsFavorite extends ShopState{
  UcpDefaultResponse response;
  ShopItemUnMarkedAsFavorite(this.response);
  @override
  List<Object> get props => [response];
}