import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ucp/data/model/response/defaultResponse.dart';
import 'package:ucp/data/model/response/memberData.dart';
import 'package:ucp/data/repository/profileRepo.dart';

import '../../utils/apputils.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileRepository profileRepository =ProfileRepository();
  ProfileBloc(ProfileRepository profileRepository) : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) {});
    on<GetMemberProfileEvent>((event, emit) {handleGetMemberProfileEvent();});

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
  initial(){
    emit(ProfileInitial());
  }
}
