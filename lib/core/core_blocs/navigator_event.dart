import 'package:equatable/equatable.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';

class NavigatorAction extends Equatable {
  const NavigatorAction();

  @override
  List<Object> get props => null;
}

class NavigatorActionPop extends NavigatorAction {}

class NavigateToOnboarding extends NavigatorAction {
  final UserRepository userRepository;

  NavigateToOnboarding({this.userRepository});
}

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
  final GTDElement elementToBeProcessed;

  OpenProcessScreen({this.elementToBeProcessed});
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
