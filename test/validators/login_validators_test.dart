import 'package:flutter_test/flutter_test.dart';
import 'package:gtd/core/validators/login_validators.dart';

void main() {
  setUp(() => {});

  tearDown(() => {});

  test('user cannot enter an invalid email', () {
    String email = 'emailAtemail.com';
    bool isValid = AuthValidators.isValidEmail(email);
    expect(isValid, false);
  });

  test('user can enter an invalid email', () {
    String email = 'email@email.com';
    bool isValid = AuthValidators.isValidEmail(email);
    expect(isValid, true);
  });

  test('user cannot enter a password that doesn\'t meet the requirements', () {
    String password = 'password';
    bool isValid = AuthValidators.isValidPassword(password);
    expect(isValid, false);
  });

    test('user must enter a password that meets the requirements', () {
    String password = 'password1234';
    bool isValid = AuthValidators.isValidPassword(password);
    expect(isValid, true);
  });

    test('user cannot enter two different passwords', () {
    String firstPassword = 'password';
    String secondPassword = 'password2';
    bool isValid = AuthValidators.isPasswordTheSame(firstPassword, secondPassword);
    expect(isValid, false);
  });

      test('user must enter the same password twice', () {
    String firstPassword = 'password';
    String secondPassword = 'password';
    bool isValid = AuthValidators.isPasswordTheSame(firstPassword, secondPassword);
    expect(isValid, true);
  });
}
