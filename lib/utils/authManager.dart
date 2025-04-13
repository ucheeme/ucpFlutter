import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ucp/data/model/request/loginReq.dart';

class AuthManager {
  static const String _rememberMeKey = 'remember_me';
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';
  static const String _cooperativeIdKey = 'cooperative_id';
  static const String _biometricKey = 'biometric_enabled';

  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<void> saveLoginCredentials(String username, String password,
      String cooperativeId,
      bool rememberMe,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, rememberMe);
    if (rememberMe) {
      await prefs.setString(_usernameKey, username);
      await prefs.setString(_passwordKey, password);
      await prefs.setString(_cooperativeIdKey, cooperativeId);
    } else {
      await prefs.remove(_usernameKey);
      await prefs.remove(_passwordKey);
      await prefs.remove(_cooperativeIdKey);
    }
  }
  Future<void>saveBiometricEnabled(bool useBiometric)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricKey, useBiometric);
  }
  Future<bool> shouldAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  Future<bool> isBiometricEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricKey) ?? false;
  }

  Future<LoginRequest?> getStoredCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(_usernameKey);
    String? password = prefs.getString(_passwordKey);
    String? cooperativeId = prefs.getString(_cooperativeIdKey);
    if (username != null && password != null&&cooperativeId!=null) {
      return LoginRequest(nodeId:int.parse(cooperativeId??"0") ,
          username: username, password: password);
    }
    return null;
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to log in',
        options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );
      return authenticated;
    } catch (e) {
      return false;
    }
  }

  Future<LoginRequest?> attemptAutoLogin() async {
    LoginRequest? credentials = await getStoredCredentials();
    if (await shouldAutoLogin()) {
      bool useBiometric = await isBiometricEnabled();
      if (useBiometric) {
        bool authenticated = await authenticateWithBiometrics();
        if (!authenticated) {
          return credentials;
        } else {
          return credentials;
        }
      }else{
        return credentials;
      }
      }
    return credentials;
    }

}
