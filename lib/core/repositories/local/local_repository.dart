import 'package:shared_preferences/shared_preferences.dart';

import '../repository.dart';

class LocalRepository extends Repository {
  LocalRepository._privateConstructor() {}

  static final LocalRepository _instance =
      LocalRepository._privateConstructor();

  static LocalRepository get instance => _instance;

  Future<void> completeOnboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingCompleted', true);
  }

  Future<bool> isOnboardingCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isOnboardingCompleted = prefs.getBool('isOnboardingCompleted') ?? false;
    return isOnboardingCompleted;
  }
}
