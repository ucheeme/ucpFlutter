part of 'voting_bloc.dart';

sealed class VotingState extends Equatable {
  const VotingState();
}

final class VotingInitial extends VotingState {
  @override
  List<Object> get props => [];
}
