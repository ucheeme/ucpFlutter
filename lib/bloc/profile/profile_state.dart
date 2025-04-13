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

class UcpBanks extends ProfileState{
  List<ListOfBank> response;
  UcpBanks(this.response);
  @override
  List<Object> get props => [response];
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

class MemberBankDetailsAdded extends ProfileState {
  UcpDefaultResponse data;
  MemberBankDetailsAdded(this.data);
  @override
  List<Object> get props => [data];
}

class MemberImageState extends ProfileState{
  MemberImageResponse response;
  MemberImageState(this.response);
  @override
  List<Object> get props => [response];
}