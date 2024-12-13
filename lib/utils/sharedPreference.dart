import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucp/data/model/response/cooperativeList.dart';

class MySharedPreference {
  static SharedPreferences? _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future saveEmail(String email) async {
    _preferences?.setString('email', email);
  }

  static Future saveNumOfNotification(String num) async {
    _preferences?.setString('numOfNotification', num);
  }

  static Future saveAccessToken(String email) async {
    _preferences?.setString('token', email);
  }

  static Future saveUserLoginResponse(String? loginResponse) async {
    _preferences?.setString('login', loginResponse ?? "");
  }

  static String getEmail() {
    return _preferences?.getString('email') ?? "";
  }

  static String getAccessToken() {
    return _preferences?.getString('token') ?? "";
  }

  static String getNumOfNotification() {
    return _preferences?.getString('numOfNotification') ?? "0";
  }

  static Future<bool> getVisitingFlag() async {
    bool alreadyVisited = _preferences?.getBool("alreadyvisited") ?? false;
    return alreadyVisited;
  }
  static String getUserId() {
    return _preferences?.getString('userId') ?? "";
  }
  static bool getCreateAccountStep(String key)  {
    return _preferences?.getBool(key) ?? false;
  }
  static saveCreateAccountStep({String key="",bool value=false}){
    _preferences?.setBool(key, value);
  }
  static saveUserId({String key="userId",String value=""}){
    _preferences?.setString(key, value);
  }


  static setVisitingFlag() async {
    return _preferences?.setBool("alreadyvisited", true);
  }
  static setIsProfileUpdate(bool value) async {
    return _preferences?.setBool("isNewAccount", value);
  }
  static bool getIsProfileUpdate() {
    return _preferences?.getBool('isNewAccount') ?? false;
  }

  static clearSharedPref() async {
    await _preferences?.remove("alreadyvisited");
  }

  ///Danger zone
  static deleteAllSharedPref() async {
    await _preferences?.clear();
  }
}
List<CooperativeListResponse> allCooperatives = [];
String accessToken = "";
String refreshAccessToken = "";