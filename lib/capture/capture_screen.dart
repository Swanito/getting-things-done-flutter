import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/capture/capture_bloc.dart';
import 'package:gtd/capture/capture_form.dart';
import 'package:gtd/capture/capture_state.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/core/repositories/repository.dart';

class CaptureScreen extends StatelessWidget {
  final UserRepository _userRepository;
  final ElementRepository _elementRepository;

  CaptureScreen({@required userRepository, @required elementRepository})
      : assert(userRepository != null),
      assert(elementRepository != null),
        _userRepository = userRepository,
        _elementRepository = elementRepository;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return CaptureForm(userRepository: _userRepository, isEditing: false,);
    // return BlocProvider<CaptureBloc>(
    //   create: (context) => CaptureBloc(userRepository: _userRepository, elementRepository: _elementRepository),
    //   child: CaptureForm(userRepository: _userRepository, isEditing: false,)
    // );
  }
}
