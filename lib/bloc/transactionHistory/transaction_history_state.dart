part of 'transaction_history_bloc.dart';

sealed class TransactionHistoryState extends Equatable {
  const TransactionHistoryState();
}

final class TransactionHistoryInitial extends TransactionHistoryState {
  @override
  List<Object> get props => [];
}


class TransactionIsLoading extends TransactionHistoryState{
  @override
  List<Object> get props => [];
}

class TransactionError extends TransactionHistoryState{
  UcpDefaultResponse errorResponse;
  TransactionError(this.errorResponse);
  @override
  List<Object> get props => [errorResponse];
}

class TransactionHistory extends TransactionHistoryState{
  TransactionResponse response;
  TransactionHistory(this.response);
  @override
  List<Object> get props => [response];
}

class AccountSummaryDetails extends TransactionHistoryState{
  List<UserAccounts> response;
  AccountSummaryDetails(this.response);
  @override
  List<Object> get props => [response];
}