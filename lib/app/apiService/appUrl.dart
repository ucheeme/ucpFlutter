import '../env/env.dart';

class UCPUrls{
  static const  baseUrl =Env.baseUrlStaging;
  static const getCooperative = "${baseUrl}Common/cooperatives";
  static const getNotifications = "${baseUrl}Notifications/member-notification";
  static const readNotification = "${baseUrl}Notifications/";
  static const clearNotifications = "${baseUrl}Notifications/clear";
  static const getUcpCountries = "${baseUrl}Common/countries";
  static const getUcpStates = "${baseUrl}Common/get-states-by-countryId";
  static const createAccount = "${baseUrl}Account/add-member-signup";
  static const getSignUpCost = "${baseUrl}Account/get-member-registration-requirement";
  static const loginMember = "${baseUrl}Account/member-login";
  static const getMemberId = "${baseUrl}Account/get-member-creation-utility";
  static const getSignUpOtp = "${baseUrl}Account/add-member-signup-otp-signup";
  static const getLoginOtp = "${baseUrl}Account/member-login-otp-validation";
  static const forgotPassword = "${baseUrl}Account/forgot-password";
  static const  getDashboardData= "${baseUrl}DashBoard/member-dashboard-data";
  static const  getTransactionHistory= "${baseUrl}TransactionHistory/get-member-account-number-transaction-report";
  static const  getMemberTransactionHistory= "${baseUrl}TransactionHistory/member-transaction-report";
  static const  getCustomerAccounts= "${baseUrl}TransactionHistory/get-customer-account-histories-slim";
  static const  getPaymentMode= "${baseUrl}Savings/get-mode-of-payments";
  static const  getLoanPaymentMode= "${baseUrl}Loan/get-mode-of-payments";
  static const  getBankList= "${baseUrl}Common/get-banks";
  static const  getMemberAccountst= "${baseUrl}Savings/get-member-savings-account-numbers";
  static const  getMemberWithdrawAccountDetail= "${baseUrl}Withdrawal/get-member-withdrawal-detail";
  static const  getWithdrawHistory= "${baseUrl}Withdrawal/get-member-withdrawal-histories";
  static const  withdrawRequest= "${baseUrl}Withdrawal/withdrawal-request";
  static const  retirementRequest= "${baseUrl}Retirement/retirement-request";
  static const  getRetirementHistory= "${baseUrl}Retirement/get-member-retirement-histories";
  static const  getSavingHistory= "${baseUrl}Savings/get-member-savings-histories";
  static const  getShopItems= "${baseUrl}Shop/get-shop-items";
  static const  addItemToCart= "${baseUrl}Shop/add-item-to-cart";
  static const  increaseItemCountOnCart= "${baseUrl}Shop/increase-item-in-cart";
  static const  decreaseItemCountOnCart= "${baseUrl}Shop/decrease-item-in-cart";
  static const  markItemAsFavourite= "${baseUrl}Shop/add-favourite-item";
  static const  unmarkAsFavourite= "${baseUrl}Shop/delete-favourite-item";
  static const  getAllFavouriteItems= "${baseUrl}Shop/get-all-favourite-memmber-purchased-item";
  static const  getAllPurchasedItemSummary= "${baseUrl}Shop/get-purchased-item-request-summary";
  static const  getAllItemInPurchasedSummary= "${baseUrl}Shop/get-all-member-purchased-item";
  static const  getAllItemOnCart= "${baseUrl}Shop/get-cart-items";
  static const  getAllLoanApplications= "${baseUrl}Loan/get-loan-application";
  static const  getAllLoanProducts= "${baseUrl}Loan/get-loan-products";
  static const  getLoanSchedule= "${baseUrl}Loan/get-loan-schedule";
  static const  getLoanRefundSchedule= "${baseUrl}Loan/get-loan-schedule-for-refund";
  static const  getLoanFrequencyForProduct= "${baseUrl}Loan/get-selected-loan-product-detail";
  static const  getAllLoanFrequencies= "${baseUrl}Common/get-loan-frequencies";
  static const  getAllGurantors= "${baseUrl}Loan/get-loan-gaurators";
  static const  verifyPayments= "${baseUrl}Savings/verify-contribution-to-savings-account";
  static const  getMemberLoanApplicationGuarators= "${baseUrl}Loan/get-member-loan-application-guarators";
  static const  getAllGuarantors= "${baseUrl}Loan/get-loan-gaurators";
  static const  getAllUserLoans= "${baseUrl}Loan/get-member-loan-account-numbers";
  static const  getMemberProfile= "${baseUrl}Profile/get-member-detail";
  static const  updateProfileDetails= "${baseUrl}Profile/update-member-profile";
  static const  applyForPosition= "${baseUrl}Election/apply-for-election-as-a-contestant";
  static const  getAppliedMemberInfo= "${baseUrl}Election/get-contestant-application";
  static const  processPayment= "${baseUrl}Savings/contribute-to-saving-account";
  static const  changePassword= "${baseUrl}Profile/change-password";
  static const  getAllMemberSavingAcct= "${baseUrl}Savings/get-member-savings-account-numbers";
  static const  payForItemsInCart= "${baseUrl}Shop/buy-item";
  static const  payForLoan= "${baseUrl}Loan/loan-repayment";
  static const  getAllEligiblePosition= "${baseUrl}Election/get-elections";
  static const  addMemberBankAccountDetails= "${baseUrl}Account/update-member-bank-detail";
  static const  checkCooperativePrivileges= "${baseUrl}Account/global-role";
  static const  voteForCandidate= "${baseUrl}Election/cast-vote";
  static const  getElectionResult= "${baseUrl}Election/election-result";

  static const applyForLoan="${baseUrl}Loan/apply-for-loan";
  static const logOut="${baseUrl}Account/logout";

  static const getAllLoanGuarantorsRequest="${baseUrl}Loan/get-member-loan-application-guarators";
  static const guarantorRejectRequest="${baseUrl}Loan/guarantor-request-reject";
  static const guarantorAcceptRequest="${baseUrl}Loan/guarantor-request-approved";
  static const getMemberImage="${baseUrl}Profile/get-member-profile-image";

  static var getElectionDetails="${baseUrl}Election/get-election";

  static const getMemberCurrentMonthlyContribution="${baseUrl}Savings/get-member-saving-contribution-balance";
  static const rescheduleContribution="${baseUrl}Savings/reshedule-saving-account";

  static const checkIfMemberCanVote="${baseUrl}Election/check-if-member-can-vote";
}