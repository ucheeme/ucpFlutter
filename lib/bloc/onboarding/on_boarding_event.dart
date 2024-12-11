part of 'on_boarding_bloc.dart';

sealed class OnBoardingEvent extends Equatable {
  const OnBoardingEvent();
}
class GetAllCooperativesEvent extends OnBoardingEvent{
  const GetAllCooperativesEvent();
  @override
  List<Object> get props => [];
}