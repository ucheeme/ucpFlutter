part of 'on_boarding_bloc.dart';

sealed class OnBoardingEvent extends Equatable {
  const OnBoardingEvent();
}

class GetAllCooperativesEvent extends OnBoardingEvent{
  const GetAllCooperativesEvent();
  @override
  List<Object> get props => [];
}

class CreateAccountEvent extends OnBoardingEvent{
  final SignupRequest request;
  const CreateAccountEvent(this.request);
  @override
  List<Object> get props => [];
}

class LoginEvent extends OnBoardingEvent{
  final LoginRequest request;
  const LoginEvent(this.request);
  @override
  List<Object> get props => [];
}

class GetNextMemberIdEvent extends OnBoardingEvent{
  int cooperativeId;
   GetNextMemberIdEvent(this.cooperativeId);
  @override
  List<Object> get props => [];
}

class SendSignUpOtpEvent extends OnBoardingEvent{
  SignupOtpRequest request;
  SendSignUpOtpEvent(this.request);
  @override
  List<Object> get props => [];
}

class SendLoginOtpEvent extends OnBoardingEvent{
  LoginSendOtpRequest request;
  SendLoginOtpEvent(this.request);
  @override
  List<Object> get props => [];
}