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
import 'package:gtd/home/elements/element_bloc.dart';
import 'package:gtd/home/more/projects/project_bloc.dart';
import 'package:gtd/home/more/projects/project_event.dart';
import 'package:gtd/home/next/next_bloc.dart';
import 'package:gtd/home/next/next_event.dart';
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
    return GTDState();
  }
}

class GTDState extends State<GTD> {

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> _navigatorKey = GtdKeys.navKey;
    final GlobalKey<NavigatorState> _localStateKey = GtdKeys.navKey;

    LocalStatusBloc localStatusBloc = LocalStatusBloc(
        localStatusKey: _localStateKey, localRepository: widget._localRepository);
    NavigatorBloc navigatorBloc = NavigatorBloc(
        navigatorKey: _navigatorKey,
        userRepository: widget._userRepository,
        elementRepository: widget._elementRepository,
        localRepository: widget._localRepository);
    ProjectBloc projectBloc =
        ProjectBloc(projectRepository: widget._projectRepository);
    CaptureBloc captureBloc = CaptureBloc(
        userRepository: widget._userRepository, elementRepository: widget._elementRepository);
    ElementBloc elementBloc = ElementBloc(elementRepository: widget._elementRepository);
    NextBloc nextBloc = NextBloc();

    return MultiBlocProvider(
        providers: [
          BlocProvider<NavigatorBloc>(
            create: (BuildContext context) => navigatorBloc,
          ),
          BlocProvider<LocalStatusBloc>(
            create: (BuildContext context) =>
                localStatusBloc..add(CheckIfOnboardingIsCompleted()),
          ),
          BlocProvider<ProjectBloc>(
              create: (BuildContext context) =>
                  projectBloc..add(LoadProjects())),
          BlocProvider<CaptureBloc>(
              create: (BuildContext context) => captureBloc),
          BlocProvider<ElementBloc>(
              create: (BuildContext context) => elementBloc..add(LoadElements())),
          BlocProvider<NextBloc>(
              create: (BuildContext context) => nextBloc..add(HideCompletedElements(shouldBeHidden: false))),
        ],
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          title: 'Do Things',
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
                builder: (context, localState) {
                  if (localState is Unknown) {
                    return SplashScreen();
                  }
                  if (localState is OnboardingNotCompleted) {
                    return OnboardingScreen(userRepository: widget._userRepository);
                  }
                  if (localState is OnboardingCompleted) {
                    return AuthScreen();
                  }
                  return Container();
                },
              );
            }
            if (state is Authenticated) {
                return HomeScreen(userRepository: widget._userRepository, currentUser: state.displayName);
            }
            return OnboardingScreen(userRepository: widget._userRepository);
          }),
        ));
  }
}
