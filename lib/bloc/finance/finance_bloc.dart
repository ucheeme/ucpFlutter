import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ucp/data/model/request/withdrawalRequest.dart';

import '../../data/model/response/defaultResponse.dart';
import '../../data/model/response/memberSavingAccount.dart';
import '../../data/model/response/withdrawBalanceInfo.dart';
import '../../data/model/response/withdrawTransactionHistory.dart';
import '../../data/repository/FinanceRepo.dart';
import '../../utils/appCustomClasses.dart';
import '../../utils/apputils.dart';

part 'finance_event.dart';
part 'finance_state.dart';

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  FinanceRepository financeRepository = FinanceRepository();
  var errorObs = PublishSubject<String>();
  FinanceBloc(this.financeRepository) : super(FinanceInitial()) {
    on<FinanceEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetMemberSavingAccounts>((event,emit){handleGetMemberSavingAccounts();});
    on<GetMemberAccountBalance>((event,emit){handleGetMemberAccountBalance(event);});
    on<GetWithdrawalHistoryEvent>((event,emit){handleGetWithdrawalHistoryEvent(event);});
    on<RequestWithdrawEvent>((event,emit){handleRequestWithdrawEvent(event);});
  }
  void handleGetMemberSavingAccounts()async{
    emit(FinanceIsLoading());
    try{
      final response = await financeRepository.getMemberAccounts();
      if (response is   List<UserSavingAccounts>) {
        emit(FinanceMemberAccounts(response));
        AppUtils.debug("success");
      }else{
        emit(FinanceError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(FinanceError(AppUtils.defaultErrorResponse(msg: e.toString())));
    }
  }
  void handleGetMemberAccountBalance(event)async{
    emit(FinanceIsLoading());
    try{
      final response = await financeRepository.getAccountBalance(event.request);
      if (response is WithdrawAccountBalanceInfo) {
        emit(FinanceMemberAccountBalance(response));
        AppUtils.debug("success");
      }else{
        emit(FinanceError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(FinanceError(AppUtils.defaultErrorResponse(msg: e.toString())));
    }
  }
  void handleGetWithdrawalHistoryEvent(event)async{
    emit(FinanceIsLoading());
    try{
      final response = await financeRepository.getWithdrawalHistory(event.request);
      if (response is WithdrawTransaction) {
        emit(FinanceMemberWithdrawalHistory(response));
        AppUtils.debug("success");
      }else{
        emit(FinanceError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(FinanceError(AppUtils.defaultErrorResponse(msg: e.toString())));
    }
  }
  void handleRequestWithdrawEvent(event)async{
    emit(FinanceIsLoading());
    try{
      final response = await financeRepository.makeWithdrawRequest(event.request);
      if (response is UcpDefaultResponse && response.isSuccessful == true) {
        emit(FinanceRequestWithdrawalSent(response));
        AppUtils.debug("success");
      }else{
        emit(FinanceError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(FinanceError(AppUtils.defaultErrorResponse(msg: e.toString())));
    }
  }



  initial(){
    emit(FinanceInitial());
  }
}
