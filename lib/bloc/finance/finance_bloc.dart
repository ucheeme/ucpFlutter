import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ucp/data/model/request/withdrawalRequest.dart';
import 'package:ucp/data/model/response/loanProductResponse.dart';
import 'package:ucp/data/model/response/loanRequestBreakDown.dart';

import '../../data/model/response/defaultResponse.dart';
import '../../data/model/response/loanApplicationResponse.dart';
import '../../data/model/response/loanFrequencyResponse.dart';
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
    on<RequestRetirementEvent>((event,emit){handleRequestRetirementEvent(event);});
    on<GetRetirementHistory>((event,emit){handleGetRetirementHistory(event);});
    on<GetMemberSavingHistoryEvent>((event,emit){handleGetMemberSavingHistoryEvent(event);});
    on<GetAllLoanApplicationEvent>((event,emit){handleGetAllLoanApplicationEvent(event);});
    on<GetAllLoanProductsEvent>((event,emit){handleGetAllLoanProductsEvent();});
    on<GetAllLoanFrequenciesEvent>((event,emit){handleGetAllLoanFrequenciesEvent();});
    on<LoanRequestBreakdownEvent>((event,emit){handleLoanRequestBreakdownEvent(event);});
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
      emit(FinanceError(AppUtils.defaultErrorResponse(msg:"Something went wrong")));
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
      emit(FinanceError(AppUtils.defaultErrorResponse(msg:"Something went wrong")));
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
      emit(FinanceError(AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }
  void handleGetRetirementHistory(event)async{
    emit(FinanceIsLoading());
    try{
      final response = await financeRepository.getRetirementHistory(event.request);
      if (response is WithdrawTransaction) {
        emit(FinanceMemberRetirementHistory(response));
        AppUtils.debug("success");
      }else{
        emit(FinanceError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(FinanceError(AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }
  void handleGetMemberSavingHistoryEvent(event)async{
    emit(FinanceIsLoading());
    try{
      final response = await financeRepository.getSavingHistory(event.request);
      if (response is WithdrawTransaction) {
        emit(FinanceMemberSavingHistory(response));
        AppUtils.debug("success");
      }else{
        emit(FinanceError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(FinanceError(AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }
  void handleGetAllLoanApplicationEvent(event)async{
    emit(FinanceIsLoading());
    try{
      final response = await financeRepository.getAllLoanRequest(event.request);
      if (response is LoanRequestsList) {
        emit(AllMemberLoanApplicationsState(response));
        AppUtils.debug("success");
      }else{
        emit(FinanceError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(FinanceError(AppUtils.defaultErrorResponse(msg: "Something went wrong")));
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
      emit(FinanceError(AppUtils.defaultErrorResponse(msg:"Something went wrong")));
    }
  }
  void handleRequestRetirementEvent(event)async{
    emit(FinanceIsLoading());
    try{
      final response = await financeRepository.requestRetirement(event.request);
      if (response is UcpDefaultResponse && response.isSuccessful == true) {
        emit(FinanceRetirementRequestSent(response));
        AppUtils.debug("success");
      }else{
        emit(FinanceError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(FinanceError(AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }

  void handleGetAllLoanProductsEvent()async{
    emit(FinanceIsLoading());
    try{
      final response = await financeRepository.getAllLoanProducts();
      if (response is List<LoanProductList>) {
        emit(AllLoanProductsState(response));
        AppUtils.debug("success");
      }else{
        emit(FinanceError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(FinanceError(AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }

  void handleGetAllLoanFrequenciesEvent()async{
    emit(FinanceIsLoading());
    try{
      final response = await financeRepository.getAllLoanFrequencies();
      if (response is List<LoanFrequencyList>) {
        emit(AllLoanFrequenciesState(response));
        AppUtils.debug("success");
      }else{
        emit(FinanceError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(FinanceError(AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }

  void handleLoanRequestBreakdownEvent(event)async{
    emit(FinanceIsLoading());
    try{
      final response = await financeRepository.loanRequestBreakDown(event.request);
      if (response is List<LoanRequestBreakdownList>) {
        emit(LoanRequestBreakdownState(response));
        AppUtils.debug("success");
      }else{
        emit(FinanceError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      print(e);
      emit(FinanceError(AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }

  initial(){
    emit(FinanceInitial());
  }
}
