part of 'finance_bloc.dart';

sealed class FinanceState extends Equatable {
  const FinanceState();
}

final class FinanceInitial extends FinanceState {
  @override
  List<Object> get props => [];
}


class FinanceIsLoading extends FinanceState{
  @override
  List<Object> get props => [];
}

class FinanceError extends FinanceState{
  UcpDefaultResponse errorResponse;
  FinanceError(this.errorResponse);
  @override
  List<Object> get props => [errorResponse];
}

class FinanceMemberAccounts extends FinanceState {
  List<UserSavingAccounts> memberAccountsList;
  FinanceMemberAccounts(this.memberAccountsList);
  @override
  List<Object> get props => [memberAccountsList];
}

class FinanceMemberAccountBalance extends FinanceState {
  WithdrawAccountBalanceInfo withdrawAccountBalanceInfo;
  FinanceMemberAccountBalance(this.withdrawAccountBalanceInfo);
  @override
  List<Object> get props => [withdrawAccountBalanceInfo];
}

class FinanceMemberWithdrawalHistory extends FinanceState {
  WithdrawTransaction response;
  FinanceMemberWithdrawalHistory(this.response);
  @override
  List<Object> get props => [response];
}
class FinanceMemberSavingHistory extends FinanceState {
  WithdrawTransaction response;
  FinanceMemberSavingHistory(this.response);
  @override
  List<Object> get props => [response];
}

class FinanceRequestWithdrawalSent extends FinanceState {
  UcpDefaultResponse response;
  FinanceRequestWithdrawalSent(this.response);
  @override
  List<Object> get props => [response];
}
class FinanceRetirementRequestSent extends FinanceState {
  UcpDefaultResponse response;
  FinanceRetirementRequestSent(this.response);
  @override
  List<Object> get props => [response];
}

class FinanceMemberRetirementHistory extends FinanceState {
  WithdrawTransaction response;
  FinanceMemberRetirementHistory(this.response);
  @override
  List<Object> get props => [response];
}

class AllMemberLoanApplicationsState extends FinanceState{
  LoanRequestsList response;
  AllMemberLoanApplicationsState(this.response);
  @override
  List<Object> get props => [response];
}

class AllLoanProductsState extends FinanceState{
  List<LoanProductList> response;
  AllLoanProductsState(this.response);
  @override
  List<Object> get props => [response];
}
class AllLoanFrequenciesState extends FinanceState{
  List<LoanFrequencyList> response;
  AllLoanFrequenciesState(this.response);
  @override
  List<Object> get props => [response];
}

class LoanRequestBreakdownState extends FinanceState{
  List<LoanRequestBreakdownList> response;
  LoanRequestBreakdownState(this.response);
  @override
  List<Object> get props => [response];
}