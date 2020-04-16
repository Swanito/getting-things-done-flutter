import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gtd/auth/auth_screen.dart';
import 'package:gtd/auth/authentication_bloc.dart';
import 'package:gtd/capture/capture_bloc.dart';
import 'package:gtd/common/splash_screen.dart';
import 'package:gtd/core/core_blocs/bloc_delegate.dart';
import 'package:gtd/core/keys.dart';
import 'package:gtd/core/repositories/local/local_repository.dart';
import 'package:gtd/core/repositories/local/local_state_bloc.dart';
import 'package:gtd/core/repositories/remote/element_repository.dart';
import 'package:gtd/core/repositories/remote/project_repository.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/core/repositories/repository.dart';
import 'package:gtd/home/more/projects/project_bloc.dart';
import 'package:gtd/home/more/projects/project_event.dart';
import 'package:gtd/home/procesar/bloc/process_bloc.dart';
import 'package:gtd/onboarding/onboarding_screen.dart';

import 'core/core_blocs/navigator_bloc.dart';
import 'home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final UserRepository _userRepository = UserRepository();
  final LocalRepository _localRepository = LocalRepository.instance;
  final ElementRepository _elementRepository = ElementRepositoryImpl();
  final ProjectRepositoryImpl _projectRepository = ProjectRepositoryImpl();

  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(BlocProvider(
    create: (context) =>
        AuthenticationBloc(userRepository: _userRepository)..add(AppStarted()),
    child: GTD(
        userRepository: _userRepository,
        localRepository: _localRepository,
        elementRepository: _elementRepository,
        projectRepository: _projectRepository),
  ));
}

class GTD extends StatefulWidget {
  final UserRepository _userRepository;
  final LocalRepository _localRepository;
  final ElementRepository _elementRepository;
  final ProjectRepositoryImpl _projectRepository;

  GTD(
      {Key key,
      @required UserRepository userRepository,
      LocalRepository localRepository,
      ElementRepository elementRepository,
      ProjectRepositoryImpl projectRepository})
      : assert(userRepository != null),
        assert(localRepository != null),
        assert(elementRepository != null),
        assert(projectRepository != null),
        _userRepository = userRepository,
        _localRepository = localRepository,
        _elementRepository = elementRepository,
        _projectRepository = projectRepository,
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GTDState(
        userRepository: _userRepository,
        localRepository: _localRepository,
        elementRepository: _elementRepository,
        projectRepository: _projectRepository);
  }
}

class GTDState extends State<GTD> {
  final UserRepository _userRepository;
  final LocalRepository _localRepository;
  final ElementRepository _elementRepository;
  final ProjectRepositoryImpl _projectRepository;

  GTDState(
      {@required UserRepository userRepository,
      LocalRepository localRepository,
      ElementRepository elementRepository,
      ProjectRepositoryImpl projectRepository})
      : assert(userRepository != null),
        assert(localRepository != null),
        assert(elementRepository != null),
        assert(projectRepository != null),
        _userRepository = userRepository,
        _localRepository = localRepository,
        _elementRepository = elementRepository,
        _projectRepository = projectRepository;

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
        elementRepository: _elementRepository,
        localRepository: _localRepository);
    ProjectBloc projectBloc =
        ProjectBloc(projectRepository: _projectRepository);
    CaptureBloc captureBloc = CaptureBloc(
        userRepository: _userRepository, elementRepository: _elementRepository);
    ProcessBloc processBloc = ProcessBloc(elementRepository: _elementRepository);

    return MultiBlocProvider(
        providers: [
          BlocProvider<NavigatorBloc>(
            create: (BuildContext context) => navigatorBloc,
          ),
          BlocProvider<LocalStatusBloc>(
            create: (BuildContext context) =>
                localStatusBloc..add(CheckIfOnboardingIsCompleted()),
          ),
          BlocProvider<AuthenticationBloc>(
            create: (BuildContext context) => authBloc..add(AppStarted()),
          ),
          BlocProvider<ProjectBloc>(
              create: (BuildContext context) =>
                  projectBloc..add(LoadProjects())),
          BlocProvider<CaptureBloc>(
              create: (BuildContext context) => captureBloc),
          BlocProvider<ProcessBloc>(
              create: (BuildContext context) => processBloc),
        ],
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          title: 'Getting Things Done',
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('es'), // Spanish
            const Locale('en'), // English
          ],
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
