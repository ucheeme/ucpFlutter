
import 'dart:convert';

import 'package:ucp/app/apiService/appUrl.dart';

import '../../app/apiService/apiService.dart';
import '../../app/apiService/apiStatus.dart';
import '../../utils/apputils.dart';
import '../model/response/defaultResponse.dart';

class DefaultRepository{

 UcpDefaultResponse? _errorResponse;
 UcpDefaultResponse? get errorResponse => _errorResponse;
  setErrorResponse(UcpDefaultResponse? value) {
    _errorResponse = value;
    if (value?.errors  != null){
      var res = jsonDecode(value!.errors[0]);
      if (res['errors'].isNotEmpty) {
        _errorResponse?.message =
        "${res.publicMessage} ";
      }else{
        if(value!.message.toLowerCase().contains("unauthenticated")){
          _errorResponse?.message = "Please Login again";
        }else {
          _errorResponse?.message = value!.message;
        }
      }
    }
  }

  handleErrorResponse(dynamic response) {
    if (response is Failure) {
      if (response.errorResponse is UcpDefaultResponse) {
        try {

          setErrorResponse(response.errorResponse as UcpDefaultResponse);
        }
        catch (e) {
          setErrorResponse(AppUtils.defaultErrorResponse(msg: e.toString()));
        }
      }else{
        setErrorResponse(AppUtils.defaultErrorResponse(msg: "error response is not a same type with DefaultApiResponse"));
      }
    }
    else if(response is ForbiddenAccess){
      setErrorResponse(AppUtils.defaultErrorResponse(msg: "Access denied"));
    }else if(response is UnExpectedError){
      setErrorResponse(AppUtils.defaultErrorResponse(msg: "Unplanned error"));
    }else if(response is NetWorkFailure){
      setErrorResponse(AppUtils.defaultErrorResponse(msg: "Network not available"));
    }
  }


  Object handleSuccessResponse(dynamic response) {
    if (response is UcpDefaultResponse) {
      var r = response;//defaultApiResponseFromJson(response.response as String);
      return r;
    }else{
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> postRequest(request, url, requiresToken, HttpMethods method) async {
    var response = await ApiService.makeApiCall(request, url,requireAccess: requiresToken, method: method,
        baseUrl: UCPUrls.baseUrl);
    print("this is the response: $response");
    if(response is Success) {
      var r = ucpDefaultResponseFromJson(response.response as String);
      return r;
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }

  Future<Object> postRequestImage(request, url, requiresToken, HttpMethods method) async {
    var response = await ApiService.uploadDoc(request, url,);
    print("this is the resposee: $response");
    if(response is Success) {
      var r = ucpDefaultResponseFromJson(response.response as String);
      return r;
    } else {
      handleErrorResponse(response);
      return errorResponse!;
    }
  }
}

// Future<bool> hasInternetConnection() async {
//   // Check if the device has internet permission
//   bool hasPermission = await InternetPermission.hasPermission();
//
//   if (!hasPermission) {
//     // Request internet permission
//     await InternetPermission.requestInternetPermission();
//     hasPermission = await InternetPermission.hasPermission();
//   }
//
//   if (hasPermission) {
//     // Check if the device is connected to the internet
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.mobile ||
//         connectivityResult == ConnectivityResult.wifi) {
//       return true;
//     }
//   }
//
//   return false;
// }