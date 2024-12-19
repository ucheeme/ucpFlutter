part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();
}

final class DashboardInitial extends DashboardState {
  @override
  List<Object> get props => [];
}
class DashboardIsLoading extends DashboardState{
  @override
  List<Object> get props => [];
}

class DashboardError extends DashboardState{
  UcpDefaultResponse errorResponse;
  DashboardError(this.errorResponse);
  @override
  List<Object> get props => [errorResponse];
}

class DashboardData extends DashboardState{
  DashboardResponse response;
  DashboardData(this.response);
  @override
  List<Object> get props => [response];
}

class TransactionHistory extends DashboardState{
  TransactionResponse response;
  TransactionHistory(this.response);
  @override
  List<Object> get props => [response];
}

class AccountSummaryDetails extends DashboardState{
  List<UserAccounts> response;
  AccountSummaryDetails(this.response);
  @override
  List<Object> get props => [response];
}

class MemberAccounts extends DashboardState{
  List<UserSavingAccounts> response;
  MemberAccounts(this.response);
  @override
  List<Object> get props => [response];
}

class UcpPaymentModes extends DashboardState{
  List<PaymentModes> response;
  UcpPaymentModes(this.response);
  @override
  List<Object> get props => [response];
}

class UcpBanks extends DashboardState{
  List<ListOfBank> response;
  UcpBanks(this.response);
  @override
  List<Object> get props => [response];
}