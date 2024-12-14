part of 'transaction_history_bloc.dart';

sealed class TransactionHistoryEvent extends Equatable {
  const TransactionHistoryEvent();
}
class GetTransactionHistory extends TransactionHistoryEvent{
  TransactionRequest request;
  GetTransactionHistory(this.request);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetUserAccountSummary extends TransactionHistoryEvent {
  const GetUserAccountSummary();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}