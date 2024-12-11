import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ucp/data/model/response/cooperativeList.dart';
import 'package:ucp/data/model/response/defaultResponse.dart';
import 'package:ucp/data/repository/onboarding.dart';

import '../../utils/apputils.dart';
import 'onBoardingValidation.dart';

part 'on_boarding_event.dart';
part 'on_boarding_state.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  OnboardingValidation validation= OnboardingValidation();
  OnboardingRepo onboardingRepository;
  var errorObs = PublishSubject<String>();
  OnBoardingBloc({required this.onboardingRepository}) : super(OnBoardingInitial()) {
    on<OnBoardingEvent>((event, emit) {});
    on<GetAllCooperativesEvent>((event, emit){handleGetAllCooperativesEvent();});
  }
  void handleGetAllCooperativesEvent()async{
    emit(OnboardingIsLoading());
    try {
      final response = await onboardingRepository.getCooperatives();
      // final response = await onboardingRepository.newUser(event.request);
      if (response is List<CooperativeListResponse>) {
        emit(AllCooperatives(response));
        AppUtils.debug("success");
      }else{
        emit(OnBoardingError(response as UcpDefaultResponse));
        AppUtils.debug("error");
      }
    }catch(e,trace){
      print(trace);
      emit(OnBoardingError(AppUtils.defaultErrorResponse(msg: e.toString())));
    }
  }
  initial(){
    emit(OnBoardingInitial());
  }
}
