import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:gtd/auth/login/login_event.dart';
import 'package:gtd/auth/login/login_state.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/core/validators/login_validators.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> transformEvents(
    Stream<LoginEvent> events,
    Stream<LoginState> Function(LoginEvent event) next,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
    );
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    } else if(event is ResetPassword) {
      yield* _mapResetPasswordToState(event);
    } else if (event is ResendVerificationEmail) {
      yield* _mapResendVerificationEmailEvent();
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: AuthValidators.isValidEmail(email),
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: AuthValidators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapResetPasswordToState(ResetPassword event) async* {
    try {
      await _userRepository.resetPassword(event.email);
      yield LoginState.recoveryEmailSent();
    } catch (error) {
      yield LoginState.failure();
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield LoginState.loading();
    try {
      await _userRepository.signInWithCredentials(email, password);
      if (await _userRepository.isEmailVerified()) {
        yield LoginState.success();
      } else {
        await _userRepository.sendEmailVerificationLink(await _userRepository.getUserProfile());
        yield LoginState.emailNotVerified();
      }
    } catch (error) {
      if (error.code == "ERROR_WRONG_PASSWORD" || error.code == "ERROR_USER_NOT_FOUND") {
        yield LoginState.invalidCredentials();
      } else {
        yield LoginState.failure();
      }
    }
  }

    Stream<LoginState> _mapResendVerificationEmailEvent() async* {
    final user = await _userRepository.getUserProfile();
    await _userRepository.sendEmailVerificationLink(user);
    yield LoginState.recoveryEmailSent();
  } 
}
