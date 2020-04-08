import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/capture/capture_event.dart';
import 'package:gtd/capture/capture_state.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';

class CaptureBloc extends Bloc<CaptureEvent, CaptureState> {
  final UserRepository _userRepository;


  CaptureBloc({@required userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  // TODO: implement initialState
  CaptureState get initialState => EmptyState();

  @override
  Stream<CaptureState> mapEventToState(CaptureEvent event) async*{
    if (event is EmptyState) {
      
    }
  }

}