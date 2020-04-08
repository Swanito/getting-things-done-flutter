import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/capture/capture_bloc.dart';
import 'package:gtd/capture/capture_form.dart';
import 'package:gtd/capture/capture_state.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';

class CaptureScreen extends StatelessWidget {
  final UserRepository _userRepository;

  CaptureScreen({@required userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider<CaptureBloc>(
      create: (context) => CaptureBloc(userRepository: _userRepository),
      child: CaptureForm(userRepository: _userRepository)
    );
  }
}
