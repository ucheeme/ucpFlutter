import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' as gett;
import 'package:rxdart/rxdart.dart';
import '../../utils/customValidator.dart';

String firstNameTemp = "";

class OnboardingValidation {
  TextEditingController passwordController = TextEditingController();
  TextEditingController memberIdController = TextEditingController();
  String otpController = "";
  String cooperativeId = "";
  TextEditingController transactionPinController = TextEditingController();
  TextEditingController twoFactorController = TextEditingController();
  bool isMember = false;
  bool isNotMember = false;
  bool isAcceptTermsAndCondition = false;
  bool isEmailSelected = false;
  bool isFirstNameSelected = false;
  bool isLastNameSelected = false;
  bool isMiddleNameSelected = false;
  bool isUserNameSelected = false;
  bool isWrongOTP = false;
  bool isCompleteOTP = false;
  bool isLoginUserNameSelected = false;
  bool isLoginPasswordSelected = false;
  bool isPhoneNumberSelected = false;
  bool isReferralCodeSelected = false;
  bool isPasswordSelected = false;
  bool isConfirmPasswordSelected = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isEightCharacterMinimumChecked = false;
  bool isContainsNumChecked = false;
  bool isContainsSymbolChecked = false;
  bool isContainsUpperCaseChecked = false;
  bool isContainsLowerCaseChecked = false;
  bool isPasswordMatch = false;
  String tempPassword = "";
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _nameError;

  String? get emailError => _emailError;

  String? get phoneError => _phoneError;

  String? get nameError => _nameError;

  String? get passwordError => _passwordError;

  final _emailSubject = BehaviorSubject<String>();
  final _memberSubject = BehaviorSubject<String>();
  final _genderSubject = BehaviorSubject<String>();
  final _membershipAmountSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String>();
  final _confirmPasswordSubject = BehaviorSubject<String>();
  final _phoneSubject = BehaviorSubject<String>();
  final _firstNameSubject = BehaviorSubject<String>();
  final _lastNameSubject = BehaviorSubject<String>();
  final _middleNameSubject = BehaviorSubject<String>();
  final _userNameSubject = BehaviorSubject<String>();
  final _otpValueSubject = BehaviorSubject<String>();
  final _referralCodeSubject = BehaviorSubject<String>();
  final _loginUserNameSubject = BehaviorSubject<String>();
  final _loginPasswordSubject = BehaviorSubject<String>();
  final _forgotPasswordSubject = BehaviorSubject<String>();
  final _forgotConfirmPasswordSubject = BehaviorSubject<String>();

  Function(String) get setEmail => _emailSubject.sink.add;

  Function(String) get setMemberNo => _memberSubject.sink.add;
  Function(String) get setGender => _genderSubject.sink.add;

  Function(String) get setMembershipAmount => _membershipAmountSubject.sink.add;

  Function(String) get setConfirmPassword => _confirmPasswordSubject.sink.add;

  Function(String) get setPassword => _passwordSubject.sink.add;

  Function(String) get setPhoneNumber => _phoneSubject.sink.add;

  Function(String) get setFirstName => _firstNameSubject.sink.add;

  Function(String) get setLastName => _lastNameSubject.sink.add;

  Function(String) get setMiddleName => _middleNameSubject.sink.add;

  Function(String) get setUserName => _userNameSubject.sink.add;

  Function(String) get setOtpValue => _otpValueSubject.sink.add;

  Function(String) get setReferralValue => _referralCodeSubject.sink.add;

  Function(String) get setLoginUserName => _loginUserNameSubject.sink.add;

  Function(String) get setLoginPassword => _loginPasswordSubject.sink.add;

  Function(String) get setForgetPassword => _forgotPasswordSubject.sink.add;

  Function(String) get setForgetConfirmPassword =>
      _forgotConfirmPasswordSubject.sink.add;

  Stream<String> get email => _emailSubject.stream.transform(validateEmail);
  Stream<String> get gender => _genderSubject.stream.transform(validateFullName);

  Stream<String> get memberId =>
      _memberSubject.stream.transform(validateUserName);

  Stream<String> get memberAmount =>
      _membershipAmountSubject.stream.transform(validatePrice);

  Stream<String> get lastName =>
      _lastNameSubject.stream.transform(validateFullName);

  Stream<String> get userName =>
      _userNameSubject.stream.transform(validateUserName);

  Stream<String> get loginUserName =>
      _loginUserNameSubject.stream.transform(validateUserName);

  Stream<String> get phoneNumber =>
      _phoneSubject.stream.transform(validatePhoneNumber);

  Stream<String> get firstName =>
      _firstNameSubject.stream.transform(validateFullName);

  Stream<String> get middleName =>
      _middleNameSubject.stream.transform(validateFullName);

  Stream<String> get password =>
      _passwordSubject.stream.transform(validatePassword);

  Stream<String> get loginPassword =>
      _loginPasswordSubject.stream.transform(validatePassword);

  Stream<String> get forgotPassword =>
      _forgotPasswordSubject.stream.transform(validatePassword);

  Stream<String> get referralCode =>
      _referralCodeSubject.stream.transform(validateUserName);

  Stream<String> get confirmPassword =>
      _confirmPasswordSubject.stream.transform(validateConfirmPassword);

  Stream<bool> get completeRegistrationFormValidation => Rx.combineLatest2(
      email,
      confirmPassword,
      (
        email,
        confirmPassword,
      ) =>
          true);

  Stream<bool> get loginCompleteRegistrationFormValidation => Rx.combineLatest2(
      loginUserName,
      loginPassword,
      (
        loginUserName,
        loginPassword,
      ) =>
          true);

  Stream<bool> get completePersonalInformationFormValidation =>
      Rx.combineLatest5(
          firstName,
          lastName,
          userName,
          middleName,
          phoneNumber,
          (
            firstName,
            lastName,
            userName,
            middle,
            phoneNumber,
          ) =>
              true);

  Stream<String> get otpValue =>
      _otpValueSubject.stream.transform(validateOtpValue);

  setEmailError(String? value) {
    _emailError = value;
  }

  setPasswordError(String? value) {
    _passwordError = value;
  }

  setNameError(String? value) {
    _nameError = value;
  }

  setTempPassword(String? value) {
    tempPassword = value!;
  }

  final validateFullName = StreamTransformer<String, String>.fromHandlers(
      handleData: (firstName, sink) {
    CustomValidator customValidator = CustomValidator();
    if (customValidator.validatename(firstName) != null) {
      customValidator.validatename(firstName);
      sink.addError(customValidator.validatename(firstName)!);
    } else {
      sink.add(firstName);
    }
  });

  final validateUserName = StreamTransformer<String, String>.fromHandlers(
      handleData: (firstName, sink) {
    CustomValidator customValidator = CustomValidator();
    if (customValidator.validateusername(firstName) != null) {
      customValidator.validateusername(firstName);
      sink.addError(customValidator.validatename(firstName)!);
    } else {
      sink.add(firstName);
    }
  });

  final validatePassword =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    CustomValidator customValidator = CustomValidator();
    if (customValidator.validatePassword(value) != null) {
      sink.addError(customValidator.validatePassword(value)!);
    } else {
      print("this is pasd");
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

  final validatePhoneNumber =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    CustomValidator customValidator = CustomValidator();
    if (customValidator.validateMobile(value) != null) {
      sink.addError(customValidator.validateMobile(value)!);
    } else {
      sink.add(value);
    }
  });

  final validateOtpValue =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (!value.isNumericOnly) {
      sink.addError('Enter only number');
    } else if (value.isNumericOnly && value.length == 4) {
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

  setFirstNameTemp() {
    firstNameTemp = _firstNameSubject.value;
  }

  bool validatePasswords() {
    if (passwordController.text == _confirmPasswordSubject.value) {
      isPasswordMatch = true;
      return true;
    } else {
      isPasswordMatch = false;
      return false;
    }
  }

  bool isValidString(String input) {
    final symbolPattern = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    final numberPattern = RegExp(r'\d');

    bool containsSymbol = symbolPattern.hasMatch(input);

    bool containsNumber = numberPattern.hasMatch(input);
    bool hasValidLength = input.length > 7;

    return containsSymbol && containsNumber && hasValidLength;
  }

  bool firstPageCheck() {
    if (!isMember && !isNotMember) {
      return false;
    } else {
      if (isMember) {
        if (_membershipAmountSubject.valueOrNull!=null &&
            cooperativeId.isNotEmpty &&
            _memberSubject.value.isNotEmpty) {
          return true;
        }
      } else {
        if (_membershipAmountSubject.valueOrNull!=null  &&
            cooperativeId.isNotEmpty) {
          return true;
        }
      }
    }
    return false;
  }
}
