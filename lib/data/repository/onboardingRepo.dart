import 'dart:convert';

import 'package:ucp/app/apiService/appUrl.dart';
import 'package:ucp/data/model/request/loginOtpRequest.dart';
import 'package:ucp/data/model/request/loginReq.dart';
import 'package:ucp/data/model/request/signUpReq.dart';
import 'package:ucp/data/model/request/signUpSendOtp.dart';
import 'package:ucp/data/model/response/checkCooperativePrivileges.dart';
import 'package:ucp/data/model/response/getMemberSignUpCost.dart';
import 'package:ucp/data/model/response/loginOtpValidationResponse.dart';
import 'package:ucp/data/model/response/loginResponse.dart';
import 'package:ucp/data/model/response/signUpResponse.dart';

import '../../app/apiService/apiService.dart';
import '../../app/apiService/apiStatus.dart';
import '../model/request/forgotPasswordRequest.dart';
import '../model/response/allCountries.dart';
import '../model/response/cooperativeList.dart';
import '../model/response/defaultResponse.dart';
import '../model/response/nextMemberIdResponse.dart';
import '../model/response/shopList.dart';
import '../model/response/statesInCountry.dart';
import 'defaultRepository.dart';

class OnboardingRepo extends DefaultRepository{
  Future<Object> getCooperatives() async {
    var response = await ApiService.makeApiCall(null, UCPUrls.getCooperative,requireAccess: false,
        method: HttpMethods.get,
        baseUrl: UCPUrls.baseUrl);
    print("this is the response: $response");
    if(response is Success) {
      List<CooperativeListResponse> res  = cooperativeListResponseFromJson(response.response as String);
      return res;
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> getAllCountries() async {
    var response = await ApiService.makeApiCall(null, UCPUrls.getUcpCountries,requireAccess: true,
        method: HttpMethods.get,
        baseUrl: UCPUrls.baseUrl);
    print("this is the response: $response");
    if(response is Success) {
      List<AllCountriesResponse> res  = allCountriesResponseFromJson(response.response as String);
      return res;
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> getAllStates(request) async {
    var response = await ApiService.makeApiCall(null, "${UCPUrls.getUcpStates}?countryCode=$request",requireAccess: true,
        method: HttpMethods.get,
        baseUrl: UCPUrls.baseUrl);
    print("this is the response: $response");
    if(response is Success) {
      List<AllStateResponse> res  = allStateResponseFromJson(response.response as String);
      return res;
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
  Future<Object> getAMembershipCpst(request) async {
    var response =  await postRequest(
      null, "${UCPUrls.getSignUpCost}?cooperativeId=$request",true, HttpMethods.get,);
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        MemberSignUpCost res  = memberSignUpCostFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> createAccount(SignupRequest request) async {
    var response = await postRequest(
      request, UCPUrls.createAccount, false, HttpMethods.post,);
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        SignUpResponse res = signUpResponseFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> loginUser(LoginRequest request) async {
    var response = await ApiService.makeApiCall(request, UCPUrls.loginMember,requireAccess: false,
        method: HttpMethods.post,
        baseUrl: UCPUrls.baseUrl);
    print("this is the response: $response");
    if(response is Success) {
      LoginResponse res  = loginResponseFromJson(response.response as String);
      return res;
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
  Future<Object> getMemberId(int request) async {
    var response = await postRequest(
      null, "${UCPUrls.getMemberId}?cooperativeId=$request", false, HttpMethods.get,);
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        NextMemberId res = nextMemberIdFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> getShopItems() async {
      var response = await postRequest(
        null,
        UCPUrls.getShopItems,
        true,
        HttpMethods.get,
      );
      var r = handleSuccessResponse(response);
      if (r is UcpDefaultResponse) {
        if (r.isSuccessful == true) {
          List<ShopItemList> res = shopItemListFromJson(json.encode(r.data));
          return res;
        } else {
          return r;
        }
      } else {
        handleErrorResponse(response);
        return errorResponse!;
      }
  }

  Future<Object> sendSignUpOTP(SignupOtpRequest request) async {
    var response = await postRequest(
      request, UCPUrls.getSignUpOtp, false, HttpMethods.post,);
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        OTPValidationResponse res = loginOtpValidationResponseFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
  Future<Object> sendLoginOtp(LoginSendOtpRequest request) async {
    var response = await postRequest(
      request, UCPUrls.getLoginOtp, false, HttpMethods.post,);
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        OTPValidationResponse res = loginOtpValidationResponseFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> forgotPasswordMember(ForgotPasswordRequest request) async {
    var response = await postRequest( request,UCPUrls.forgotPassword, false, HttpMethods.post,);
    var r = handleSuccessResponse(response);
    if(r is UcpDefaultResponse){
      if(r.isSuccessful == true){
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

  getCooperativePrivileges(String cooperativeId)async {
    var response = await postRequest(
      null, "${UCPUrls.checkCooperativePrivileges}?nodeId=$cooperativeId", true, HttpMethods.get,);
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        CheckIfCooperativeIsSetUpForElection res = checkIfCooperativeIsSetUpForElectionFromJson(json.encode(r.data));
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