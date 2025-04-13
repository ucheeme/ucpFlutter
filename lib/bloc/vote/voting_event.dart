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

class GetElectionDetailsEvent extends VotingEvent {
  String electionId;
  GetElectionDetailsEvent(this.electionId);
  List<Object> get props => [];
}
class VoteCandidateEvent extends VotingEvent {
  CastVote castVote;
  VoteCandidateEvent(this.castVote);
  @override
  List<Object> get props => [];
}

class GetElectionResultEvent extends VotingEvent {
 GetElectionResultRequest request;
  GetElectionResultEvent(this.request);
  @override
  List<Object> get props => [];
}

class GetElectionInfoEvent extends VotingEvent {
  GetElectionResultRequest request;
  GetElectionInfoEvent(this.request);
  @override
  List<Object> get props => [];
}