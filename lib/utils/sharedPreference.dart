import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucp/data/model/request/saveToAccount.dart';
import 'package:ucp/data/model/response/allCountries.dart';
import 'package:ucp/data/model/response/allGuarantors.dart';
import 'package:ucp/data/model/response/cooperativeList.dart';
import 'package:ucp/data/model/response/loanFrequencyResponse.dart';
import 'package:ucp/data/model/response/loanProductResponse.dart';
import 'package:ucp/data/model/response/memberTransactionHistory.dart';
import 'package:ucp/data/model/response/notificationResponse.dart';
import 'package:ucp/data/model/response/paymentModeResponse.dart';
import 'package:ucp/data/model/response/statesInCountry.dart';
import 'package:ucp/data/model/response/transactionHistoryResponse.dart';
import 'package:ucp/data/model/response/withdrawTransactionHistory.dart';
import 'package:ucp/view/mainUi/onBoardingFlow/loginFlow/loginD.dart';

import '../data/model/response/dashboardResponse.dart';
import '../data/model/response/listOfBankResponse.dart';
import '../data/model/response/loginResponse.dart';
import '../data/model/response/memberSavingAccount.dart';
import '../data/model/response/purchasedItemSummartResponse.dart';

class MySharedPreference {
  static SharedPreferences? _preferences;
static const _firstLaunchKey = 'hasLaunchedBefore';
  static const isBioMetric = 'isBioMetric';
  static const isRememberMe = 'rememberMe';
  static const isUserName = 'userName'; 
  static const isPassword = 'password';
  static const isSelectedCooperative = 'selectedCooperative';

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

  static getBiometricStatus() {
    return _preferences?.getBool(isBioMetric) ?? false;
  }

 static enableBiometric(bool value) {
    _preferences?.setBool(isBioMetric, value);
  }

  static getRememberMeStatus(){
    return _preferences?.getBool(isRememberMe) ?? false;
  }

  static setRememberMe(bool value) {
    _preferences?.setBool(isRememberMe, value);
  }

  static setAnythingString({String key="",String value=""}){
    _preferences?.setString(key, value);
  }

  static getAnythingString(String key) {
    return _preferences?.getString(key) ?? "";
  }

  static setAnythingNumber({String key="",int value=0}){
    _preferences?.setInt(key, value);
  }

  static getAnythingNumber(String key) {
    return _preferences?.getInt(key) ?? 0;
  }

  static setUserName(String value) {
    _preferences?.setString(isUserName, value);
  }
  
  static setPassword(String value) {
    _preferences?.setString(isPassword, value);
  }

  static setSelectedCooperative(CooperativeListResponse value) {
    _preferences?.setString(isSelectedCooperative,json.encode(value.toJson()));
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

static setHasLaunched(bool value) async {
    _preferences?.setBool(_firstLaunchKey, value);
  }

  static bool getHasLaunched() {
    return _preferences?.getBool(_firstLaunchKey) ?? false;
  }
  
  ///Danger zone
  static deleteAllSharedPref() async {
    await _preferences?.clear();
  }

  static getUserName() {
    return _preferences?.getString(isUserName) ?? "";
  }

  static getPassword() {
    return _preferences?.getString(isPassword) ?? "";
  }

  static getSelectedCooperative() {
    return _preferences?.getString(isSelectedCooperative) ?? "";
  }


}
List<CooperativeListResponse> allCooperatives = [];
List<AllCountriesResponse> allCountries = [];
List<AllStateResponse> allStates  = [];
String accessToken = "";
String refreshAccessToken = "";
MemberLoginDetails? memberLoginDetails;
List<UserTransaction> tempTransactionList =[];
List<MemberTransactionReport> tempMemberTransactionList =[];
List<Account> tempAccounts=[];
List<UserSavingAccounts>tempMemberSavingAccounts= [];
List<WithdrawTransactionHistory>tempWithdrawTransactionHistory= [];
List<WithdrawTransactionHistory>tempMemberSavingHistory= [];
List<WithdrawTransactionHistory>tempRetirementHistory = [];
List<PurchasedSummary> purchasedSummaryListTemp = [];
List<ListOfBank>tempBankList = [];
List<UserSavingAccounts> tempSavingAccounts= [];
List<LoanFrequencyList>tempLoanFrequencies=[];
List<LoanGuantorsList>tempLoansGuarantors=[];
List<LoanProductList>tempLoanProducts=[];
List<PaymentModes> tempPaymentModes= [];
List<PaymentModes> tempLoanPaymentModes= [];
List<UcpNotification> tempMemberNotifications= [];
PaymentRequest saveToAccountRequest = PaymentRequest(
    amount:"",
    modeOfpayment: "",
    description: "", accountNumber: "", bank: "",
    bankAccountNumber: "", bankTeller: "", paidDate: DateTime.now().toIso8601String(),);