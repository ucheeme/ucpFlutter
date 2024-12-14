import '../env/env.dart';

class UCPUrls{
  static const  baseUrl =Env.baseUrlStaging;
  static const getCooperative = "${baseUrl}Common/cooperatives";
  static const createAccount = "${baseUrl}Account/add-member-signup";
  static const loginMember = "${baseUrl}Account/member-login";
  static const  getDashboardData= "${baseUrl}DashBoard/member-dashboard-data";
  static const  getTransactionHistory= "${baseUrl}TransactionHistory/get-member-account-number-transaction-report";
  static const  getCustomerAccounts= "${baseUrl}TransactionHistory/get-customer-account-histories-slim";
}