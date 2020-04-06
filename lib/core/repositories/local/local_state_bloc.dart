import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:gtd/core/repositories/local/local_repository.dart';
import 'package:equatable/equatable.dart';

part 'local_state.dart';
part 'local_state_event.dart';

class LocalStatusBloc extends Bloc<LocalStatusEvent, LocalState> {
  final GlobalKey<NavigatorState> localStatusKey;
  final LocalRepository localRepository;

  LocalStatusBloc({@required this.localStatusKey, @required this.localRepository})
  : assert(localRepository != null);

  @override
  LocalState get initialState => Unknown();

  @override
  Stream<LocalState> mapEventToState(LocalStatusEvent event) async* {
    switch (event) {
      case LocalStatusEvent.CompleteOnboardingAction:
        await localRepository.completeOnboard();
          yield OnboardingCompleted();
        break;
      case LocalStatusEvent.CheckIfOnboardingIsCompleted:
        bool isCompleted = await localRepository.isOnboardingCompleted();
        print('Is onboarding completed: $isCompleted');
        if (isCompleted) {
          yield OnboardingCompleted();
        } else {
          yield OnboardingNotCompleted();
        }
        break;
    }
  }
}
