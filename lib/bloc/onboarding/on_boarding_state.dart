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