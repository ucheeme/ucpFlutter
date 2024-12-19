import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ucp/data/model/request/loginOtpRequest.dart';
import 'package:ucp/data/model/request/signUpSendOtp.dart';
import 'package:ucp/data/model/response/cooperativeList.dart';
import 'package:ucp/data/model/response/defaultResponse.dart';
import 'package:ucp/data/repository/onboardingRepo.dart';

import '../../data/model/request/loginReq.dart';
import '../../data/model/request/signUpReq.dart';
import '../../data/model/response/loginOtpValidationResponse.dart';
import '../../data/model/response/loginResponse.dart';
import '../../data/model/response/nextMemberIdResponse.dart';
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
    on<CreateAccountEvent>((event, emit)async{handleCreateAccountEvent(event);});
    on<LoginEvent>((event, emit)async{handleLoginEvent(event);});
    on<GetNextMemberIdEvent>((event, emit)async{handleGetNextMemberIdEvent(event);});
    on<SendSignUpOtpEvent>((event, emit)async{handleSendSignUpOtpEvent(event);});
    on<SendLoginOtpEvent>((event, emit)async{handleSendLoginOtpEvent(event);});
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
      emit(OnBoardingError(AppUtils.defaultErrorResponse(msg: e.toString())));
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
      emit(OnBoardingError(AppUtils.defaultErrorResponse(msg: e.toString())));
    }
  }

  void handleLoginEvent(LoginEvent event) async{
    emit(OnboardingIsLoading());
    try {
      final response = await onboardingRepository.loginUser(event.request);
      if (response is LoginResponse) {
        emit(LoginSuccess(response));
        AppUtils.debug("success");
      }else{
        emit(OnBoardingError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }    }catch(e,trace){
      print(trace);
      emit(OnBoardingError(AppUtils.defaultErrorResponse(msg: e.toString())));
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
      emit(OnBoardingError(AppUtils.defaultErrorResponse(msg: e.toString())));
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
      emit(OnBoardingError(AppUtils.defaultErrorResponse(msg: e.toString())));
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
      emit(OnBoardingError(AppUtils.defaultErrorResponse(msg: e.toString())));
    }
  }
}
