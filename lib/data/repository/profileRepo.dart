import 'dart:convert';

import 'package:ucp/data/repository/defaultRepository.dart';

import '../../app/apiService/apiService.dart';
import '../../app/apiService/appUrl.dart';
import '../model/response/defaultResponse.dart';
import '../model/response/memberData.dart';
import '../model/response/withdrawTransactionHistory.dart';
import 'FinanceRepo.dart';

class ProfileRepository extends DefaultRepository{
  Future<Object> getMemberProfile() async {
    var response = await postRequest(
      null,
      UCPUrls.getMemberProfile,
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        MemberProfileData res = memberProfileDataFromJson(json.encode(r.data));
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