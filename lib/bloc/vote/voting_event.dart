part of 'voting_bloc.dart';

sealed class VotingEvent extends Equatable {
  const VotingEvent();
}
class GetEligiblePositionEvent extends VotingEvent {
  PaginationRequest paginationRequest;
   GetEligiblePositionEvent(this.paginationRequest);
  @override
  List<Object> get props => [];
}

class ApplyAsACandidateForElectionEvent extends VotingEvent {
  ApplyAsContestantForElectionRequest applyAsContestantForElectionRequest;
  ApplyAsACandidateForElectionEvent(this.applyAsContestantForElectionRequest);
  @override
  List<Object> get props => [];
}