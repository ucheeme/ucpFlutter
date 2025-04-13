part of 'voting_bloc.dart';

sealed class VotingState extends Equatable {
  const VotingState();
}

final class VotingInitial extends VotingState {
  @override
  List<Object> get props => [];
}
class VotingIsLoading extends VotingState {
  @override
  List<Object> get props => [];
}
class VotingError extends VotingState {
  final UcpDefaultResponse errorResponse;
  VotingError(this.errorResponse);
  @override
  List<Object> get props => [errorResponse];
}
class PositionEligibleLoaded extends VotingState {
   AllElections allElections;
   PositionEligibleLoaded(this.allElections);
  @override
  List<Object> get props => [allElections];
}
class PositionApplied extends VotingState {
  final UcpDefaultResponse response;
  PositionApplied(this.response);
  @override
  List<Object> get props => [response];
}

class ApplyAsACandidateForElectionLoaded extends VotingState {
  final UcpDefaultResponse response;
  ApplyAsACandidateForElectionLoaded(this.response);
  @override
  List<Object> get props => [response];
}

class ElectionDetailLoaded extends VotingState {
  final ElectionDetails response;
  ElectionDetailLoaded(this.response);
  @override
  List<Object> get props => [response];
}

class ElectionResultLoaded extends VotingState {
  final ElectionResult response;
  ElectionResultLoaded(this.response);
  @override
  List<Object> get props => [response];
}

class VotedForCandidate extends VotingState {
  final UcpDefaultResponse response;
  VotedForCandidate(this.response);
  @override
  List<Object> get props => [response];
}

class ElectionInfoLoaded extends VotingState {
  final ElectionInfoResponse response;
  ElectionInfoLoaded(this.response);
  @override
  List<Object> get props => [response];
}