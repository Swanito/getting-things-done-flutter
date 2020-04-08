import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/capture/capture_event.dart';
import 'package:gtd/capture/capture_state.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/models/gtd_element_entity.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/core/repositories/repository.dart';

class CaptureBloc extends Bloc<CaptureEvent, CaptureState> {
  final UserRepository _userRepository;
  final ElementRepository _elementRepository;

  CaptureBloc({@required userRepository, @required elementRepository})
      : assert(userRepository != null),
        assert(elementRepository != null),
        _elementRepository = elementRepository,
        _userRepository = userRepository;

  @override
  // TODO: implement initialState
  CaptureState get initialState => EmptyState();

  @override
  Stream<CaptureState> mapEventToState(CaptureEvent event) async* {
    if (event is Capture) {
      yield* _mapCaptureToState(event.summary, event.description);
    }
  }

  Stream<CaptureState> _mapCaptureToState(String summary, String description) async* {
    try {
      GTDElement element = GTDElement(summary, description: description);
      _elementRepository.createElement(element);
      yield Captured();
    } catch (error) {
      yield ErrorCapturing();
    }
  }
}
