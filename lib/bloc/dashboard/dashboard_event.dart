part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();
}
class GetDashboardDataEvent extends DashboardEvent{
  const GetDashboardDataEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class GetTransactionHistory extends DashboardEvent{
  TransactionRequest request;
   GetTransactionHistory(this.request);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetUserAccountSummary extends DashboardEvent {
  const GetUserAccountSummary();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}