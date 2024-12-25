import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ucp/data/repository/votingRepo.dart';

part 'voting_event.dart';
part 'voting_state.dart';

class VotingBloc extends Bloc<VotingEvent, VotingState> {
  VoteRepository voteRepository = VoteRepository();
  VotingBloc(VoteRepository voteRepository) : super(VotingInitial()) {
    on<VotingEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
