import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:gtd/auth/auth_screen.dart';
import 'package:gtd/auth/login/login_screen.dart';
import 'package:gtd/auth/register/register_screen.dart';
import 'package:gtd/capture/camera/camera_screen.dart';
import 'package:gtd/capture/capture_screen.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/repositories/local/local_repository.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/core/repositories/repository.dart';
import 'package:gtd/home/home_screen.dart';
import 'package:gtd/home/more/projects/project_screen.dart';
import 'package:gtd/home/more/referenced/referenced_screen.dart';
import 'package:gtd/home/more/settings/settings_screen.dart';
import 'package:gtd/home/more/trash/trash_screen.dart';
import 'package:gtd/home/more/waiting_for/waiting_for_screen.dart';
import 'package:gtd/home/procesar/advanced/advanced_process.dart';
import 'package:gtd/home/procesar/basic/actionable_screen.dart';
import 'package:gtd/home/procesar/basic/asignee_screen.dart';
import 'package:gtd/home/procesar/basic/basic_process.dart';
import 'package:gtd/home/procesar/basic/calendar_screen.dart';
import 'package:gtd/home/procesar/basic/step_numbers_screen.dart';
import 'package:gtd/home/procesar/basic/time_screen.dart';

class NavigatorAction extends Equatable {
  const NavigatorAction();

  @override
  List<Object> get props => null;
}

class NavigatorActionPop extends NavigatorAction {}

class NavigatorActionPopAll extends NavigatorAction {}

class NavigateToAuthEvent extends NavigatorAction {}

class NavigateToLoginEvent extends NavigatorAction {}

class NavigateToRegisterEvent extends NavigatorAction {}

class NavigateToHome extends NavigatorAction {}

class OpenCaptureScreen extends NavigatorAction {}

class NavigateToProjects extends NavigatorAction {}

class GoToSplashScreen extends NavigatorAction {}

class OpenCamera extends NavigatorAction {}

class NavigateToTrash extends NavigatorAction {}
 
class NavigateToWaitingFor extends NavigatorAction {}

class NavigateToReferenced extends NavigatorAction {}

class OpenSettings extends NavigatorAction {}

class OpenSystemSettings extends NavigatorAction {}

class OpenProcessScreen extends NavigatorAction {
  GTDElement elementToBeProcessed;

  OpenProcessScreen({@required this.elementToBeProcessed});
}

class GoToProcessStepScreen extends NavigatorAction {
  final GTDElement elementBeingProcessed;
  final UserRepository userRepository;
  GoToProcessStepScreen({this.elementBeingProcessed, this.userRepository});
}

class GoToTimeStepScreen extends NavigatorAction {
  final GTDElement elementBeingProcessed;
  final UserRepository userRepository;
  GoToTimeStepScreen({this.elementBeingProcessed, this.userRepository});
}

class GoToAsigneeStepScreen extends NavigatorAction {
  final GTDElement elementBeingProcessed;
  final UserRepository userRepository;
  GoToAsigneeStepScreen({this.elementBeingProcessed, this.userRepository});
}

class GoToCalendarStepScreen extends NavigatorAction {
  final GTDElement elementBeingProcessed;
  final UserRepository userRepository;
  GoToCalendarStepScreen({this.elementBeingProcessed, this.userRepository});
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
    if (event is NavigatorActionPop) {
      navigatorKey.currentState.pop();
    } else if (event is NavigatorActionPopAll) {
      navigatorKey.currentState.popUntil((route) => route.isFirst);
      }else if (event is NavigateToAuthEvent) {
      navigatorKey.currentState.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => AuthScreen()),
          (Route<dynamic> route) => false);
    } else if (event is NavigateToLoginEvent) {
      navigatorKey.currentState.push(MaterialPageRoute(
          builder: (context) =>
              LoginScreen(userRepository: this.userRepository)));
    } else if (event is NavigateToRegisterEvent) {
      navigatorKey.currentState.push(MaterialPageRoute(
          builder: (context) =>
              RegisterScreen(userRepository: this.userRepository)));
    } else if (event is NavigateToHome) {
      navigatorKey.currentState.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => HomeScreen(userRepository: userRepository)),
          (Route<dynamic> route) => false);
    } else if (event is OpenCaptureScreen) {
      navigatorKey.currentState.push(MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => CaptureScreen(
              userRepository: userRepository,
              elementRepository: elementRepository)));
    } else if (event is NavigateToProjects) {
      navigatorKey.currentState
          .push(MaterialPageRoute(builder: (context) => ProjectScreen()));
    } else if (event is GoToSplashScreen) {
      navigatorKey.currentState
          .pushReplacement(MaterialPageRoute(builder: (context) => AuthScreen()));
    } else if (event is OpenCamera) {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        final firstCamera = cameras?.first;
        navigatorKey.currentState.push(MaterialPageRoute(
            builder: (context) => TakePictureScreen(camera: firstCamera)));
      } else {
        print('Cameras not available');
      }
    } else if (event is NavigateToTrash) {
      navigatorKey.currentState.push(MaterialPageRoute(
          builder: (context) => TrashScreen(userRepository: userRepository)));
    } else if (event is NavigateToReferenced) {
      navigatorKey.currentState.push(MaterialPageRoute(
          builder: (context) =>
              ReferencedScreen(userRepository: userRepository)));
    } else if (event is NavigateToWaitingFor) {
      navigatorKey.currentState.push(MaterialPageRoute(
          builder: (context) =>
              WaitingForScreen(userRepository: userRepository)));
    }else if (event is OpenSettings) {
      navigatorKey.currentState.push(MaterialPageRoute(
          builder: (context) => SettingsScreen(
                userRepository: userRepository,
                localRepository: localRepository,
              )));
    } else if (event is OpenSystemSettings) {
      AppSettings.openAppSettings();
    } else if (event is OpenProcessScreen) {
      String gtdLevel = await localRepository.getGTDLevel();
      if (gtdLevel.contains('Low')) {
        navigatorKey.currentState.push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => BasicProcess(
                  userRepository: userRepository,
                  element: event.elementToBeProcessed,
                  step: ActionableScreen(
                    element: event.elementToBeProcessed,
                    userRepository: userRepository,
                  ),
                )));
      } else if (gtdLevel.contains('High')) {
        navigatorKey.currentState.push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => AdvancedProcess(
                userRepository: userRepository,
                isEditing: false,
                element: event.elementToBeProcessed)));
      } else {
        print('Invalid GTD Level state');
      }
    } else if (event is GoToProcessStepScreen) {
      navigatorKey.currentState.push(MaterialPageRoute(
          builder: (context) => BasicProcess(
              userRepository: userRepository,
              element: event.elementBeingProcessed,
              step: StepNumbersScreen(
                userRepository: userRepository,
                element: event.elementBeingProcessed,
              ))));
    } else if (event is GoToTimeStepScreen) {
      navigatorKey.currentState.push(MaterialPageRoute(
          builder: (context) => BasicProcess(
              userRepository: userRepository,
              element: event.elementBeingProcessed,
              step: TimeStepScreen(
                userRepository: userRepository,
                element: event.elementBeingProcessed,
              ))));
    } else if (event is GoToAsigneeStepScreen) {
      navigatorKey.currentState.push(MaterialPageRoute(
          builder: (context) => BasicProcess(
              userRepository: userRepository,
              element: event.elementBeingProcessed,
              step: AssigneStepScreen(
                userRepository: userRepository,
                element: event.elementBeingProcessed,
              ))));
    } else if (event is GoToCalendarStepScreen) {
      navigatorKey.currentState.push(MaterialPageRoute(
          builder: (context) => BasicProcess(
              userRepository: userRepository,
              element: event.elementBeingProcessed,
              step: CalendarStepScreen(
                userRepository: userRepository,
                element: event.elementBeingProcessed,
              ))));
    }
  }
}
