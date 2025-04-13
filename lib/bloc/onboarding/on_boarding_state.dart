part of 'on_boarding_bloc.dart';

sealed class OnBoardingState extends Equatable {
  const OnBoardingState();
}

final class OnBoardingInitial extends OnBoardingState {
  @override
  List<Object> get props => [];
}
class OnboardingIsLoading extends OnBoardingState{
  @override
  List<Object> get props =>[];
}

class OnBoardingError extends OnBoardingState{
  final UcpDefaultResponse errorResponse;
  const OnBoardingError(this.errorResponse);
  @override
  List<Object?> get props => [errorResponse];
}

class AllCooperatives extends OnBoardingState{
  final List<CooperativeListResponse> response;
  const AllCooperatives(this.response);
  @override
  List<Object?> get props => [response];
}

class AllUcpCountries extends OnBoardingState{
  final List<AllCountriesResponse> response;
  const AllUcpCountries(this.response);
  @override
  List<Object?> get props => [response];
}

class AllUcpStates extends OnBoardingState{
  final List<AllStateResponse> response;
  const AllUcpStates(this.response);
  @override
  List<Object?> get props => [response];
}

class CreateAccountSuccess extends OnBoardingState{
  final SignUpResponse response;
  const CreateAccountSuccess(this.response);
  @override
  List<Object?> get props => [response];
}

class LoginSuccess extends OnBoardingState {
  final LoginResponse response;

  const LoginSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class GetNextMemberIdSuccess extends OnBoardingState{
  final NextMemberId response;
   GetNextMemberIdSuccess(this.response);
  @override
  List<Object?> get props => [response];
}

class ShopItemsLoaded extends OnBoardingState{
  final List<ShopItemList> response;
  ShopItemsLoaded(this.response);
  @override
  List<Object?> get props => [response];
}

class LoginOTPSuccessful extends OnBoardingState{
  final OTPValidationResponse response;
  LoginOTPSuccessful(this.response);
  @override
  List<Object?> get props => [response];
}

class SignUpOTPSuccessful extends OnBoardingState{
  final OTPValidationResponse response;
  SignUpOTPSuccessful(this.response);
  @override
  List<Object?> get props => [response];
}

class MemberSignUpCostSuccess extends OnBoardingState{
  final MemberSignUpCost response;
  MemberSignUpCostSuccess(this.response);
  @override
  List<Object?> get props => [response];
}

class MemberForgotPasswordSuccess extends OnBoardingState{
  final UcpDefaultResponse response;
  MemberForgotPasswordSuccess(this.response);
  @override
  List<Object?> get props => [response];
}

class GetCooperativePrivilegesSuccess extends OnBoardingState{
  final CheckIfCooperativeIsSetUpForElection response;
  GetCooperativePrivilegesSuccess(this.response);
  @override
  List<Object?> get props => [response];
}