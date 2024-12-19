
import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:get/get.dart' as gettt;
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:ucp/data/model/response/defaultResponse.dart';

import '../../utils/apputils.dart';
import '../../utils/sharedPreference.dart';
import '../../view/errorPages/apierror.dart';
import 'apiResponseCodes.dart';
import 'apiStatus.dart';
enum HttpMethods { post, put, patch, get, delete }

class ApiService {
  static Dio dio = Dio();

  static void initiateDio(bool requireAccess, String baseUrl) {

    dio.options
      ..baseUrl = baseUrl
      ..validateStatus = (int? status) {
        return status != null && status > 0;
      }
      ..headers = header(requireAccess);
    dio.interceptors.add(
      LogInterceptor(
          requestBody: true,
          responseBody: true
      ),
    );
     dio.httpClientAdapter = DefaultHttpClientAdapter()
      ..onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true; // Bypass SSL check
        return client;
      };

  }

  static Map<String, String> header(bool requireAccess) {
    return requireAccess
        ? {
      HttpHeaders.userAgentHeader: 'dio',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'accept':' text/plain',
      'Authorization': 'Bearer $accessToken'
    }
        : {
      HttpHeaders.userAgentHeader: 'dio',
      'Content-Type': 'application/json',
      'Accept-Language': 'en-US,en;q=0.5',
      'Accept': 'application/json',
      'accept':' text/plain',
      'Connection':"keep-alive"
    };
  }

  static Future<Object> makeApiCall(request,url,
      {bool? isAdmin = false,
      bool requireAccess = true,
        HttpMethods method =  HttpMethods.post,
        required String baseUrl}) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('network error');
      return  NetWorkFailure();
    }
    initiateDio(requireAccess,  baseUrl);
    try {
      var body = request != null ? json.encode(request.toJson()) : null;
      Response<String>? response;
      switch (method) {
        case HttpMethods.post:
          response =  await dio.post(url, data: body);
          AppUtils.debug("method: post");
          break;
        case HttpMethods.put:
          response =  await dio.put(url, data: body);
          AppUtils.debug("method: put");
          break;
        case HttpMethods.patch:
          response =  await dio.patch(url, data: body);
          AppUtils.debug("method: patch");
          break;
        case HttpMethods.get:
          AppUtils.debug("trying a get request");
          if (request == null){
            response =  await dio.get(url);
          }else {
            print("req to send ${request.toJson}");
            response = await dio.get(url, queryParameters: request.toJson());
          }
          AppUtils.debug("method: get");
          break;
        case HttpMethods.delete:
          response =  await dio.delete(url, data: body);
          AppUtils.debug("method: delete");
          break;
      }
      if (response.statusCode != null) {
        AppUtils.debug("status code: ${response.statusCode}");
        AppUtils.debug("body: $body");
        if (response.statusCode == ApiResponseCodes.success ||
            response.statusCode == ApiResponseCodes.create_success ) {
          return Success(response.statusCode!,response.data as String);
        }
        if (  399 <= (response.statusCode ?? 400) && (response.statusCode ?? 400)  <= 500){
          if ( response.data is String ) {
            try {
              var apiRes = ucpDefaultResponseFromJson(response.data as String);
              return Failure(response.statusCode ?? 400,
                  (apiRes));
            }
            catch(e){
              print("error: $e");
            }
          }else {
            return ForbiddenAccess();
          }
        }
        if (ApiResponseCodes.authorizationError == response.statusCode){
          return ForbiddenAccess();
        }
        else{
          return  Failure(response.statusCode!,"Error Occurred");
        }
      }else{
        return  UnExpectedError();
      }
    } on DioError catch (e){
      AppUtils.debug(e.message);
      AppUtils.debug("Dio Error");
      gettt.Get.to(NoconnectionScreen(press: () {  },));
      return  NetWorkFailure();
    }
  }

  static Future<Object> uploadDoc(dynamic requestBody , String url, {String? docType}) async {
    try {
      var request = http.MultipartRequest(
        'POST', Uri.parse(url),

      );
      Map<String,String> headers={
        "Authorization":"Bearer $accessToken",
        "Content-type": "multipart/form-data"
      };
      request.files.add(
        http.MultipartFile(
          '',
          requestBody.documentFile!.readAsBytes().asStream(),
          requestBody.documentFile!.lengthSync(),
          filename: requestBody.documentCategory,
          // contentType: MediaType('image','jpeg'),
        ),
      );
      request.headers.addAll(headers);
      request.fields.addAll({
        "user_id":requestBody.userId!,
        "document_category":requestBody.documentCategory!,
      });
      print("request: "+request.toString());
      var res = await request.send();
      final response = await res.stream.bytesToString();
      AppUtils.debug("/****rest call response starts****/");
      AppUtils.debug("status code: ${res.statusCode}");
      AppUtils.debug("rest response: "+response);
      print("This is response:"+response.toString());

      AppUtils.debug("/****rest call request starts****/");
      AppUtils.debug("url: $url");
      AppUtils.debug("headers: $headers");
      AppUtils.debug("request body: ${request.fields}");
      // var res = await request.send();

      AppUtils.debug("/****rest call response starts****/");
      AppUtils.debug("status code: ${res.statusCode}");
      AppUtils.debug("rest response: $response");
      if (ApiResponseCodes.success == res.statusCode){
        return  Success(res.statusCode!,response);
      }
      if (ApiResponseCodes.error == res.statusCode || ApiResponseCodes.internalServerError == res.statusCode){
        return  Failure(res.statusCode,(ucpDefaultResponseFromJson( response)));
      }
      if (ApiResponseCodes.authorizationError == res.statusCode){
        return ForbiddenAccess();
      }
      else{
        return  Failure(res.statusCode!,"Error Occurred");
      }
    }on HttpException{
      return  NetWorkFailure();

    }on FormatException{
      return  UnExpectedError();

    }catch (e){
      return NetWorkFailure();
    }
  }

  Future<String?> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }

}
