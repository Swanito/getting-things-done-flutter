import 'package:flutter/material.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/home/procesar/advanced/advanced_process_form.dart';

class AdvancedProcess extends StatefulWidget {
  bool _isEditing;
  UserRepository _userRepository;
  GTDElement _element;

  AdvancedProcess(
      {@required bool isEditing, @required UserRepository userRepository, @required GTDElement element})
      : assert(isEditing != null),
        assert(userRepository != null),
        assert(element != null),
        _element = element,
        _isEditing = isEditing,
        _userRepository = userRepository;

  @override
  State<StatefulWidget> createState() {
    return AdvancedProcessState(
        isEditing: _isEditing, userRepository: _userRepository, element: _element);
  }
}

class AdvancedProcessState extends State<AdvancedProcess> {
  bool _isEditing;
  UserRepository _userRepository;
  GTDElement _element;

  AdvancedProcessState(
      {@required bool isEditing, @required UserRepository userRepository, @required GTDElement element})
      : assert(isEditing != null),
        assert(userRepository != null),
        assert(element != null),
        _element = element,
        _isEditing = isEditing,
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return AdvancedProcessForm(
      isEditing: _isEditing,
      userRepository: _userRepository,
      element: _element,
    );
  }
}
