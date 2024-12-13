import '../env/env.dart';

class UCPUrls{
  static const  baseUrl =Env.baseUrlStaging;
  static const getCooperative = "${baseUrl}Common/cooperatives";
  static const createAccount = "${baseUrl}Account/add-member-signup";
  static const loginMember = "${baseUrl}Account/member-login";
}