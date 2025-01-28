import 'package:flutter/cupertino.dart';

class LoanController{
  final loanAmountController = TextEditingController();
  final reasonForLoanController = TextEditingController();
  final loanProductController = TextEditingController();
  final netMonthlyPayController = TextEditingController();
  final loanDurationController = TextEditingController();
  final frequencyController = TextEditingController();
  final interestController = TextEditingController();
  String loanProduct = "";
  String loanInterest = "";
  String loanFreq = "";

  void clear() {
    loanFreq="";
    loanInterest="";
    loanProduct="";
    loanAmountController.clear();
    reasonForLoanController.clear();
    netMonthlyPayController.clear();
    loanDurationController.clear();
    frequencyController.clear();
    interestController.clear();
  }
}