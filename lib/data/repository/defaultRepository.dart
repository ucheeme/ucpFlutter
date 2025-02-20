import 'dart:convert';

import '../../app/apiService/apiService.dart';
import '../../app/apiService/apiStatus.dart';
import '../../app/apiService/appUrl.dart';
import '../../utils/apputils.dart';
import '../model/response/defaultResponse.dart';

class DefaultRepository {
  UcpDefaultResponse? _errorResponse;
  UcpDefaultResponse? get errorResponse => _errorResponse;

  void setErrorResponse(dynamic value) {
    _errorResponse = value is UcpDefaultResponse ? value : null;

    if (value?.errors != null && value.errors.isNotEmpty) {
      print("this is the error: ${value.errors[0]}");
      try {
        var res = jsonDecode(value.errors[0]);
        if (res['errors']?.isNotEmpty == true) {
          _errorResponse?.message = "${res['errors'][0]['message']}";
        } else {
          _errorResponse?.message = value.message;
        }
      } catch (e,trace) {
        print("Developer Error Detail: $trace");
        _errorResponse?.message = "Error occurred:";
      }
    } else if (value?.message?.toLowerCase().contains("unauthenticated") == true) {
      _errorResponse?.message = "Please Login again";
    } else {
      _errorResponse?.message = value?.message ?? "An unknown error occurred";
    }
  }

  void handleErrorResponse(dynamic response) {
    if (response is Failure) {
      if (response.errorResponse is UcpDefaultResponse) {
        try {
          setErrorResponse(response.errorResponse as UcpDefaultResponse);
        } catch (e) {
          setErrorResponse(response.errorResponse);
        }
      } else {
        setErrorResponse(AppUtils.defaultErrorResponse(
          msg: "Error response is not of type UcpDefaultResponse",
        ));
      }
    } else if (response is ForbiddenAccess) {
      setErrorResponse(AppUtils.defaultErrorResponse(msg: "Access denied"));
    } else if (response is UnExpectedError) {
      setErrorResponse(AppUtils.defaultErrorResponse(msg: "Unplanned error"));
    } else if (response is NetWorkFailure) {
      setErrorResponse(AppUtils.defaultErrorResponse(msg: "Network not available"));
    } else {
      // Handle generic responses with unknown structure
      try {
        setErrorResponse(AppUtils.defaultErrorResponse(
          msg: jsonDecode(response.toString())['message'] ??
              "An unknown error occurred",
        ));
      } catch (e) {
        setErrorResponse(AppUtils.defaultErrorResponse(msg: response.toString()));
      }
    }
  }

  Object handleSuccessResponse(dynamic response) {
    if (response is UcpDefaultResponse) {
      return response;
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> postRequest(
      dynamic request, String url, bool requiresToken, HttpMethods method) async {
    var response = await ApiService.makeApiCall(
      request,
      url,
      requireAccess: requiresToken,
      method: method,
      baseUrl: UCPUrls.baseUrl,
    );
    print("Response: $response");

    if (response is Success) {
      try {
        return ucpDefaultResponseFromJson(response.response as String);
      } catch (e) {
        return response.response; // Return raw response for unknown formats
      }
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> postRequestImage({
      String? filePath, String url="", bool requiresToken=true,String imageFieldName="", Map<String, dynamic> formFields = const {},})
  async {
    var response = await ApiService.uploadFile(url: url, filePath: filePath,
        fileFieldName:imageFieldName, requireAccess: requiresToken,formFields:formFields );
    print("Response: $response");

    if (response is Success) {
      String result = jsonEncode(response.response);
      try {

        return ucpDefaultResponseFromJson(result);
      } catch (e,trace) {
        print(e);
        print(trace);
        print("Developer Error Detail: $trace");
        return response.response; // Return raw response for unknown formats
      }
    } else {

      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> postRequestImage2({
    String? filePath,String? filePath2,
    String url="", bool requiresToken=true,
    String imageFieldName="",String imageFieldName2="",
    Map<String, dynamic> formFields = const {},})
  async {
    var response = await ApiService.upLoad2DiffFiles(
        url: url,
        contestantPhotoPath: filePath,
        manifestoPlanDocPath: filePath2,
        photofileFieldName:imageFieldName,
        manifestofileFieldName:imageFieldName2,
        requireAccess: requiresToken,
        formFields:formFields );
    print("Response: $response");

    if (response is Success) {
      String result = jsonEncode(response.response);
      try {

        return ucpDefaultResponseFromJson(result);
      } catch (e,trace) {
        print(e);
        print(trace);
        print("Developer Error Detail: $trace");
        return response.response; // Return raw response for unknown formats
      }
    } else {

      handleErrorResponse(response);
      return errorResponse!;
    }
  }

}
