import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/repositories/repository.dart';
import 'package:gtd/home/procesar/bloc/process_event_old.dart';
import 'package:gtd/home/procesar/bloc/process_state_old.dart';

class ProcessBloc extends Bloc<ProcessEvent, ProcessState> {
  ElementRepository _elementRepository;

  ProcessBloc({@required ElementRepository elementRepository})
      : assert(elementRepository != null),
        _elementRepository = elementRepository;

  @override
  // TODO: implement initialState
  ProcessState get initialState => NotProcessed();

  @override
  Stream<ProcessState> mapEventToState(ProcessEvent event) async* {
    if (event is ProcessElement) {
      yield* _mapProcessElementToState(event);
    }
  }

  Stream<ProcessState> _mapProcessElementToState(ProcessElement event) async* {
    event.element.currentStatus = 'PROCESSED';
    try {
      _elementRepository.updateElement(event.element);
      yield ProcessedSuccessfully();
    } catch (error) {
      yield ErrorProcessing();
    }
  }
}
