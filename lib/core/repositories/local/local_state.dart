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

  const SettingsLoaded({@required this.gtdLevel});

  @override
  List<Object> get props => [gtdLevel];

  @override
  String toString() {
    return 'SettingsLoaded { gtdLevel: $gtdLevel }';
  }

}
