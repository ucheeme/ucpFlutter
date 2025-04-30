import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ucp/data/model/request/changePasswordRequest.dart';
import 'package:ucp/data/model/request/rescheduleContributionRequest.dart';
import 'package:ucp/data/model/request/updateProfileRequest.dart';

import '../../utils/customValidator.dart';

class ProfileController {
  static final ProfileController _singleton = ProfileController._internal();
  factory ProfileController() => _singleton;
  ProfileController._internal();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController memberController = TextEditingController();
  TextEditingController contributionAmountController  = TextEditingController();
  TextEditingController contributionCurrentMonthlyAmountController = TextEditingController();
  
  bool isEightCharacterMinimumChecked = false;
  bool isContainsNumChecked = false;
  bool isContainsSymbolChecked = false;
  bool isContainsUpperCaseChecked = false;
  bool isContainsLowerCaseChecked = false;
  bool isPasswordVisible = false;
  bool isCurrentPasswordVisible = false;
  bool isPasswordMatch = false;
  bool isReferralCodeSelected = false;
  bool isPasswordSelected = false;
  bool isConfirmPasswordSelected = false;
  bool isConfirmPasswordVisible = false;


  final _addressSubject = BehaviorSubject<String>();
  
  final _fullNameSubject = BehaviorSubject<String>();
  final _phoneNumberSubject = BehaviorSubject<String>();
  final _emailSubject = BehaviorSubject<String>();
  final _memberSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String>();
  final _currentPasswordSubject = BehaviorSubject<String>();
  final _confirmPasswordSubject = BehaviorSubject<String>();
  final _contributionCurrentMonthlyAmountSubject = BehaviorSubject<String>();
  final _contributionAmountSubject = BehaviorSubject<String>();
  final _memberAccountNumber = BehaviorSubject<String>();

  Function(String) get setEmail => _emailSubject.sink.add;
  Function(String) get setMemberAccountNumber => _memberAccountNumber.sink.add;
  Function(String) get setContributionAmount => _contributionAmountSubject.sink.add;
  Function(String) get setContributionCurrentMonthlyAmount => _contributionCurrentMonthlyAmountSubject.sink.add;
  Function(String) get setAddress => _addressSubject.sink.add;
  Function(String) get setFullName => _fullNameSubject.sink.add;
  Function(String) get setPhoneNumber => _phoneNumberSubject.sink.add;
  Function(String) get setMember=>_memberSubject.sink.add;
  Function(String) get setConfirmPassword => _confirmPasswordSubject.sink.add;
  Function(String) get setPassword => _passwordSubject.sink.add;
  Function(String) get setCurrentPassword => _currentPasswordSubject.sink.add;

  Stream<String> get email => _emailSubject.stream.transform(validateEmail);
  Stream<String> get memberAccount => _memberAccountNumber.stream.transform(validateAddress);
  Stream<String> get fullname => _fullNameSubject.stream.transform(validateFullName);
  Stream<String> get phoneNumber => _phoneNumberSubject.stream.transform(validatePhoneNumber);
  Stream<String> get address => _addressSubject.stream.transform(validateAddress);
  Stream<String> get memberId => _memberSubject.stream.transform(validateAddress);
  Stream<String> get password => _passwordSubject.stream.transform(validatePassword);
  Stream<String> get amount => _contributionAmountSubject.stream.transform(validatePrice);
  Stream<String> get contributionCurrentMonthlyAmount => _contributionCurrentMonthlyAmountSubject.stream.transform(validatePrice);
  Stream<String> get currentPassword => _currentPasswordSubject.stream.transform(validatePassword);
  Stream<String> get confirmPassword =>
      _confirmPasswordSubject.stream.transform(validateConfirmPassword);

  Stream<bool> get contributionsValidation => Rx.combineLatest2(
    amount,
    contributionCurrentMonthlyAmount,
        (
        amount,
         contributionCurrentMonthlyAmount
        ) =>
    true
  );

  Stream<bool> get completeEditProfileValidation => Rx.combineLatest4(
      fullname,
      email,
      address,
      phoneNumber,
          (
          fullname,
          email,
          address,
          phoneNumber,
          ) =>
      true);

  Stream<bool> get completeChangePasswordValidation => Rx.combineLatest3(
      currentPassword,
      password,
      confirmPassword,
          (
          currentPassword,
          password,
          confirmPassword,
          ) =>
      true);

  final validatePassword =
  StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    CustomValidator customValidator = CustomValidator();
    if (customValidator.validatePassword(value) != null) {
      sink.addError(customValidator.validatePassword(value)!);
    } else {
      sink.add(value);
    }
  });

  final validateConfirmPassword =
  StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    CustomValidator customValidator = CustomValidator();
    if (customValidator.validateConfirmPassword(
      value,
    ) !=
        null) {
      sink.addError(customValidator.validateConfirmPassword(value)!);
    } else {
      sink.add(value);
    }
  });

  final validateEmail =
  StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    CustomValidator customValidator = CustomValidator();
    if (customValidator.validateEmail(value) != null) {
      sink.addError(customValidator.validateEmail(value)!);
    } else {
      sink.add(value);
    }
  });

  final validatePhoneNumber =
  StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    CustomValidator customValidator = CustomValidator();
    if (customValidator.validateMobile(value) != null) {
      sink.addError(customValidator.validateMobile(value)!);
    } else {
      sink.add(value);
    }
  });

  final validateFullName = StreamTransformer<String, String>.fromHandlers(
      handleData: (firstName, sink) {
        CustomValidator customValidator = CustomValidator();
        if (customValidator.validateFullName(firstName) != null) {
          customValidator.validateFullName(firstName);
          sink.addError(customValidator.validateFullName(firstName)!);
        } else {
          sink.add(firstName);
        }
      });

  final validateAddress = StreamTransformer<String,String>.fromHandlers(
    handleData: (value, sink){
      CustomValidator customValidator = CustomValidator();
      if (customValidator.validateExpenseDescription(value) != null) {
        customValidator.validateExpenseDescription(value);
        sink.addError(customValidator.validateExpenseDescription(value)!);
      } else {
        sink.add(value);
      }

    }
  );

  final validatePrice =
  StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    RegExp res = RegExp(r'^[0-9,]*$');
    if (!value.contains(res)) {
      sink.addError("Price can only be digit");
    } else {
      String res = value.replaceAll(",", "");
      sink.add(res);
    }
  });

  UpdateProfileRequest updateProfileRequest() {
    return UpdateProfileRequest(
      email: _emailSubject.value.trim() ?? "",
      residentState: '',
      nextAddress: '',
      lastName: _fullNameSubject.value.trim().split(" ")[2],
      gender: '',
      nextCountry:_addressSubject.value.trim() ?? "",
      residentCountry: _addressSubject.value.trim() ?? "",
      employeeId: '',
      occupation: '',
      phone: _phoneNumberSubject.value.trim() ?? "",
      dob: '',
      bvn: '',
      bankAccountNumber: '',
      firstName: _fullNameSubject.value.trim().split(" ")[0] ?? "",
      otherName: _fullNameSubject.value.trim().split(" ")[1],
      nextPhone: '',
      bank: '',
      nextName: '',
      nextState: '',
      acctName: '',
    );
  }

  ChangePasswordRequest changePasswordRequest() {
    return ChangePasswordRequest(
      oldPassword: _currentPasswordSubject.value.trim() ?? "",
      newPassword: _passwordSubject.value.trim() ?? "",
      confirmNewPassword: _confirmPasswordSubject.value.trim() ?? "",
    );
  }

RescheduleContributions rescheduleContributions(){
  return RescheduleContributions(amount: _contributionAmountSubject.value.trim().replaceAll(",", ""),
   oldAmount: _contributionCurrentMonthlyAmountSubject.value.trim());
}

}