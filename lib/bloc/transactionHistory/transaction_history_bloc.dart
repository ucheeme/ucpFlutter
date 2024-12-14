import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/model/request/transactionRequest.dart';
import '../../data/model/response/defaultResponse.dart';
import '../../data/model/response/transactionHistoryResponse.dart';
import '../../data/model/response/userAcctResponse.dart';
import '../../data/repository/dashboardRepo.dart';
import '../../utils/apputils.dart';

part 'transaction_history_event.dart';
part 'transaction_history_state.dart';

class TransactionHistoryBloc extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  DashboardRepository dashboardRepository = DashboardRepository();
  var errorObs = PublishSubject<String>();
  TransactionHistoryBloc(this.dashboardRepository) : super(TransactionHistoryInitial()) {
    on<TransactionHistoryEvent>((event, emit) {});
    on<GetTransactionHistory>((event,emit){handleGetTransactionHistory(event);});
    on<GetUserAccountSummary>((event,emit){handleGetUserAccountSummary();});
  }
  void handleGetTransactionHistory(event)async{
    emit(TransactionIsLoading());
    try{
      final response = await dashboardRepository.getMemberTransactionHistorry(event.request);
      if (response is TransactionResponse) {
        emit(TransactionHistory(response));
        AppUtils.debug("success");
      }else{
        emit(TransactionError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(TransactionError(AppUtils.defaultErrorResponse(msg: e.toString())));
    }
  }
  void handleGetUserAccountSummary()async{
    emit(TransactionIsLoading());
    try{
      final response = await dashboardRepository.getUserAccountSummary();
      if (response is   List<UserAccounts>) {
        emit(AccountSummaryDetails(response));
        AppUtils.debug("success");
      }else{
        emit(TransactionError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(TransactionError(AppUtils.defaultErrorResponse(msg: e.toString())));
    }
  }
  initial(){
    emit(TransactionHistoryInitial());
  }
}
