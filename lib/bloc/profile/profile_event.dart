part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
}
class GetMemberProfileEvent extends ProfileEvent {
  const GetMemberProfileEvent();
  @override
  List<Object> get props => [];
}