import 'package:flutter/material.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/home/procesar/advanced/advanced_process_form.dart';

class AdvancedProcess extends StatefulWidget {

  final GTDElement _element;

  AdvancedProcess(
      {@required GTDElement element})
      : assert(element != null),
        _element = element;

  @override
  State<StatefulWidget> createState() {
    return AdvancedProcessState(element: _element);
  }
}

class AdvancedProcessState extends State<AdvancedProcess> {

  GTDElement _element;

  AdvancedProcessState(
      {@required GTDElement element})
      : assert(element != null),
        _element = element;

  @override
  Widget build(BuildContext context) {
    return AdvancedProcessForm(
      element: _element,
    );
  }
}
