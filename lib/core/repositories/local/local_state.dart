part of 'local_state_bloc.dart';

abstract class LocalState extends Equatable {
  @override
  List<Object> get props => [];
}

class Unknown extends LocalState {
}

class OnboardingCompleted extends LocalState {
}
class OnboardingNotCompleted extends LocalState {
}