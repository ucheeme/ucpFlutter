import 'dart:convert';

import 'package:ucp/data/model/response/allElections.dart';
import 'package:ucp/data/repository/defaultRepository.dart';
import 'package:ucp/data/repository/profileRepo.dart';

import '../../app/apiService/apiService.dart';
import '../../app/apiService/appUrl.dart';
import '../model/response/contestantInfo.dart';
import '../model/response/defaultResponse.dart';
import '../model/response/profileUpdateResponse.dart';
import 'FinanceRepo.dart';

class VoteRepository extends DefaultRepository {
  Future<Object> getEligiblePosition(PaginationRequest request) async {
    var response = await postRequest(
      null,
      "${UCPUrls.getAllEligiblePosition}?PageSize=${request.pageSize}&PageNumber=${request.currentPage}",
      true,
      HttpMethods.get,
    );
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        AllElections res = allElectionsFromJson(json.encode(r.data));
        return res;
      } else {
        return r;
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> applyAsACandidateForElection(request) async {
    var response = await postRequestImage2(
        filePath: ucpFilePath,
        filePath2: ucpFilePath2,
        url: UCPUrls.applyForPosition,
        requiresToken: true,
        imageFieldName: "ProfileImage",
        imageFieldName2: "ManifestoDocumentFile",
        formFields: request.toJson());
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      print("this is ${r.isSuccessful}");
      if (r.isSuccessful == true) {
        UcpDefaultResponse res = ucpDefaultResponseFromJson(json.encode(r));
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

  Future<Object> getAppliedMemberInfo(request) async {
    var response = await postRequest(
        null,
        "${UCPUrls.getAppliedMemberInfo}?electionId=${request.electionId}&positionId=${request.positionId}",
        true,
        HttpMethods.get);
    var r = handleSuccessResponse(response);
    if (r is UcpDefaultResponse) {
      if (r.isSuccessful == true) {
        ContestantInfoResponse res =
            contestantInfoFromJson(json.encode(r.data));
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
