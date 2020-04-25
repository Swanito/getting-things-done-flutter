part of 'local_state_bloc.dart';

abstract class LocalState extends Equatable {
  const LocalState();

  @override
  List<Object> get props => [];
}

class Unknown extends LocalState {}

class OnboardingCompleted extends LocalState {}

class OnboardingNotCompleted extends LocalState {}

class GTDLevelUnknown extends LocalState {}

class GTDLevelKnown extends LocalState {}

class SettingsLoaded extends LocalState {
  final String gtdLevel;
  final bool reviewNotifications;

  const SettingsLoaded({@required this.gtdLevel, @required this.reviewNotifications});

  @override
  List<Object> get props => [gtdLevel];

  @override
  String toString() {
    return 'SettingsLoaded { gtdLevel: $gtdLevel, notifications: $reviewNotifications }';
  }

}

class SettingsSaved extends LocalState {}