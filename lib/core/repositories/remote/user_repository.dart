import 'package:firebase_auth/firebase_auth.dart';
import 'package:gtd/core/repositories/repository.dart';

class UserRepository extends UserAbstractRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Performs a login in Firebase using the email and password
  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Creates an account in Firebase using the email and password
  Future<void> signUp({String email, String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Sends the verification email to the given `FirebaseUser`
  Future<void> sendEmailVerificationLink(FirebaseUser user) async {
    return await user.sendEmailVerification();
  }

  /// Ends the Firebase sessions
  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }

  /// Returns `true` if the user is logged in, `false` if not.
  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  /// Get the email from the current user
  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).email;
  }

  /// Get the full profile from the current user.
  Future<FirebaseUser> getUserProfile() async {
    return (await _firebaseAuth.currentUser());
  }

  /// Returns `true` if the email is verified, `false` if not.
  Future<bool> isEmailVerified() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser.isEmailVerified;
  }

  /// Send the password reset email.
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
