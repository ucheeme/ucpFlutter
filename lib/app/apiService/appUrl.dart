import '../env/env.dart';

class UCPUrls{
  static const  baseUrl =Env.baseUrlStaging;
  static const getCooperative = "${baseUrl}Common/cooperatives";
  static const createAccount = "${baseUrl}Account/add-member-signup";
  static const loginMember = "${baseUrl}Account/member-login";
  static const getMemberId = "${baseUrl}Account/get-member-creation-utility";
  static const getSignUpOtp = "${baseUrl}Account/add-member-signup-otp-signup";
  static const getLoginOtp = "${baseUrl}Account/member-login-otp-validation";
  static const  getDashboardData= "${baseUrl}DashBoard/member-dashboard-data";
  static const  getTransactionHistory= "${baseUrl}TransactionHistory/get-member-account-number-transaction-report";
  static const  getCustomerAccounts= "${baseUrl}TransactionHistory/get-customer-account-histories-slim";
  static const  getPaymentMode= "${baseUrl}Savings/get-mode-of-payments";
  static const  getBankList= "${baseUrl}Common/get-banks";
  static const  getMemberAccountst= "${baseUrl}Savings/get-member-savings-account-numbers";
}