import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ucp/data/model/request/transactionRequest.dart';
import 'package:ucp/data/model/response/dashboardResponse.dart';
import 'package:ucp/data/model/response/defaultResponse.dart';
import 'package:ucp/data/model/response/transactionHistoryResponse.dart';
import 'package:ucp/data/repository/dashboardRepo.dart';

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
      emit(DashboardError(AppUtils.defaultErrorResponse(msg: e.toString())));
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
      emit(DashboardError(AppUtils.defaultErrorResponse(msg: e.toString())));
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
      emit(DashboardError(AppUtils.defaultErrorResponse(msg: e.toString())));
    }
  }
  initial(){
    emit(DashboardInitial());
  }
}
