import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ucp/data/model/request/transactionRequest.dart';
import 'package:ucp/data/model/response/dashboardResponse.dart';
import 'package:ucp/data/model/response/defaultResponse.dart';
import 'package:ucp/data/model/response/transactionHistoryResponse.dart';
import 'package:ucp/data/repository/dashboardRepo.dart';

import '../../data/model/request/saveToAccount.dart';
import '../../data/model/response/listOfBankResponse.dart';
import '../../data/model/response/memberSavingAccount.dart';
import '../../data/model/response/paymentModeResponse.dart';
import '../../data/model/response/userAcctResponse.dart';
import '../../utils/apputils.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {

  DashboardRepository dashboardRepository = DashboardRepository();
  var errorObs = PublishSubject<String>();
  DashboardBloc(this.dashboardRepository) : super(DashboardInitial()) {
    on<DashboardEvent>((event, emit) {});
    on<GetDashboardDataEvent>((event,emit){handleGetDashboardDataEvent();});
    on<GetTransactionHistory>((event,emit){handleGetTransactionHistory(event);});
    on<GetUserAccountSummary>((event,emit){handleGetUserAccountSummary();});
    on<GetPaymentModes>((event,emit){handleGetPaymentModes();});
    on<GetListOfBank>((event,emit){handleGetListOfBank();});
    on<GetMemberSavingAccounts>((event,emit){handleGetMemberSavingAccounts();});
    on<SaveToAccountEvent>((event,emit){handleGetUserAccountSummary();});
  }
  void handleGetDashboardDataEvent()async{
    emit(DashboardIsLoading());
    try{
      final response = await dashboardRepository.getDashboardInfo();
      if (response is DashboardResponse) {
        emit(DashboardData(response));
        AppUtils.debug("success");
      }else{
        emit(DashboardError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(DashboardError(AppUtils.defaultErrorResponse(msg: "An Error Occurred")));
    }
  }


  void handleGetTransactionHistory(event)async{
    emit(DashboardIsLoading());
    try{
      final response = await dashboardRepository.getMemberTransactionHistorry(event.request);
      if (response is TransactionResponse) {
        emit(TransactionHistory(response));
        AppUtils.debug("success");
      }else{
        emit(DashboardError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(DashboardError(AppUtils.defaultErrorResponse(msg:"An Error Occurred")));
    }
  }
  void handleGetUserAccountSummary()async{
    emit(DashboardIsLoading());
    try{
      final response = await dashboardRepository.getUserAccountSummary();
      if (response is   List<UserAccounts>) {
        emit(AccountSummaryDetails(response));
        AppUtils.debug("success");
      }else{
        emit(DashboardError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(DashboardError(AppUtils.defaultErrorResponse(msg:"An Error Occurred")));
    }
  }
  void handleGetPaymentModes()async{
    emit(DashboardIsLoading());
    try{
      final response = await dashboardRepository.getPaymentMethods();
      if (response is   List<PaymentModes>) {
        emit(UcpPaymentModes(response));
        AppUtils.debug("success");
      }else{
        emit(DashboardError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(DashboardError(AppUtils.defaultErrorResponse(msg: "An Error Occurred")));
    }
  }
  void handleGetListOfBank()async{
    emit(DashboardIsLoading());
    try{
      final response = await dashboardRepository.getBanks();
      if (response is   List<ListOfBank>) {
        emit(UcpBanks(response));
        AppUtils.debug("success");
      }else{
        emit(DashboardError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(DashboardError(AppUtils.defaultErrorResponse(msg: "An Error Occurred")));
    }
  }
  void handleGetMemberSavingAccounts()async{
    emit(DashboardIsLoading());
    try{
      final response = await dashboardRepository.getMemberAccounts();
      if (response is   List<UserSavingAccounts>) {
        emit(MemberAccounts(response));
        AppUtils.debug("success");
      }else{
        emit(DashboardError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(DashboardError(AppUtils.defaultErrorResponse(msg:"An Error Occurred")));
    }
  }

  initial(){
    emit(DashboardInitial());
  }
}
