import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ucp/data/repository/profileRepo.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileRepository profileRepository =ProfileRepository();
  ProfileBloc(ProfileRepository profileRepository) : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
