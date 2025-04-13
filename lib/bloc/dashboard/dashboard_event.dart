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

class GetMemberSavingAccounts extends DashboardEvent {
  const GetMemberSavingAccounts();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetListOfBank extends DashboardEvent {
  const GetListOfBank();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class GetPaymentModes extends DashboardEvent {
  const GetPaymentModes();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetLoanPaymentMethods extends DashboardEvent {
  const GetLoanPaymentMethods();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class MakePaymentEvent extends DashboardEvent{
  PaymentRequest request;
  MakePaymentEvent(this.request);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetMemberImage extends DashboardEvent{
  const GetMemberImage();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetMemberNotifications extends DashboardEvent{
  const GetMemberNotifications();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ClearMemberNotifications extends DashboardEvent{
  const ClearMemberNotifications();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class NotificationReadEvent extends DashboardEvent{
  String notificationId;
  NotificationReadEvent(this.notificationId);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class GetMemberTransactions extends DashboardEvent{
  MemberTransactionRequest request;
   GetMemberTransactions(this.request);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MemberTransactionRequest{
  String startDate;
  String endDate;
  bool globalStatement;
  String reportOption;
  MemberTransactionRequest(
      this.globalStatement,this.reportOption,this.startDate,this.endDate);
}