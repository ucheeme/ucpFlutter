import 'dart:convert';

import 'package:ucp/data/repository/defaultRepository.dart';
import 'package:ucp/utils/appCustomClasses.dart';

import '../../app/apiService/apiService.dart';
import '../../app/apiService/appUrl.dart';
import '../model/request/withdrawalRequest.dart';
import '../model/response/defaultResponse.dart';
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

}

class PaginationRequest {
  int currentPage;
  int pageSize;
  PaginationRequest({required this.currentPage, required this.pageSize});
}