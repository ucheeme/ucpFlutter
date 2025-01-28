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

class GetAllLoanApplicationEvent extends FinanceEvent{
  PaginationRequest request;
  GetAllLoanApplicationEvent(this.request);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class GetAllLoanProductsEvent extends FinanceEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetAllLoanFrequenciesEvent extends FinanceEvent{
 const GetAllLoanFrequenciesEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
} //GetAllLoanFrequencies

class LoanRequestBreakdownEvent extends FinanceEvent{
  LoanRequestBreakdownRequestBody request;
  LoanRequestBreakdownEvent(this.request);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetLoanFrequencyForProductEvent extends FinanceEvent{
  String request;
  GetLoanFrequencyForProductEvent(this.request);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetAllGuarantorsEvent extends FinanceEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ApplyForLoanEvent extends FinanceEvent{
  LoanApplicationRequest request;
  ApplyForLoanEvent(this.request);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DoneApplicationEvent extends FinanceEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetAllUserLoansEvent extends FinanceEvent {
  PaginationRequest request;
  GetAllUserLoansEvent(this.request);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetLoanScheduleBreakdownEvent extends FinanceEvent{
  String request;
  GetLoanScheduleBreakdownEvent(this.request);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetAllLoanGuarantorsRequestEvent extends FinanceEvent{
  PaginationRequest request;
  GetAllLoanGuarantorsRequestEvent(this.request);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GuarantorAcceptRequestEvent extends FinanceEvent{
  GuarantorRequestDecision request;
  GuarantorAcceptRequestEvent(this.request);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GuarantorRejectRequestEvent extends FinanceEvent{
  GuarantorRequestDecision request;
  GuarantorRejectRequestEvent(this.request);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
