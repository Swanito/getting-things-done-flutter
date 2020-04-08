import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:gtd/auth/auth_screen.dart';
import 'package:gtd/auth/login/login_screen.dart';
import 'package:gtd/auth/register/register_screen.dart';
import 'package:gtd/capture/capture_screen.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/core/repositories/repository.dart';
import 'package:gtd/home/home_screen.dart';
import 'package:gtd/home/more/projects/project_screen.dart';

enum NavigatorAction {
  NavigatorActionPop,
  NavigateToAuthEvent,
  NavigateToLoginEvent,
  NavigateToRegisterEvent,
  NavigateToHome,
  OpenCaptureScreen,
  NavigateToProjects
}

class NavigatorBloc extends Bloc<NavigatorAction, dynamic> {
  final GlobalKey<NavigatorState> navigatorKey;
  final UserRepository userRepository;
  final ElementRepository elementRepository;

  NavigatorBloc({this.navigatorKey, this.userRepository, this.elementRepository});

  @override
  dynamic get initialState => 0;

  @override
  Stream<dynamic> mapEventToState(NavigatorAction event) async* {
    switch (event) {
      case NavigatorAction.NavigatorActionPop:
        navigatorKey.currentState.pop();
        break;
      case NavigatorAction.NavigateToAuthEvent:
        navigatorKey.currentState.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => AuthScreen()),
            (Route<dynamic> route) => false);
        break;
      case NavigatorAction.NavigateToLoginEvent:
        navigatorKey.currentState.push(MaterialPageRoute(
            builder: (context) =>
                LoginScreen(userRepository: this.userRepository)));
        break;
      case NavigatorAction.NavigateToRegisterEvent:
        navigatorKey.currentState.push(MaterialPageRoute(
            builder: (context) =>
                RegisterScreen(userRepository: this.userRepository)));
        break;
      case NavigatorAction.NavigateToHome:
        navigatorKey.currentState.push(MaterialPageRoute(
            builder: (context) => HomeScreen(userRepository: userRepository)));
        break;
      case NavigatorAction.OpenCaptureScreen:
        navigatorKey.currentState.push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => CaptureScreen(userRepository: userRepository, elementRepository: elementRepository,)));
        break;
      case NavigatorAction.NavigateToProjects:
       navigatorKey.currentState.push(MaterialPageRoute(
                     builder: (context) => ProjectScreen()));
            // builder: (context) => ProjectScreen(userRepository: userRepository, projectRepository: _projectRepository)));
        break;
    }
  }
}
