import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    } else if(event is RegisterCompleted) {
      yield* _mapRegisterCompletedEvent();
    } else if (event is ResendVerificationEmail) {
      yield* _mapResendVerificationEmailEvent();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final name = await _userRepository.getUser();
        yield Authenticated(name);
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated(await _userRepository.getUser());
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    await _userRepository.signOut();
  }

  Stream<AuthenticationState> _mapRegisterCompletedEvent() async* {
    yield Unauthenticated();
    final user = await _userRepository.getUserProfile();
    await _userRepository.sendEmailVerificationLink(user);
  } 

  Stream<AuthenticationState> _mapResendVerificationEmailEvent() async* {
    yield Unauthenticated();
    final user = await _userRepository.getUserProfile();
    await _userRepository.sendEmailVerificationLink(user);
  } 
}
