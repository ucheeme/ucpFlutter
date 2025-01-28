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

class ProfileUpdated extends ProfileState {
  ProfileUpdateResponse data;
  ProfileUpdated( this.data);
  @override
  List<Object> get props => [data];
}

class PasswordChanged extends ProfileState {
  ProfileUpdateResponse data;
  PasswordChanged(this.data);
  @override
  List<Object> get props => [];
}

class MemberSavingAccountsLoaded extends ProfileState {
  List<MemberSavingAccounts> data;
  MemberSavingAccountsLoaded(this.data);
  @override
  List<Object> get props => [data];
}