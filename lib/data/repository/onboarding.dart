import 'dart:convert';

import 'package:ucp/app/apiService/appUrl.dart';

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


}