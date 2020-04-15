import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:gtd/auth/auth_screen.dart';
import 'package:gtd/auth/login/login_screen.dart';
import 'package:gtd/auth/register/register_screen.dart';
import 'package:gtd/capture/camera/camera_screen.dart';
import 'package:gtd/capture/capture_screen.dart';
import 'package:gtd/core/repositories/local/local_repository.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/core/repositories/repository.dart';
import 'package:gtd/home/home_screen.dart';
import 'package:gtd/home/more/projects/project_screen.dart';
import 'package:gtd/home/more/settings/settings_screen.dart';
import 'package:gtd/home/more/trash/trash_screen.dart';

enum NavigatorAction {
  NavigatorActionPop,
  NavigateToAuthEvent,
  NavigateToLoginEvent,
  NavigateToRegisterEvent,
  NavigateToHome,
  OpenCaptureScreen,
  NavigateToProjects,
  GoToSplashScreen,
  OpenCamera,
  NavigateToTrash,
  OpenSettings,
  OpenSystemSettings
}

class NavigatorBloc extends Bloc<NavigatorAction, dynamic> {
  final GlobalKey<NavigatorState> navigatorKey;
  final UserRepository userRepository;
  final ElementRepository elementRepository;
  final LocalRepository localRepository;

  NavigatorBloc(
      {this.navigatorKey,
      this.userRepository,
      this.elementRepository,
      this.localRepository});

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
        navigatorKey.currentState.pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(userRepository: userRepository)),
            (Route<dynamic> route) => false);
        break;
      case NavigatorAction.OpenCaptureScreen:
        navigatorKey.currentState.push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => CaptureScreen(
                userRepository: userRepository,
                elementRepository: elementRepository)));
        break;
      case NavigatorAction.NavigateToProjects:
        navigatorKey.currentState
            .push(MaterialPageRoute(builder: (context) => ProjectScreen()));
        // builder: (context) => ProjectScreen(userRepository: userRepository, projectRepository: _projectRepository)));
        break;
      case NavigatorAction.GoToSplashScreen:
        navigatorKey.currentState
            .push(MaterialPageRoute(builder: (context) => AuthScreen()));
        break;
      case NavigatorAction.OpenCamera:
        final cameras = await availableCameras();
        if (cameras.isNotEmpty) {
          final firstCamera = cameras?.first;
          navigatorKey.currentState.push(MaterialPageRoute(
              builder: (context) => TakePictureScreen(camera: firstCamera)));
        } else {
          print('Cameras not available');
        }
        break;
      case NavigatorAction.NavigateToTrash:
        navigatorKey.currentState.push(MaterialPageRoute(
            builder: (context) => TrashScreen(userRepository: userRepository)));
        break;
      case NavigatorAction.OpenSystemSettings:
        AppSettings.openAppSettings();
        break;
      case NavigatorAction.OpenSettings:
        navigatorKey.currentState.push(MaterialPageRoute(
            builder: (context) => SettingsScreen(userRepository: userRepository, localRepository: localRepository,)));
        break;
    }
  }
}
