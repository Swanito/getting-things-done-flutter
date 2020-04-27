import 'package:bloc_test/bloc_test.dart';
import 'package:gtd/core/keys.dart';
import 'package:gtd/core/repositories/local/local_repository.dart';
import 'package:gtd/core/repositories/local/local_state_bloc.dart';
import 'package:mockito/mockito.dart';

class MockLocalRepository extends Mock implements LocalRepository {}

void main() {
  final _mockLocalRepository = MockLocalRepository();
  blocTest('element bloc initial status is correct',
      build: () async => LocalStatusBloc(
          localStatusKey: GtdKeys.localStatusKey,
          localRepository: _mockLocalRepository),
      skip: 0,
      expect: [Unknown()]);

  blocTest(
    'CompleteOnboardingAction yields OnboardingCompleted',
    build: () async {
      return LocalStatusBloc(
          localStatusKey: GtdKeys.localStatusKey,
          localRepository: _mockLocalRepository);
    },
    act: (bloc) => bloc.add(CompleteOnboardingAction()),
    expect: [OnboardingCompleted()],
  );

  blocTest(
    'CheckIfOnboardingIsCompleted when is completed yields OnboardingCompleted',
    build: () async {
      when(_mockLocalRepository.isOnboardingCompleted())
          .thenAnswer((_) async => true);
      return LocalStatusBloc(
          localStatusKey: GtdKeys.localStatusKey,
          localRepository: _mockLocalRepository);
    },
    act: (bloc) => bloc.add(CheckIfOnboardingIsCompleted()),
    expect: [OnboardingCompleted()],
  );

  blocTest(
    'CheckIfOnboardingIsCompleted when is not completed yields OnboardingCompleted',
    build: () async {
      when(_mockLocalRepository.isOnboardingCompleted())
          .thenAnswer((_) async => false);
      return LocalStatusBloc(
          localStatusKey: GtdKeys.localStatusKey,
          localRepository: _mockLocalRepository);
    },
    act: (bloc) => bloc.add(CheckIfOnboardingIsCompleted()),
    expect: [OnboardingNotCompleted()],
  );

  blocTest(
    'SetGTDLevel yields GTDLevelKnown',
    build: () async {
      return LocalStatusBloc(
          localStatusKey: GtdKeys.localStatusKey,
          localRepository: _mockLocalRepository);
    },
    act: (bloc) => bloc.add(SetGTDLevel(level: GTDLevel.High)),
    expect: [GTDLevelKnown()],
  );

  blocTest(
    'CheckIfGTDLevelIsKnwon when is not known yields GTDLevelUnknown',
    build: () async {
      when(_mockLocalRepository.getGTDLevel()).thenAnswer((_) async => null);
      return LocalStatusBloc(
          localStatusKey: GtdKeys.localStatusKey,
          localRepository: _mockLocalRepository);
    },
    act: (bloc) => bloc.add(CheckIfGTDLevelIsKnwon()),
    expect: [GTDLevelUnknown()],
  );

  blocTest(
    'CheckIfGTDLevelIsKnwon when is known yields GTDLevelKnown',
    build: () async {
      when(_mockLocalRepository.getGTDLevel())
          .thenAnswer((_) async => 'algo no nulo');
      return LocalStatusBloc(
          localStatusKey: GtdKeys.localStatusKey,
          localRepository: _mockLocalRepository);
    },
    act: (bloc) => bloc.add(CheckIfGTDLevelIsKnwon()),
    expect: [GTDLevelKnown()],
  );

  blocTest(
    'Logout yields OnboardingNotCompleted',
    build: () async {
      return LocalStatusBloc(
          localStatusKey: GtdKeys.localStatusKey,
          localRepository: _mockLocalRepository);
    },
    act: (bloc) => bloc.add(Logout()),
    expect: [OnboardingNotCompleted()],
  );

  blocTest(
    'UpdateGTDLevel yields SettingsSaved',
    build: () async {
      return LocalStatusBloc(
          localStatusKey: GtdKeys.localStatusKey,
          localRepository: _mockLocalRepository);
    },
    act: (bloc) => bloc.add(UpdateGTDLevel(level: GTDLevel.Low)),
    expect: [SettingsSaved()],
  );

  blocTest(
    'SetNotificationsAllowed yields SettingsSaved',
    build: () async {
      return LocalStatusBloc(
          localStatusKey: GtdKeys.localStatusKey,
          localRepository: _mockLocalRepository);
    },
    act: (bloc) =>
        bloc.add(SetNotificationsAllowed(notificationsAllowed: true)),
    expect: [SettingsSaved()],
  );
}
