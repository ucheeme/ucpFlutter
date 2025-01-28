import 'dart:convert';

import 'package:ucp/data/model/response/loanFrequencyResponse.dart';
import 'package:ucp/data/model/response/loanRequestBreakDown.dart';
import 'package:ucp/data/model/response/usersLoans.dart';
import 'package:ucp/data/repository/defaultRepository.dart';
import 'package:ucp/utils/appCustomClasses.dart';

import '../../app/apiService/apiService.dart';
import '../../app/apiService/apiStatus.dart';
import '../../app/apiService/appUrl.dart';
import '../model/request/guarantorRequestDecision.dart';
import '../model/request/loanApplicationRequest.dart';
import '../model/request/withdrawalRequest.dart';
import '../model/response/allGuarantors.dart';
import '../model/response/defaultResponse.dart';
import '../model/response/guarantorRequestList.dart';
import '../model/response/loanApplicationResponse.dart';
import '../model/response/loanProductDetailsFI.dart';
import '../model/response/loanProductResponse.dart';
import '../model/response/loanScheduleForRefund.dart';
import '../model/response/memberSavingAccount.dart';
import '../model/response/withdrawBalanceInfo.dart';
import '../model/response/withdrawTransactionHistory.dart';

class FinanceRepository extends DefaultRepository{
  Future<Object> getMemberAccounts() async {
    var response = await postRequest(
      null,
      UCPUrls.getMemberAccountst,
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        List<UserSavingAccounts> res = userSavingAccountsFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> getAccountBalance(WithdrawAccountBalanceRequest request) async {
    var response = await postRequest(
      null,
      "${UCPUrls.getMemberWithdrawAccountDetail}?AccountNumber=${request.accountNumber}&AccountProduct=${request.accountName}",
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        WithdrawAccountBalanceInfo res = withdrawAccountBalanceInfoFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
  Future<Object> getWithdrawalHistory(PaginationRequest request) async {
    var response = await postRequest(
      null,
      "${UCPUrls.getWithdrawHistory}?PageSize=${request.pageSize}&PageNumber=${request.currentPage}",
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        WithdrawTransaction res = withdrawTransactionFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
  Future<Object> getRetirementHistory(PaginationRequest request) async {
    var response = await postRequest(
      null,
      "${UCPUrls.getRetirementHistory}?PageSize=${request.pageSize}&PageNumber=${request.currentPage}",
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        WithdrawTransaction res = withdrawTransactionFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
  Future<Object> getSavingHistory(PaginationRequest request) async {
    var response = await postRequest(
      null,
      "${UCPUrls.getSavingHistory}?PageSize=${request.pageSize}&PageNumber=${request.currentPage}",
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        WithdrawTransaction res = withdrawTransactionFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
  Future<Object> getAllLoanRequest(PaginationRequest request) async {
    var response = await postRequest(
      null,
      "${UCPUrls.getAllLoanApplications}?PageSize=${request.pageSize}&PageNumber=${request.currentPage}",
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        LoanRequestsList res = loanRequestsListFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
  Future<Object> getAllLoanProducts() async {
    var response = await postRequest(
      null,
      UCPUrls.getAllLoanProducts,
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        List<LoanProductList> res = loanProductListFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> getAllLoanFrequencies() async {
    var response = await ApiService.makeApiCall(null, UCPUrls.getAllLoanFrequencies,requireAccess: true,
        method: HttpMethods.get,
        baseUrl: UCPUrls.baseUrl);
    print("this is the response: $response");
    if(response is Success) {
      List<LoanFrequencyList> res  = loanFrequencyListFromJson(response.response as String);
      return res;
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }


  Future<Object> makeWithdrawRequest(WithdrawalRequest request) async {
    var response = await postRequest(
      request,
      UCPUrls.withdrawRequest,
      true,
      HttpMethods.post,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        UcpDefaultResponse res = ucpDefaultResponseFromJson(json.encode(r));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
  Future<Object> requestRetirement(WithdrawalRequest request) async {
    var response = await postRequest(
      request,
      UCPUrls.retirementRequest,
      true,
      HttpMethods.post,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        UcpDefaultResponse res = ucpDefaultResponseFromJson(json.encode(r));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
  Future<Object> loanRequestBreakDown(LoanRequestBreakdownRequestBody request) async {
    var response = await postRequest(
      null,
      "${UCPUrls.getLoanSchedule}?LoanProduct=${request.loanProdCode}&LoanAmount=${request.loanAmount}&Tenor=${request.loanTenor}&Frequency=${request.loanFrequency}&InterestRate=${request.loanInterest}",
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        List<LoanRequestBreakdownList> res = loanRequestBreakdownListFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
  Future<Object> loanFrequencyInterestForProduct(String request) async {
    var response = await postRequest(
      null,
      "${UCPUrls.getLoanFrequencyForProduct}?ProductCode=${request}",
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        LoanProductDetail res = loanProductDetailFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> getAllLoanGuarantors()async{
    var response = await postRequest(null,UCPUrls.getAllGurantors,true,HttpMethods.get);
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        List<LoanGuantorsList>res = loanGuantorsListFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> applyForLoan(LoanApplicationRequest request)async{
    var response = await postRequest(request,UCPUrls.applyForLoan,true,HttpMethods.post);
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        UcpDefaultResponse res = ucpDefaultResponseFromJson(json.encode(r));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> getAllUserLoans( request)async{
    var response = await postRequest(null,"${UCPUrls.getAllUserLoans}?PageSize=${request.pageSize}&PageNumber=${request.currentPage}",true,HttpMethods.get);
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        UserLoansResponse res = userLoansResponseFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }

  }

  Future<Object> getLoanScheduleBreakdown(String request)async{
    var response = await postRequest(null,"${UCPUrls.getLoanRefundSchedule}?loanAccountNumber=$request",true,HttpMethods.get);
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        List<LoanScheduleForRefundResponse> res = loanScheduleForRefundResponseFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> getAllLoanGuarantorRequest(PaginationRequest request)async{
    var response = await postRequest(
      null,
      "${UCPUrls.getAllLoanGuarantorsRequest}?PageSize=${request.pageSize}&PageNumber=${request.currentPage}",
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        GuarantorRequestList res = guarantorRequestListFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
  Future<Object> acceptRequest(GuarantorRequestDecision request)async{
    var response = await postRequest(
      request,
      UCPUrls.guarantorAcceptRequest,
      true,
      HttpMethods.post,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        UcpDefaultResponse res = ucpDefaultResponseFromJson(json.encode(r));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
  Future<Object> rejectRequest(GuarantorRequestDecision request)async{
    var response = await postRequest(
      request,
      UCPUrls.guarantorRejectRequest,
      true,
      HttpMethods.post,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        UcpDefaultResponse res = ucpDefaultResponseFromJson(json.encode(r));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
}

class PaginationRequest {
  int currentPage;
  int pageSize;
  String? addOns;
  PaginationRequest({
    required this.currentPage,
    required this.pageSize,
    this.addOns});
}

class LoanRequestBreakdownRequestBody{
  String loanProdCode;
  dynamic loanAmount;
  String loanTenor;
  String loanFrequency;
  dynamic loanInterest;
  LoanRequestBreakdownRequestBody({required this.loanProdCode,required this.loanAmount,required this.loanTenor,required this.loanFrequency,required this.loanInterest});
}