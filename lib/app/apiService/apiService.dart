
import 'dart:convert';
import 'dart:io';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' as gettt;
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:ucp/data/model/response/defaultResponse.dart';

import '../../utils/apputils.dart';
import '../../utils/designUtils/reusableFunctions.dart';
import '../../utils/sharedPreference.dart';
import '../../view/errorPages/apierror.dart';
import '../../view/mainUi/onBoardingFlow/loginFlow/loginD.dart';
import 'apiResponseCodes.dart';
import 'apiStatus.dart';
enum HttpMethods { post, put, patch, get, delete }
UcpDefaultResponse defaultResponse = UcpDefaultResponse(isSuccessful: false, message: "Error", errors: [], statusCode: 01, data: "");
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

  static Future<Object> makeApiCall(
      request,
      String url, {
        bool? isAdmin = false,
        bool requireAccess = true,
        HttpMethods method = HttpMethods.post,
        required String baseUrl,
      }) async {
    try {
      // Check internet connection
      final result = await InternetAddress.lookup('example.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        print('Network error');
        gettt.Get.to(NoconnectionScreen(press: () => gettt.Get.back()));
        return NetWorkFailure();
      }
      print('Connected');

      // Initialize Dio
      initiateDio(requireAccess, baseUrl);

      var body = request != null ? json.encode(request.toJson()) : null;
      Response<String>? response;

      // API Request based on method
      switch (method) {
        case HttpMethods.post:
          response = await dio.post(url, data: body);
          break;
        case HttpMethods.put:
          response = await dio.put(url, data: body);
          break;
        case HttpMethods.patch:
          response = await dio.patch(url, data: body);
          break;
        case HttpMethods.get:
          response = request == null
              ? await dio.get(url)
              : await dio.get(url, queryParameters: request.toJson());
          break;
        case HttpMethods.delete:
          response = await dio.delete(url, data: body);
          break;
      }

      // Handle API Response
      return _handleResponse(response);
    } on DioError catch (e) {
      print("Dio Error: ${e.message}");
      gettt.Get.to(NoconnectionScreen(press: () {}));
      return NetWorkFailure();
    }
  }

  // Function to handle API responses
  static Object _handleResponse(Response<String>? response) {
    if (response?.statusCode == null) return UnExpectedError();

    final int statusCode = response!.statusCode!;
    print("API Response Status Code: $statusCode");

    // ✅ **Handle Unauthorized Access (401)**
    if (statusCode == ApiResponseCodes.authorizationError) {
      print("Unauthorized: Redirecting to LoginScreen...");
      Get.offAll(LoginFlow(isTokenExpired: true,), predicate: (route) => false); // Clears previous navigation stac
      return ForbiddenAccess();
    }

    // ✅ **Handle Success Response**
    if (statusCode == ApiResponseCodes.success || statusCode == ApiResponseCodes.create_success) {
      return Success(statusCode, response.data as String);
    }

    // ✅ **Handle Client & Server Errors (4xx, 5xx)**
    if (statusCode >= 400 && statusCode <= 500) {
      if (response.data is Map<String, dynamic>) {
        print("Processing Error Response: ${response.data}");
        try {
          final expectedStructure = UcpDefaultResponse(
            isSuccessful: false,
            message: '',
            errors: [],
            statusCode: statusCode,
            data: null,
          ).toJson();

          final isSameStructure = compareJsonStructure(response.data, expectedStructure);

          return isSameStructure
              ? Failure(statusCode, ucpDefaultResponseFromJson(response.data as String))
              : Failure(
            statusCode,
            UcpDefaultResponse(
              isSuccessful: false,
              message: "Error response from server",
              errors: [],
              statusCode: statusCode,
              data: null,
            ),
          );
        } catch (e) {
          print("Error Processing Response: $e");
          return Failure(statusCode, UcpDefaultResponse(
            isSuccessful: false,
            message: "An error occurred while processing the response.",
            errors: [e.toString()],
            statusCode: statusCode,
            data: null,
          )
          );
        }
      } else {
        return Failure(
          statusCode,
          UcpDefaultResponse(
            isSuccessful: false,
            message: _extractErrorMessage(response.data as String),
            errors: [response.data.toString()],
            statusCode: statusCode,
            data: null,
          ),
        );
      }
    }

    // Default case (Unhandled)
    return Failure(statusCode, UcpDefaultResponse(
      isSuccessful: false,
      message: "Unhandled status code: $statusCode",
      errors: [],
      statusCode: statusCode,
      data: null,
    ));
  }

  // Helper function to extract error message safely
  static String _extractErrorMessage(String data) {
    try {
      final decoded = jsonDecode(data);
      return decoded['message'] ?? decoded["errorMessage"] ?? "Unknown error occurred";
    } catch (e) {
      return "Error parsing response";
    }
  }

  static Future<Object> uploadDoc(dynamic requestBody , String url, {String? docType,
    String documentCategory="",}) async
  {
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
       print("interesting");
        return  Failure(res.statusCode,(ucpDefaultResponseFromJson( response)));
      }
      if (ApiResponseCodes.authorizationError == res.statusCode){
        gettt.Get.offAll(LoginFlow());
        return LoginFlow();
      }
      else{
        return  Failure(res.statusCode!,"Error Occurred");
      }
    }on HttpException{
      return  NetWorkFailure();

    }on FormatException{
      return  UnExpectedError();

    }
    catch (e){
      return NetWorkFailure();
    }
  }

  Future<String?> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }

  static Future<Object> uploadFile({
    required String url,                        // API endpoint
    String? filePath,                           // File path (optional)
    String? fileFieldName,                      // Field name for the file (optional)
    required bool requireAccess,                // Flag for authorization
    Map<String, dynamic> formFields = const {}, // Dynamic form fields
  }) async
  {
    try {
      // Prepare form data
      Map<String, dynamic> formDataMap = {...formFields};

      // If filePath is provided, include file in form data
      if (filePath != null && fileFieldName != null) {
        File file = File(filePath);

        // // Ensure the file exists
        // if (!await file.exists()) {
        //   return Failure(400, "File does not exist.");
        // }

        // Ensure the filename ends with .png
        String fileName = file.path.split('/').last;
        if (!fileName.endsWith(".png")) {
          fileName = "${fileName.split('.').first}.png"; // Change extension to .png
        }

        formDataMap[fileFieldName] = await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: MediaType("image", "png"),
        );
      }

      // Convert to FormData
      FormData formData = FormData.fromMap(formDataMap);

      // Make API call
      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: requireAccess
              ? {
            HttpHeaders.userAgentHeader: 'dio',
            "Content-Type": "multipart/form-data",
            'Accept': 'application/json',
            'accept': 'text/plain',
            'Authorization': 'Bearer $accessToken',
          }
              : {
            HttpHeaders.userAgentHeader: 'dio',
            "Content-Type": "multipart/form-data",
            'Accept-Language': 'en-US,en;q=0.5',
            'Accept': 'application/json',
            'accept': 'text/plain',
            'Connection': "keep-alive",
          },
        ),
      );

      AppUtils.debug("/**** REST call response starts ****/");
      AppUtils.debug("Status code: ${response.statusCode}");
      AppUtils.debug("Request Body: $formFields");
      AppUtils.debug("Response: ${response.data}");

      // Handle success response
      if (ApiResponseCodes.success == response.statusCode) {
        return Success(response.statusCode!, response.data);
      }

      // Handle error or internal server error response
      if (ApiResponseCodes.error == response.statusCode ||
          ApiResponseCodes.internalServerError == response.statusCode) {
        return Failure(
          response.statusCode ?? 400,
          ucpDefaultResponseFromJson(jsonEncode(response.data)), // Deserialize error response
        );
      }

      // Handle authorization error response
      if (ApiResponseCodes.authorizationError == response.statusCode){
        gettt.Get.offAll(LoginFlow());
        return LoginFlow();
      }
      else{
        return  Failure(response.statusCode!,"Error Occurred");
      }

      // Fallback for any other error
      return Failure(response.statusCode ?? 400, "An unknown error occurred.");
    } on HttpException {
      return NetWorkFailure();
    } on FormatException {
      return UnExpectedError();
    } catch (e,trace) {
      // Handle unexpected exceptions
      print("Upload Failed: $e");
      print("Upload Failed track: $trace");
      return Failure(500, "An unexpected error occurred.");
    }
  }

static upLoad2DiffFiles({
  required String url,                        // API endpoint
  String? contestantPhotoPath,
  String? manifestoPlanDocPath,// File path (optional)
  String? photofileFieldName,                    // Field name for the file (optional)
  String? manifestofileFieldName,                    // Field name for the file (optional)
  required bool requireAccess,                // Flag for authorization
  Map<String, dynamic> formFields = const {}, // Dynamic form fields
}) async
{
  try {
    // Prepare form data
    Map<String, dynamic> formDataMap = {...formFields};

    // If filePath is provided, include file in form data
    if (contestantPhotoPath != null && photofileFieldName != null && manifestoPlanDocPath != null && manifestofileFieldName != null) {
      File file = File(contestantPhotoPath);
      File file2 = File(manifestoPlanDocPath);

      // // Ensure the file exists
      // if (!await file.exists()) {
      //   return Failure(400, "File does not exist.");
      // }

      // Ensure the filename ends with .png
      String fileName = file.path.split('/').last;
      if (!fileName.endsWith(".png")) {
        fileName = "${fileName.split('.').first}.png"; // Change extension to .png
      }

      String fileName2 = file2.path.split('/').last;
      if (!fileName2.endsWith(".png")) {
        fileName2 = "${fileName2.split('.').first}.png"; // Change extension to .png
      }

      formDataMap[photofileFieldName] = await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType: MediaType("image", "png"),
      );
      formDataMap[manifestofileFieldName] = await MultipartFile.fromFile(
        file2.path,
        filename: fileName2,
        contentType: MediaType("image", "png"),
      );
    }

    // Convert to FormData
    FormData formData = FormData.fromMap(formDataMap);

    // Make API call
    Response response = await dio.post(
      url,
      data: formData,
      options: Options(
        headers: requireAccess
            ? {
          HttpHeaders.userAgentHeader: 'dio',
          "Content-Type": "multipart/form-data",
          'Accept': 'application/json',
          'accept': 'text/plain',
          'Authorization': 'Bearer $accessToken',
        }
            : {
          HttpHeaders.userAgentHeader: 'dio',
          "Content-Type": "multipart/form-data",
          'Accept-Language': 'en-US,en;q=0.5',
          'Accept': 'application/json',
          'accept': 'text/plain',
          'Connection': "keep-alive",
        },
      ),
    );

    AppUtils.debug("/**** REST call response starts ****/");
    AppUtils.debug("Status code: ${response.statusCode}");
    AppUtils.debug("Request Body: $formFields");
    AppUtils.debug("Response: ${response.data}");

    // Handle success response
    if (ApiResponseCodes.success == response.statusCode) {
      return Success(response.statusCode!, response.data);
    }

    // Handle error or internal server error response
    if (ApiResponseCodes.error == response.statusCode ||
        ApiResponseCodes.internalServerError == response.statusCode) {
      return Failure(
        response.statusCode ?? 400,
        ucpDefaultResponseFromJson(jsonEncode(response.data)), // Deserialize error response
      );
    }

    // Handle authorization error response
    if (ApiResponseCodes.authorizationError == response.statusCode){
      gettt.Get.offAll(LoginFlow());
      return LoginFlow();
    }
    else{
      return  Failure(response.statusCode!,"Error Occurred");
    }

    // Fallback for any other error
    return Failure(response.statusCode ?? 400, "An unknown error occurred.");
  } on HttpException {
    return NetWorkFailure();
  } on FormatException {
    return UnExpectedError();
  } catch (e,trace) {
    // Handle unexpected exceptions
    print("Upload Failed: $e");
    print("Upload Failed track: $trace");
    return Failure(500, "An unexpected error occurred.");
  }
}
}


