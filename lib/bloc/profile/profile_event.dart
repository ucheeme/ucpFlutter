part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
}
class GetMemberProfileEvent extends ProfileEvent {
  const GetMemberProfileEvent();
  @override
  List<Object> get props => [];
}

class UpdateProfileEvent extends ProfileEvent {
  final UpdateProfileRequest request;
  const UpdateProfileEvent(this.request);
  @override
  List<Object> get props => [request];
}

class ChangePasswordEvent extends ProfileEvent {
  final ChangePasswordRequest request;
  const ChangePasswordEvent(this.request);
  @override
  List<Object> get props => [request];
}
class GetMemberSavingAccountsEvent extends ProfileEvent {
  const GetMemberSavingAccountsEvent();
  @override
  List<Object> get props => [];
}
class GetListOfBank extends ProfileEvent {
  const GetListOfBank();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddMemberBankAccountDetails extends ProfileEvent {
  final AddBankDetailRequest request;
  const AddMemberBankAccountDetails(this.request);
  @override
  List<Object> get props => [request];
}
class GetMemberImage extends ProfileEvent{
  const GetMemberImage();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}