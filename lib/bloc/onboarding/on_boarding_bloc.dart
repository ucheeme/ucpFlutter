import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ucp/data/model/request/loginOtpRequest.dart';
import 'package:ucp/data/model/request/signUpSendOtp.dart';
import 'package:ucp/data/model/response/checkCooperativePrivileges.dart';
import 'package:ucp/data/model/response/cooperativeList.dart';
import 'package:ucp/data/model/response/defaultResponse.dart';
import 'package:ucp/data/model/response/statesInCountry.dart';
import 'package:ucp/data/repository/onboardingRepo.dart';

import '../../data/model/request/forgotPasswordRequest.dart';
import '../../data/model/request/loginReq.dart';
import '../../data/model/request/signUpReq.dart';
import '../../data/model/response/allCountries.dart';
import '../../data/model/response/getMemberSignUpCost.dart';
import '../../data/model/response/loginOtpValidationResponse.dart';
import '../../data/model/response/loginResponse.dart';
import '../../data/model/response/nextMemberIdResponse.dart';
import '../../data/model/response/shopList.dart';
import '../../data/model/response/signUpResponse.dart';
import '../../utils/apputils.dart';
import 'onBoardingValidation.dart';

part 'on_boarding_event.dart';
part 'on_boarding_state.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  OnboardingValidation validation= OnboardingValidation();
  OnboardingRepo onboardingRepository;
  var errorObs = PublishSubject<String>();
  OnBoardingBloc({required this.onboardingRepository}) : super(OnBoardingInitial()) {
    on<OnBoardingEvent>((event, emit) {});
    on<GetAllCooperativesEvent>((event, emit)async{handleGetAllCooperativesEvent();});
    on<GetAllStatesEvent>((event, emit)async{handleGetAllStatesEvent(event);});
    on<GetAllCountriesEvent>((event, emit)async{handleGetAllCountriesEvent();});
    on<GetMemberSignUpCostEvent>((event, emit)async{handleGetMemberSignUpCostEvent(event);});
    on<CreateAccountEvent>((event, emit)async{handleCreateAccountEvent(event);});
    on<LoginEvent>((event, emit)async{handleLoginEvent(event);});
    on<GetNextMemberIdEvent>((event, emit)async{handleGetNextMemberIdEvent(event);});
    on<SendSignUpOtpEvent>((event, emit)async{handleSendSignUpOtpEvent(event);});
    on<SendLoginOtpEvent>((event, emit)async{handleSendLoginOtpEvent(event);});
    on<GetShopItemsEvent>((event, emit)async{handleGetShopItemsEvent();});
    on<ForgotPasswordEvent>((event, emit)async{handleForgotPasswordEvent(event);});
    on<GetCooperativePrivilegesEvent>((event, emit)async{handleGetCooperativePrivilegesEvent(event);});
  }
  void handleGetAllCooperativesEvent()async{
    emit(OnboardingIsLoading());
    try {
      final response = await onboardingRepository.getCooperatives();
      // final response = await onboardingRepository.newUser(event.request);
      if (response is List<CooperativeListResponse>) {
        emit(AllCooperatives(response));
        AppUtils.debug("success");
      }else{
        emit(OnBoardingError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(OnBoardingError(AppUtils.defaultErrorResponse(msg: "An Error Occurred")));
    }
  }
  void handleGetAllCountriesEvent()async{
    try{
      final response = await onboardingRepository.getAllCountries();
      if(response is List<AllCountriesResponse>){
        emit(AllUcpCountries(response));
      }else{
        emit(OnBoardingError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      print(e);
      emit(OnBoardingError(AppUtils.defaultErrorResponse(msg: "An Error Occurred")));
    }
  }
  void handleGetAllStatesEvent(event)async{
    try{
      final response = await onboardingRepository.getAllStates(event.countryId);
      if(response is List<AllStateResponse>){
        emit(AllUcpStates(response));
      }else{
        emit(OnBoardingError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      print(e);
      emit(OnBoardingError(AppUtils.defaultErrorResponse(msg: "An Error Occurred")));
    }
  }
  void handleGetMemberSignUpCostEvent(event)async{
    try{
      final response = await onboardingRepository.getAMembershipCpst(event.cooperativeId);
      if(response is MemberSignUpCost){
        emit(MemberSignUpCostSuccess(response));
        print(response.regFee);
      }else{
        emit(OnBoardingError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      print(e);
      emit(OnBoardingError(AppUtils.defaultErrorResponse(msg: "An Error Occurred")));
    }
  }


  initial(){
    emit(OnBoardingInitial());
  }

  void handleCreateAccountEvent(request) async{
    print("I was here");
    emit(OnboardingIsLoading());
    try {
      final response = await onboardingRepository.createAccount(request.request);
      if (response is SignUpResponse) {
        emit(CreateAccountSuccess(response));
        AppUtils.debug("success");
      }else{
        emit(OnBoardingError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }    }catch(e,trace){
      print(trace);
      emit(OnBoardingError(AppUtils.defaultErrorResponse(msg: "An Error Occurred")));
    }
  }

  void handleLoginEvent(LoginEvent event) async{
    emit(OnboardingIsLoading());
    try {
      final response = await onboardingRepository.loginUser(event.request);
      if (response is LoginResponse) {
        emit(LoginSuccess(response));
      }else{
        emit(OnBoardingError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(OnBoardingError(AppUtils.defaultErrorResponse(msg: "An Error Occurred")));
    }
  }

  void handleSendSignUpOtpEvent(event)async {
    emit(OnboardingIsLoading());
    try {
      final response = await onboardingRepository.sendSignUpOTP(event.request);
      if (response is OTPValidationResponse) {
        emit(SignUpOTPSuccessful(response));
        AppUtils.debug("success");
      }else{
        emit(OnBoardingError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }    }catch(e,trace){
      print(trace);
      emit(OnBoardingError(AppUtils.defaultErrorResponse(msg: "An Error Occurred")));
    }
  }

  void handleSendLoginOtpEvent(event)async {
    emit(OnboardingIsLoading());
    try {
      final response = await onboardingRepository.sendLoginOtp(event.request);
      if (response is OTPValidationResponse) {
        emit(LoginOTPSuccessful(response));
        AppUtils.debug("success");
      }else{
        emit(OnBoardingError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }    }catch(e,trace){
      print(trace);
      emit(OnBoardingError(AppUtils.defaultErrorResponse(msg:"An Error Occurred")));
    }
  }
  void handleGetNextMemberIdEvent(event)async {
    emit(OnboardingIsLoading());
    try {
      final response = await onboardingRepository.getMemberId(event.cooperativeId);
      if (response is NextMemberId) {
        emit(GetNextMemberIdSuccess(response));
        AppUtils.debug("success");
      }else{
        emit(OnBoardingError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }    }catch(e,trace){
      print(trace);
      emit(OnBoardingError(AppUtils.defaultErrorResponse(msg: "An Error Occurred")));
    }
  }

  void handleGetShopItemsEvent()async {
    emit(OnboardingIsLoading());
    try {
      final response = await onboardingRepository.getShopItems();
      if (response is List<ShopItemList>) {
        emit(ShopItemsLoaded(response));
        AppUtils.debug("success");
      } else {
        emit(OnBoardingError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(OnBoardingError(AppUtils.defaultErrorResponse(msg: "An Error Occurred")));
    }
  }

  void handleForgotPasswordEvent(ForgotPasswordEvent event)async {
    emit(OnboardingIsLoading());
    try{
      final response = await onboardingRepository.forgotPasswordMember(event.request);
      if(response is UcpDefaultResponse){
        if(response.isSuccessful){
          emit(MemberForgotPasswordSuccess(response));
        }else{
          emit(OnBoardingError(response));
          AppUtils.debug("error");
        }
      }else{
        emit(OnBoardingError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(OnBoardingError(AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }

  void handleGetCooperativePrivilegesEvent(GetCooperativePrivilegesEvent event)async{
    emit(OnboardingIsLoading());
    try{
      final response = await onboardingRepository.getCooperativePrivileges(event.cooperativeId);
      if(response is CheckIfCooperativeIsSetUpForElection){
        emit(GetCooperativePrivilegesSuccess (response));
      }else{
        emit(OnBoardingError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(OnBoardingError(AppUtils.defaultErrorResponse(msg: "Something went wrong")));
  }
}

}