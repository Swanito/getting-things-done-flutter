import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/auth/auth_screen.dart';
import 'package:gtd/auth/authentication_bloc.dart';
import 'package:gtd/common/splash_screen.dart';
import 'package:gtd/core/core_blocs/bloc_delegate.dart';
import 'package:gtd/core/keys.dart';
import 'package:gtd/core/repositories/local/local_repository.dart';
import 'package:gtd/core/repositories/local/local_state_bloc.dart';
import 'package:gtd/core/repositories/remote/element_repository.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/core/repositories/repository.dart';
import 'package:gtd/onboarding/onboarding_screen.dart';

import 'core/core_blocs/navigator_bloc.dart';
import 'home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository _userRepository = UserRepository();
  final LocalRepository _localRepository = LocalRepository.instance;
  final ElementRepository _elementRepository = ElementRepositoryImpl();

  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(BlocProvider(
    create: (context) =>
        AuthenticationBloc(userRepository: _userRepository)..add(AppStarted()),
    child: GTD(
        userRepository: _userRepository,
        localRepository: _localRepository,
        elementRepository: _elementRepository),
  ));
}

class GTD extends StatefulWidget {
  final UserRepository _userRepository;
  final LocalRepository _localRepository;
  final ElementRepository _elementRepository;

  GTD(
      {Key key,
      @required UserRepository userRepository,
      LocalRepository localRepository,
      ElementRepository elementRepository})
      : assert(userRepository != null),
        assert(localRepository != null),
        assert(elementRepository != null),
        _userRepository = userRepository,
        _localRepository = localRepository,
        _elementRepository = elementRepository,
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GTDState(
        userRepository: _userRepository, localRepository: _localRepository, elementRepository: _elementRepository);
  }
}

class GTDState extends State<GTD> {
  final UserRepository _userRepository;
  final LocalRepository _localRepository;
  final ElementRepository _elementRepository;

  GTDState(
      {@required UserRepository userRepository,
      LocalRepository localRepository,
      ElementRepository elementRepository})
      : assert(userRepository != null),
        assert(localRepository != null),
        assert(elementRepository != null),
        _userRepository = userRepository,
        _localRepository = localRepository,
        _elementRepository = elementRepository;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> _navigatorKey = GtdKeys.navKey;
    final GlobalKey<NavigatorState> _localStateKey = GtdKeys.navKey;

    LocalStatusBloc localStatusBloc = LocalStatusBloc(
        localStatusKey: _localStateKey, localRepository: _localRepository);
    AuthenticationBloc authBloc =
        AuthenticationBloc(userRepository: _userRepository);
    NavigatorBloc navigatorBloc = NavigatorBloc(
        navigatorKey: _navigatorKey,
        userRepository: _userRepository,
        elementRepository: _elementRepository);

    return MultiBlocProvider(
        providers: [
          BlocProvider<NavigatorBloc>(
            create: (BuildContext context) => navigatorBloc,
          ),
          BlocProvider<LocalStatusBloc>(
            create: (BuildContext context) => localStatusBloc
              ..add(CheckIfOnboardingIsCompleted()),
          ),
          BlocProvider<AuthenticationBloc>(
            create: (BuildContext context) => authBloc..add(AppStarted()),
          )
        ],
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          title: 'Getting Things Done',
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
            if (state is Uninitialized) {
              return SplashScreen();
            }
            if (state is Unauthenticated) {
              return BlocBuilder<LocalStatusBloc, LocalState>(
                builder: (context, state) {
                  if (state is Unknown) {
                    return SplashScreen();
                  }
                  if (state is OnboardingNotCompleted) {
                    return OnboardingScreen(userRepository: _userRepository);
                  }
                  if (state is OnboardingCompleted) {
                    return AuthScreen();
                  }
                },
              );
            }
            if (state is Authenticated) {
              return HomeScreen(userRepository: _userRepository);
            }
            return OnboardingScreen(userRepository: _userRepository);
          }),
        ));
  }
}
