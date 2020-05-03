import 'package:bloc_test/bloc_test.dart';
import 'package:gtd/auth/authentication_bloc.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  MockUserRepository _mockUserRepository = MockUserRepository();
  blocTest('authentication bloc initial state is correct',
      build: () async =>
          AuthenticationBloc(userRepository: _mockUserRepository),
      skip: 0,
      expect: [Uninitialized()]);

  blocTest(
    'AppStarted and user is logged in yields Authenticated',
    build: () async {
      when(_mockUserRepository.isSignedIn()).thenAnswer((_) async => true);
      when(_mockUserRepository.getUser()).thenAnswer((_) async => 'User');
      return AuthenticationBloc(userRepository: _mockUserRepository);
    },
    act: (bloc) => bloc.add(AppStarted()),
    expect: [Authenticated('User')],
  );

  blocTest(
    'AppStarted and user is not logged in yields Authenticated',
    build: () async {
      when(_mockUserRepository.isSignedIn()).thenAnswer((_) async => false);
      return AuthenticationBloc(userRepository: _mockUserRepository);
    },
    act: (bloc) => bloc.add(AppStarted()),
    expect: [Unauthenticated()],
  );

  blocTest(
    'LoggedIn yields Authenticated',
    build: () async {
      when(_mockUserRepository.getUser()).thenAnswer((_) async => 'User');
      return AuthenticationBloc(userRepository: _mockUserRepository);
    },
    act: (bloc) => bloc.add(LoggedIn()),
    expect: [Authenticated('User')],
  );

  blocTest(
    'LoggedOut yields Unauthenticated',
    build: () async {
      return AuthenticationBloc(userRepository: _mockUserRepository);
    },
    act: (bloc) => bloc.add(LoggedOut()),
    expect: [Unauthenticated()],
  );

  blocTest(
    'RegisterCompleted yields Unauthenticated',
    build: () async {
      return AuthenticationBloc(userRepository: _mockUserRepository);
    },
    act: (bloc) => bloc.add(RegisterCompleted()),
    expect: [Unauthenticated()],
  );
}
