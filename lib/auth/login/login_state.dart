import 'package:meta/meta.dart';

@immutable
class LoginState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool areCredentialsValid;
  final bool isEmailVerified;
  final bool hasSentRecoveryEmail;

  bool get isFormValid => isEmailValid && isPasswordValid;

  LoginState(
      {@required this.isEmailValid,
      @required this.isPasswordValid,
      @required this.isSubmitting,
      @required this.isSuccess,
      @required this.isFailure,
      @required this.isEmailVerified,
      @required this.areCredentialsValid,
      @required this.hasSentRecoveryEmail});

  factory LoginState.empty() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false,
        isEmailVerified: false,
        areCredentialsValid: true,
        hasSentRecoveryEmail: false);
  }

  factory LoginState.loading() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false,
        isEmailVerified: false,
        areCredentialsValid: true,
        hasSentRecoveryEmail: false);
  }

  factory LoginState.failure() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        isEmailVerified: false,
        areCredentialsValid: true,
        hasSentRecoveryEmail: false);
  }

  factory LoginState.invalidCredentials() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        isEmailVerified: false,
        areCredentialsValid: false,
        hasSentRecoveryEmail: false);
  }

  factory LoginState.success() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false,
        isEmailVerified: true,
        areCredentialsValid: true,
        hasSentRecoveryEmail: false);
  }

  factory LoginState.emailNotVerified() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false,
        isEmailVerified: false,
        areCredentialsValid: true,
        hasSentRecoveryEmail: false);
  }

  factory LoginState.recoveryEmailSent() {
    return LoginState(
        isEmailValid: true,
        isPasswordValid: false,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false,
        isEmailVerified: false,
        areCredentialsValid: false,
        hasSentRecoveryEmail: true);
  }

  LoginState update({
    bool isEmailValid,
    bool isPasswordValid,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      isEmailVerified: false,
    );
  }

  LoginState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    bool isEmailVerified,
    bool hasSentRecoveryEmail,
  }) {
    return LoginState(
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified,
        areCredentialsValid: areCredentialsValid ?? this.areCredentialsValid,
        hasSentRecoveryEmail:
            hasSentRecoveryEmail ?? this.hasSentRecoveryEmail);
  }

  @override
  String toString() {
    return '''LoginState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      isEmailVerified: $isEmailVerified,
      areCredentialsValid: $areCredentialsValid,
      hasSentRecoveryEmail: $hasSentRecoveryEmail,
    }''';
  }
}
