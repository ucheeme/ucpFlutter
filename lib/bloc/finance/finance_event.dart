part of 'finance_bloc.dart';

sealed class FinanceEvent extends Equatable {
  const FinanceEvent();
}

class GetMemberSavingAccounts extends FinanceEvent {
  const GetMemberSavingAccounts();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class GetMemberAccountBalance extends FinanceEvent {
  WithdrawAccountBalanceRequest request;
  GetMemberAccountBalance(this.request);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class GetWithdrawalHistoryEvent extends FinanceEvent {
  PaginationRequest request;
  GetWithdrawalHistoryEvent(this.request);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class RequestWithdrawEvent extends FinanceEvent {
  WithdrawalRequest request;
  RequestWithdrawEvent(this.request);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}