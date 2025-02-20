import 'dart:convert';

import 'package:ucp/data/repository/defaultRepository.dart';

import '../../app/apiService/apiService.dart';
import '../../app/apiService/appUrl.dart';
import '../model/request/updateProfileRequest.dart';
import '../model/response/defaultResponse.dart';
import '../model/response/memberData.dart';
import '../model/response/memberSavingAccount.dart';
import '../model/response/memberSavingAccounts.dart';
import '../model/response/profileUpdateResponse.dart';
import '../model/response/withdrawTransactionHistory.dart';
import 'FinanceRepo.dart';
String? ucpFilePath ;
String? ucpFilePath2 ;
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

  Future<Object> updateUserProfile(UpdateProfileRequest request)async{
    var response = await postRequestImage(filePath: ucpFilePath,
        url:UCPUrls.updateProfileDetails, requiresToken: true,
        imageFieldName:"MemberImage" ,formFields: request.toJson());
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      print("this is ${r.isSuccessful}");
      if (r.isSuccessful == true) {
        ProfileUpdateResponse res = profileUpdateResponseFromJson(json.encode(r.data));
        return res;
      } else {
        print("This is me 222");
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> changePassword(request)async{
    var response = await postRequest(
      request,
      UCPUrls.changePassword,
      true,
      HttpMethods.post,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        ProfileUpdateResponse res = profileUpdateResponseFromJson(json.encode(r.data));
        return r;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object>getMemberSavingAccounts()async{
    var response = await postRequest(
      null,
      UCPUrls.getAllMemberSavingAcct,
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        List<MemberSavingAccounts> res = memberSavingAccountsFromJson(json.encode(r.data));
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