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

  LocalStatusBloc(
      {@required this.localStatusKey, @required this.localRepository})
      : assert(localRepository != null);

  @override
  LocalState get initialState => Unknown();

  @override
  Stream<LocalState> mapEventToState(LocalStatusEvent event) async* {
    if (event is CompleteOnboardingAction) {
      await localRepository.completeOnboard();
      yield OnboardingCompleted();
    } else if (event is CheckIfOnboardingIsCompleted) {
      bool isCompleted = await localRepository.isOnboardingCompleted();
      if (isCompleted) {
        yield OnboardingCompleted();
      } else {
        yield OnboardingNotCompleted();
      }
    } else if (event is SetGTDLevel) {
      await localRepository.setGTDLevel(event.level);
      yield GTDLevelKnown();
    } else if (event is CheckIfGTDLevelIsKnwon) {
      String gtdLevel = await localRepository.getGTDLevel();
      if (gtdLevel != null) {
        yield GTDLevelKnown();
      } else {
        yield GTDLevelUnknown();
      }
    } else if (event is Logout) {
      await localRepository.logout();
      yield Unknown();
    } else if(event is LoadLocalSettings) {
      yield* _mapLoadLocalSettingsToState();
    } else if (event is UpdateGTDLevel) {
      await localRepository.setGTDLevel(event.level);
      yield SettingsSaved();
    } else if (event is SetNotificationsAllowed) {
      await localRepository.setNotificationsAllowed(event.notificationsAllowed);
      yield SettingsSaved();
    }
  }

  Stream<LocalState> _mapLoadLocalSettingsToState() async* {
    yield SettingsLoaded(gtdLevel: await localRepository.getGTDLevel(), reviewNotifications: await localRepository.getNotificationsAllowed());
  }
}
