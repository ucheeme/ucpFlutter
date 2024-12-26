part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}
class ProfileLoading extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileError extends ProfileState {
  UcpDefaultResponse errorResponse;
  ProfileError( this.errorResponse);
  @override
  List<Object> get props => [errorResponse];
}

class ProfileLoaded extends ProfileState {
  MemberProfileData data;
  ProfileLoaded( this.data);
  @override
  List<Object> get props => [data];
}
