import 'dart:convert';

import 'package:ucp/bloc/dashboard/dashboard_bloc.dart';
import 'package:ucp/data/model/request/saveToAccount.dart';
import 'package:ucp/data/model/response/dashboardResponse.dart';
import 'package:ucp/data/model/response/listOfBankResponse.dart';
import 'package:ucp/data/model/response/notificationResponse.dart';
import 'package:ucp/data/model/response/transactionHistoryResponse.dart';
import 'package:ucp/data/repository/defaultRepository.dart';
import 'package:ucp/data/repository/profileRepo.dart';

import '../../app/apiService/apiService.dart';
import '../../app/apiService/apiStatus.dart';
import '../../app/apiService/appUrl.dart';
import '../model/request/signUpReq.dart';
import '../model/request/transactionRequest.dart';
import '../model/response/cooperativeList.dart';
import '../model/response/defaultResponse.dart';
import '../model/response/memberImageResponse.dart';
import '../model/response/memberSavingAccount.dart';
import '../model/response/memberTransactionHistory.dart';
import '../model/response/paymentModeResponse.dart';
import '../model/response/paymentResponse.dart';
import '../model/response/signUpResponse.dart';
import '../model/response/userAcctResponse.dart';

class DashboardRepository extends DefaultRepository {
  Future<Object> getCooperatives() async {
    var response = await ApiService.makeApiCall(null, UCPUrls.getCooperative,
        requireAccess: false,
        method: HttpMethods.get,
        baseUrl: UCPUrls.baseUrl);
    print("this is the response: $response");
    if (response is Success) {
      List<CooperativeListResponse> res =
          cooperativeListResponseFromJson(response.response as String);
      return res;
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> getMemberNotificationss() async {
    var response = await ApiService.makeApiCall(null, UCPUrls.getNotifications,
        requireAccess: true,
        method: HttpMethods.get,
        baseUrl: UCPUrls.baseUrl);
    print("this is the response: $response");
    if (response is Success) {
      List<UcpNotification> res =
          ucpNotificationFromJson(response.response as String);
      return res;
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> clearMemberNotifications() async {
    var response = await ApiService.makeApiCall(null, UCPUrls.clearNotifications,
        requireAccess: true,
        method: HttpMethods.post,
        baseUrl: UCPUrls.baseUrl);
    print("this is the response: $response");
    if (response is Success) {
      if(response.code==200){
        return UcpDefaultResponse(isSuccessful: true, message: "Notification cleared", errors: [], statusCode: 200, data:null);
      }else{
        return UcpDefaultResponse(isSuccessful: false, message: "Notification not cleared", errors: [], statusCode: 200, data:null);
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> notificationRead(String notificationId) async {
    var response = await ApiService.makeApiCall(null, "${UCPUrls.readNotification}$notificationId/read",
        requireAccess: true,
        method: HttpMethods.post,
        baseUrl: UCPUrls.baseUrl);
    print("this is the response: $response");
    if (response is Success) {
      if(response.code==200){
        return UcpDefaultResponse(isSuccessful: true, message: "Notification Read", errors: [], statusCode: 200, data:null);
      }else{
        return UcpDefaultResponse(isSuccessful: false, message: "Failed to read notification", errors: [], statusCode: 200, data:null);
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }


  Future<Object> getMemberImage() async {
    var response = await postRequest(
      null, UCPUrls.getMemberImage,
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        MemberImageResponse res =
        memberImageResponseFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }

  }

  Future<Object> getMemberTransactionHistorry(
      TransactionRequest request) async {
    print(request);
    var response = await postRequest(
      null,
      "${UCPUrls.getTransactionHistory}?PageSize=${request.pageSize}&PageNumber=${request.pageNumber}&Month=${request.month}&AccountNumber=${request.acctNumber}",
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        TransactionResponse res =
            transactionResponseFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> getDashboardInfo() async {
    var response = await postRequest(
      null,
      UCPUrls.getDashboardData,
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        DashboardResponse res = dashboardResponseFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
  Future<Object> getUserAccountSummary() async {
    var response = await postRequest(
      null,
      UCPUrls.getCustomerAccounts,
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        List<UserAccounts> res = userAccountsFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
  Future<Object> getBanks() async {
    var response = await ApiService.makeApiCall(null, UCPUrls.getBankList,
        requireAccess: true,
        method: HttpMethods.get,
        baseUrl: UCPUrls.baseUrl);
    print("this is the response: $response");
    if (response is Success) {
      List<ListOfBank> res =
      listOfBankFromJson(response.response as String);
      return res;
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

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

  Future<Object> getPaymentMethods() async {
    var response = await postRequest(
      null,
      UCPUrls.getPaymentMode,
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        List<PaymentModes> res = paymentModesFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
  Future<Object> getLoanPaymentMethod() async {
    var response = await postRequest(
      null,
      UCPUrls.getLoanPaymentMode,
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        List<PaymentModes> res = paymentModesFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
  Future<Object> makePayment(PaymentRequest request)async{
    var response = await postRequestImage(filePath: ucpFilePath,
        url:UCPUrls.processPayment, requiresToken: true,
        imageFieldName:"UploadTeller" ,formFields: request.toJson());
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        PaymentSuccessfulResponse res = paymentSuccessfulResponseFromJson(json.encode(r.data));
        return res;
      } else {
        print("This is me,${r.message}");
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  getMemberTransactions(MemberTransactionRequest request)async{
    var response = await postRequest(
      null,
      "${UCPUrls.getMemberTransactionHistory}?StartDate=${request.startDate}"
          "&EndDate=${request.endDate}&ReportOption=${request.reportOption}"
          "&GlobalStatement=${request.globalStatement}",
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        List<MemberTransactionReport> res =
        memberTransactionReportFromJson(json.encode(r.data));
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
