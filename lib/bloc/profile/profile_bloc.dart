import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ucp/bloc/profile/profileController.dart';
import 'package:ucp/data/model/request/rescheduleContributionRequest.dart';
import 'package:ucp/data/model/response/defaultResponse.dart';
import 'package:ucp/data/model/response/getMemberCurrentMonthlyContribution.dart';
import 'package:ucp/data/model/response/memberData.dart';
import 'package:ucp/data/model/response/memberSavingAccounts.dart';
import 'package:ucp/data/repository/profileRepo.dart';

import '../../data/model/request/addMemberBankDetailRequest.dart';
import '../../data/model/request/changePasswordRequest.dart';
import '../../data/model/request/updateProfileRequest.dart';
import '../../data/model/response/listOfBankResponse.dart';
import '../../data/model/response/memberImageResponse.dart';
import '../../data/model/response/memberSavingAccount.dart';
import '../../data/model/response/profileUpdateResponse.dart';
import '../../utils/apputils.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileController validation = ProfileController();
  ProfileRepository profileRepository =ProfileRepository();
  ProfileBloc(ProfileRepository profileRepository) : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) {});
    on<GetMemberProfileEvent>((event, emit) {handleGetMemberProfileEvent();});
    on<UpdateProfileEvent>((event, emit) {handleUpdateProfileEvent(event.request);});
    on<ChangePasswordEvent>((event, emit) {handleChangePasswordEvent(event);});
    on<GetMemberSavingAccountsEvent>((event, emit) {handleGetMemberSavingAccountsEvent();});
    on<GetListOfBank>((event,emit){handleGetListOfBank();});
    on<AddMemberBankAccountDetails>((event,emit){handleAddMemberBankAccountDetails(event.request);});
    on<GetMemberImage>((event,emit){handleGetMemberImage();});
    on<GetMemberCurrentMonthlyContributionEvent>((event,emit){handleGetMemberCurrentMonthlyContributionEvent();});
    on<RescheduleContributionEvent>((event,emit){handleRescheduleContributionEvent(event);});
  }
  void handleGetListOfBank()async{
    emit(ProfileLoading());
    try{
      final response = await profileRepository.getBanks();
      if (response is   List<ListOfBank>) {
        emit(UcpBanks(response));
        AppUtils.debug("success");
      }else{
        emit(ProfileError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(ProfileError(AppUtils.defaultErrorResponse(msg: "An Error Occurred")));
    }
  }
  void handleGetMemberProfileEvent()async{
    emit(ProfileLoading());
    try{
      final response = await profileRepository.getMemberProfile();
      if (response is MemberProfileData) {
        emit(ProfileLoaded(response));
        AppUtils.debug("success");
      }else{
        emit(ProfileError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(ProfileError(AppUtils.defaultErrorResponse(msg: "An Error Occurred")));
    }
  }
  void handleUpdateProfileEvent(UpdateProfileRequest request)async{
    emit(ProfileLoading());
    try{
      final response = await profileRepository.updateUserProfile(request);
      if (response is ProfileUpdateResponse) {
        emit(ProfileUpdated(response));
        AppUtils.debug("success");
      }else{
        print("the response is of typr ${response.runtimeType}");
        emit(ProfileError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(ProfileError(AppUtils.defaultErrorResponse(msg: "An Error Occurred")));
    }
  }
void handleChangePasswordEvent(event)async{
  emit(ProfileLoading());
  try{
    final response = await profileRepository.changePassword(event.request);
    if (response is ProfileUpdateResponse) {
      emit(PasswordChanged(response));
      AppUtils.debug("success");
    }else{
      emit(ProfileError(response as UcpDefaultResponse));
      AppUtils.debug("error");
    }
  }catch(e,trace){
    print(trace);
    emit(ProfileError(AppUtils.defaultErrorResponse(msg: "An Error Occurred")));
  }
}

void handleGetMemberSavingAccountsEvent()async{
  emit(ProfileLoading());
  try{
    final response = await profileRepository.getMemberSavingAccounts();
    if (response is List<MemberSavingAccounts>) {
      emit(MemberSavingAccountsLoaded(response));
      AppUtils.debug("success");
    }else{
      emit(ProfileError(response as UcpDefaultResponse));
      AppUtils.debug("error");
    }
  }catch(e,trace){
    print(trace);
    emit(ProfileError(AppUtils.defaultErrorResponse(msg: "An Error Occurred")));
  }
}

  initial(){
    emit(ProfileInitial());
  }

  void handleAddMemberBankAccountDetails(AddBankDetailRequest request)async{
    emit(ProfileLoading());
    try{
      final response = await profileRepository.addMemberBankAccountDetails(request);
      if (response is UcpDefaultResponse) {
        if(response.isSuccessful==true){
          emit(MemberBankDetailsAdded(response));
          AppUtils.debug("success");
        }else{
          emit(ProfileError(response as UcpDefaultResponse));
          AppUtils.debug("error");
        }

      }else{
        emit(ProfileError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(e);
      print(trace);
      emit(ProfileError(AppUtils.defaultErrorResponse()));
    }
  }
  void handleGetMemberImage()async{
    emit(ProfileLoading());
    try{
      final response = await profileRepository.getMemberImage();
      if (response is MemberImageResponse) {
        emit(MemberImageState(response));
        AppUtils.debug("success");
      }else{
        emit(ProfileError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(ProfileError(AppUtils.defaultErrorResponse(msg: "An Error Occurred")));
    }
  }
  
  void handleGetMemberCurrentMonthlyContributionEvent()async {
    emit(ProfileLoading());
    try{
      final response = await profileRepository.getMemberCurrentMonthlyContribution();
      if (response is GetMemberCurrentMonthlyContributionResponse) {
        emit(MemberCurrentMonthlyContributionState(response));
        AppUtils.debug("success");
        AppUtils.debug("yyyyyyyyy");
      }else{
        emit(ProfileError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(ProfileError(AppUtils.defaultErrorResponse(msg: "An Error Occurred")));
    }
  }
  
  void handleRescheduleContributionEvent(event)async {
    emit(ProfileLoading());
    try{
      final response = await profileRepository.rescheduleContribution(event.request);
      if (response is UcpDefaultResponse) {
        if(response.isSuccessful==true){
          emit(RescheduleContributionState(response));
          AppUtils.debug("success");
        }else{
          emit(ProfileError(response as UcpDefaultResponse));
          AppUtils.debug("error");
        }

      }else{
        emit(ProfileError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(ProfileError(AppUtils.defaultErrorResponse(msg: "An Error Occurred")));
    }
  }

  
}
