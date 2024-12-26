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
class GetRetirementHistory extends FinanceEvent {
  PaginationRequest request;
  GetRetirementHistory(this.request);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class GetMemberSavingHistoryEvent extends FinanceEvent {
  PaginationRequest request;
  GetMemberSavingHistoryEvent(this.request);
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
class RequestRetirementEvent extends FinanceEvent {
  WithdrawalRequest request;
  RequestRetirementEvent(this.request);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}