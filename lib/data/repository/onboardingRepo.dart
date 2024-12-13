import 'dart:convert';

import 'package:ucp/app/apiService/appUrl.dart';
import 'package:ucp/data/model/request/loginReq.dart';
import 'package:ucp/data/model/request/signUpReq.dart';
import 'package:ucp/data/model/response/loginResponse.dart';
import 'package:ucp/data/model/response/signUpResponse.dart';

import '../../app/apiService/apiService.dart';
import '../../app/apiService/apiStatus.dart';
import '../model/response/cooperativeList.dart';
import '../model/response/defaultResponse.dart';
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

  Future<Object> createAccount(SignupRequest request) async {
    print(request);
    print("Wowww");
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
}