import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' as gett;
import 'package:rxdart/rxdart.dart';
import 'package:ucp/data/model/request/loginOtpRequest.dart';
import 'package:ucp/data/model/request/loginReq.dart';
import 'package:ucp/data/model/request/signUpReq.dart';
import '../../data/model/request/signUpSendOtp.dart';
import '../../data/model/response/cooperativeList.dart';
import '../../utils/customValidator.dart';
import '../../utils/sharedPreference.dart';
import '../../view/mainUi/onBoardingFlow/loginFlow/loginD.dart';

String firstNameTemp = "";

class OnboardingValidation {
  TextEditingController passwordController = TextEditingController();
  TextEditingController memberIdController = TextEditingController();
 // String otpController = "";
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
  CooperativeListResponse? selectedCooperative;

  String? get emailError => _emailError;

  String? get phoneError => _phoneError;

  String? get nameError => _nameError;

  String? get passwordError => _passwordError;

  final _emailSubject = BehaviorSubject<String>();
  final _sCooperativeSubject = BehaviorSubject<CooperativeListResponse>();
  final _homeAddressSubject = BehaviorSubject<String>();
  final _countrySubject = BehaviorSubject<String>();
  final _stateSubject = BehaviorSubject<String>();
  final _citySubject = BehaviorSubject<String>();
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
  Function(CooperativeListResponse) get setCooperative => _sCooperativeSubject.sink.add;

  Function(String) get setMemberNo => _memberSubject.sink.add;

  Function(String) get setGender => _genderSubject.sink.add;

  Function(String) get setHomeAddress => _homeAddressSubject.sink.add;

  Function(String) get setCountry => _countrySubject.sink.add;

  Function(String) get setState => _stateSubject.sink.add;

  Function(String) get setCity => _citySubject.sink.add;

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
  Stream<CooperativeListResponse> get cooperative => _sCooperativeSubject.stream;

  Stream<String> get gender =>
      _genderSubject.stream.transform(validateFullName);

  Stream<String> get homeAddress =>
      _homeAddressSubject.stream;

  Stream<String> get state => _stateSubject.stream.transform(validateFullName);

  Stream<String> get city => _citySubject.stream.transform(validateFullName);

  Stream<String> get country =>
      _countrySubject.stream.transform(validateFullName);

  Stream<String> get memberId =>
      _memberSubject.stream;

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

  Stream<bool> get completeSignUpThirdPageFormValidation =>
      Rx.combineLatest2(gender, userName, (gender, userName) => true);

  Stream<bool> get loginCompleteRegistrationFormValidation => Rx.combineLatest2(
      loginUserName,
      loginPassword,
      (
        loginUserName,
        loginPassword,
      ) =>
          true);

  Stream<bool> get completeSignupSecondPageValidation => Rx.combineLatest4(
      firstName,
      lastName,
      email,
      phoneNumber,
      (
        firstName,
        lastName,
        email,
        phoneNumber,
      ) =>
          true);

  Stream<bool> get completeSignupFourthPageValidation => Rx.combineLatest3(
      homeAddress,
      country,
      state,

      (
        homeAddress,
        country,
        state,

      ) =>
          true);

  Stream<bool> get completeSignInValidation => Rx.combineLatest3(
      cooperative,
      userName,
      password,
          (
          cooperative,
          userName,
          password,
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

  bool rememberMe = false;

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
      print("I am the cause");
      return false;
    } else {
      if (isMember) {
        if (
            selectedCooperative != null &&
            _memberSubject.valueOrNull != null) {
          return true;
        } else {
          print("I am the cause M");
          return false;
        }
      } else {
        if (selectedCooperative != null) {
          print("Not Member Donee");
          return true;
        } else {
          print("I am the cause No M");
          return false;
        }
      }
    }
  }
  SignupOtpRequest signupOtpRequest() {
    print("I am here");
    return SignupOtpRequest(
      cooperativeId: selectedCooperative!.nodeId,
      emailAddress: _emailSubject.value.trim() ?? "",
      username: _userNameSubject.value.trim(),
      fullName: _firstNameSubject.value.trim() ?? "",
    );
  }
  SignupRequest signupRequest() {
    double amount = double.parse(_membershipAmountSubject.value.trim().replaceAll(",", "") ?? "0");
    print("This is the amount $amount");
    var response = SignupRequest(
      cooperativeId: selectedCooperative!.nodeId,
      username: _userNameSubject.value.trim(),
      memberNo: _memberSubject.value.trim(),
      firstName: _firstNameSubject.value.trim() ?? "",
      lastName: _lastNameSubject.value.trim() ?? "",
      gender: _genderSubject.value.trim() ?? "",
      phoneNumber: _phoneSubject.value.trim() ?? "",
      emailAddress: _emailSubject.value.trim() ?? "",
      contributionAmount: double.parse(
          _membershipAmountSubject.value.trim().replaceAll(",", "") ?? "0"),
      address: _homeAddressSubject.value.trim() ?? "",
      country: _countrySubject.value.trim() ?? "",
      state: _stateSubject.value.trim() ?? "",
    );
    print(response);
    return response;
  }

  LoginRequest loginRequest() {
    MySharedPreference.setAnythingNumber(key: isSelectedCooperative,
        value:selectedCooperative!.nodeId);
    MySharedPreference.setAnythingString(key: isUserName, value:_userNameSubject.value.trim());
    MySharedPreference.setAnythingString(key: isPassword, value:_passwordSubject.value.trim());

    return LoginRequest(
        nodeId: selectedCooperative!.nodeId,
        username: _userNameSubject.value.trim(),
        password: _passwordSubject.value.trim());
  }

  LoginSendOtpRequest loginOtpRequest() {
    return LoginSendOtpRequest(
        cooperativeId: selectedCooperative!.nodeId,
        username: _userNameSubject.value.trim());
  }
}
