import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:gtd/auth/auth_screen.dart';
import 'package:gtd/auth/authentication_bloc.dart';
import 'package:gtd/auth/login/login_screen.dart';
import 'package:gtd/auth/register/register_screen.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/home/home_screen.dart';

enum NavigatorAction {
  NavigatorActionPop,
  NavigateToAuthEvent,
  NavigateToLoginEvent,
  NavigateToRegisterEvent,
  NavigateToHome
}

class NavigatorBloc extends Bloc<NavigatorAction, dynamic> {
  final GlobalKey<NavigatorState> navigatorKey;
  final UserRepository userRepository;

  NavigatorBloc({this.navigatorKey, this.userRepository});

  @override
  dynamic get initialState => 0;

  @override
  Stream<dynamic> mapEventToState(NavigatorAction event) async* {
    switch (event) {
      case NavigatorAction.NavigatorActionPop:
        navigatorKey.currentState.pop();
        break;
      case NavigatorAction.NavigateToAuthEvent:
        navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => AuthScreen()));
        break;
      case NavigatorAction.NavigateToLoginEvent:
        navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => LoginScreen(userRepository: this.userRepository)));
        break;
      case NavigatorAction.NavigateToRegisterEvent:
        navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => RegisterScreen(userRepository: this.userRepository)));
        break;
      case NavigatorAction.NavigateToHome:
        navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }
}
