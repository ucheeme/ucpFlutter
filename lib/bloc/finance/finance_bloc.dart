import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ucp/data/model/request/withdrawalRequest.dart';
import 'package:ucp/data/model/response/loanProductResponse.dart';
import 'package:ucp/data/model/response/loanRequestBreakDown.dart';

import '../../data/model/request/guarantorRequestDecision.dart';
import '../../data/model/request/loanApplicationRequest.dart';
import '../../data/model/response/allGuarantors.dart';
import '../../data/model/response/defaultResponse.dart';
import '../../data/model/response/guarantorRequestList.dart';
import '../../data/model/response/loanApplicationResponse.dart';
import '../../data/model/response/loanFrequencyResponse.dart';
import '../../data/model/response/loanProductDetailsFI.dart';
import '../../data/model/response/loanScheduleForRefund.dart';
import '../../data/model/response/memberSavingAccount.dart';
import '../../data/model/response/usersLoans.dart';
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
    on<GetLoanFrequencyForProductEvent>((event,emit){handleGetLoanFrequencyForProductEvent(event);});
    on<GetAllGuarantorsEvent>((event,emit){handleGetAllGuarantorsEvent(event);});
    on<ApplyForLoanEvent>((event,emit){handleApplyForLoanEvent(event);});
    on<DoneApplicationEvent>((event,emit){handleDoneApplicationEvent(event);});
    on<GetAllUserLoansEvent>((event,emit){handleGetAllUserLoansEvent(event);});
    on<GetLoanScheduleBreakdownEvent>((event,emit){handleGetLoanScheduleBreakdownEvent(event);});
    on<GetAllLoanGuarantorsRequestEvent>((event,emit){handleGetAllLoanGuarantorsEvent(event);});
    on<GuarantorAcceptRequestEvent>((event,emit){handleGuarantorAcceptRequestEvent(event);});
    on<GuarantorRejectRequestEvent>((event,emit){handleGuarantorRejectRequestEvent(event);});
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
  void handleGetLoanFrequencyForProductEvent(event)async{
    emit(FinanceIsLoading());
    try{
      final response = await financeRepository.loanFrequencyInterestForProduct(event.request);
      if (response is LoanProductDetail) {
        emit(LoanFrequencyInterestState(response));
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

  void handleGetAllGuarantorsEvent(event)async {
    emit(FinanceIsLoading());
    try {
      final response = await financeRepository.getAllLoanGuarantors();
      if (response is List<LoanGuantorsList>) {
        emit(AllLoanGuarantorsState(response));
        AppUtils.debug("success");
      } else {
        emit(FinanceError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    } catch (e, trace) {
      print(trace);
      emit(FinanceError(
          AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }
  initial(){
    emit(FinanceInitial());
  }

  void handleApplyForLoanEvent(ApplyForLoanEvent event)async {
    emit(FinanceIsLoading());
    try {
      final response = await financeRepository.applyForLoan(event.request);
      if (response is UcpDefaultResponse) {
        emit(LoanApplicationState(response));
        AppUtils.debug("success");
      } else {
        emit(FinanceError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    } catch (e, trace) {
      print(trace);
      emit(FinanceError(
          AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }

  void handleDoneApplicationEvent(DoneApplicationEvent event) {
    emit(LoanApplicationCompletedState());
  }

  void handleGetAllUserLoansEvent(GetAllUserLoansEvent event)async {
    emit(FinanceIsLoading());
    try {
      final response = await financeRepository.getAllUserLoans(event.request);
      if (response is UserLoansResponse) {
        emit(AllUserLoansState(response));
        AppUtils.debug("success");
      } else {
        emit(FinanceError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    } catch (e, trace) {
      print(trace);
      emit(FinanceError(
          AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }

  void handleGetLoanScheduleBreakdownEvent(event)async{
    emit(FinanceIsLoading());
    try{
      final response = await financeRepository.getLoanScheduleBreakdown(event.request);
      if (response is List<LoanScheduleForRefundResponse>) {
        emit(LoanRefundScheduleBreakdownState(response));
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

  void handleGetAllLoanGuarantorsEvent(GetAllLoanGuarantorsRequestEvent event)async{
    emit(FinanceIsLoading());
    try{
      final response = await financeRepository.getAllLoanGuarantorRequest(event.request);
      if (response is GuarantorRequestList) {
        emit(LoanGuarantorRequestState(response));
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
  void handleGuarantorAcceptRequestEvent( event)async{
    emit(FinanceIsLoading());
    try{
      final response = await financeRepository.acceptRequest(event.request);
      if (response is UcpDefaultResponse && response.isSuccessful == true) {
        emit(FinanceGuarantorAccepted(response));
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
  void handleGuarantorRejectRequestEvent( event)async{
    emit(FinanceIsLoading());
    try{
      final response = await financeRepository.acceptRequest(event.request);
      if (response is UcpDefaultResponse && response.isSuccessful == true) {
        emit(FinanceGuarantorRejected(response));
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

}


