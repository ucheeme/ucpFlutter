import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ucp/data/model/response/defaultResponse.dart';
import 'package:ucp/data/repository/FinanceRepo.dart';
import 'package:ucp/data/repository/votingRepo.dart';

import '../../data/model/request/applyAsContestant.dart';
import '../../data/model/request/castVoteRequest.dart';
import '../../data/model/response/allElections.dart';
import '../../data/model/response/electionDetailResponse.dart';
import '../../utils/apputils.dart';

part 'voting_event.dart';
part 'voting_state.dart';

class VotingBloc extends Bloc<VotingEvent, VotingState> {
  VoteRepository voteRepository = VoteRepository();

  VotingBloc(VoteRepository voteRepository) : super(VotingInitial()) {
    on<VotingEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<GetEligiblePositionEvent>((event, emit) async {
      handleGetEligiblePositionEvent(event);
    });
    on<ApplyAsACandidateForElectionEvent>((event, emit) async {
      handleApplyAsACandidateForElectionEvent(event);
    });

    on<GetElectionDetailsEvent>((event, emit)async{
      handleGetElectionDetailsEvent(event);
    });
    on<VoteCandidateEvent>((event, emit) async {
      emit(VotingIsLoading());
      try {
        final response = await voteRepository.voteCandidate(event.castVote);
        if (response is UcpDefaultResponse) {
          emit(VotedForCandidate(response));
        } else {
          emit(VotingError(response as UcpDefaultResponse));
        }
      } catch (e, trace) {
        print(trace);
        print(e);
        emit(VotingError(
            AppUtils.defaultErrorResponse(msg: "Something went wrong")));
      }
    });
  }

  void handleGetEligiblePositionEvent(GetEligiblePositionEvent event) async {
    emit(VotingIsLoading());
    try {
      final response = await voteRepository.getEligiblePosition(
          event.paginationRequest);
      if (response is AllElections) {
        emit(PositionEligibleLoaded(response));
      } else {
        emit(VotingError(response as UcpDefaultResponse));
      }
    } catch (e, trace) {
      print(trace);
      print(e);
      emit(VotingError(
          AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }

  void initial() {
    emit(VotingInitial());
  }

  void handleGetElectionDetailsEvent(GetElectionDetailsEvent event)async{
    emit(VotingIsLoading());
    try{
      final response = await voteRepository.getElectionDetails(
          event.electionId);
      if (response is ElectionDetails) {
        emit(ElectionDetailLoaded(response));
        print("I amherrrrrrrrr");
      } else {
        emit(VotingError(response as UcpDefaultResponse));
      }

    }catch(e,trace){
      print(e);
      print(trace);
      emit(VotingError(AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }

  void handleApplyAsACandidateForElectionEvent(
      ApplyAsACandidateForElectionEvent event)
  async {
    emit(VotingIsLoading());
    try {
      final response = await voteRepository.applyAsACandidateForElection(
          event.applyAsContestantForElectionRequest);
      if (response is UcpDefaultResponse) {
        if(response.isSuccessful){
          emit(PositionApplied(response));
        }else{
          emit(VotingError(response as UcpDefaultResponse));
        }
      } else {
        emit(VotingError(response as UcpDefaultResponse));
      }
    }catch(e,trace){
      print(trace);
      print(e);
      emit(VotingError(
          AppUtils.defaultErrorResponse(msg: "Something went wrong")));
    }
  }
}
