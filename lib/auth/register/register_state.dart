import 'package:meta/meta.dart';

@immutable
class RegisterState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isPasswordTheSame;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool isEmailAlreadyExists;

  bool get isFormValid => isEmailValid && isPasswordValid && isPasswordTheSame;

  RegisterState({
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isPasswordTheSame,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.isEmailAlreadyExists,
  });

  factory RegisterState.empty() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      isPasswordTheSame: true,
      isEmailAlreadyExists: false
    );
  }

  factory RegisterState.loading() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordTheSame: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      isEmailAlreadyExists: false
    );
  }

  factory RegisterState.failure() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordTheSame: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      isEmailAlreadyExists: false
    );
  }

  factory RegisterState.success() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordTheSame: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      isEmailAlreadyExists: false
    );
  }

    factory RegisterState.emailInUse() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordTheSame: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      isEmailAlreadyExists: true
    );
  }

  RegisterState update({
    bool isEmailValid,
    bool isPasswordValid, isPasswordTheSame,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isPasswordTheSame: isPasswordTheSame,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  RegisterState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    bool isPasswordTheSame,
    bool isEmailAlreadyExists
  }) {
    return RegisterState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isPasswordTheSame: isPasswordTheSame ?? this.isPasswordTheSame,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      isEmailAlreadyExists: isEmailAlreadyExists ?? this.isEmailAlreadyExists
    );
  }

  @override
  String toString() {
    return '''RegisterState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isPasswordTheSame: $isPasswordTheSame,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      isEmailAlreadyExists: $isEmailAlreadyExists
    }''';
  }
}
