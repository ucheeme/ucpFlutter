part of 'shop_bloc.dart';

sealed class ShopState extends Equatable {
  const ShopState();
}

final class ShopInitial extends ShopState {
  @override
  List<Object> get props => [];
}
