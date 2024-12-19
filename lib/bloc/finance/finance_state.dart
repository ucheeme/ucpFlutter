part of 'finance_bloc.dart';

sealed class FinanceState extends Equatable {
  const FinanceState();
}

final class FinanceInitial extends FinanceState {
  @override
  List<Object> get props => [];
}
