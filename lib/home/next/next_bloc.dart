import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/home/next/next_event.dart';
import 'package:gtd/home/next/next_state.dart';

class NextBloc extends Bloc<NextEvent, NextState> {
  @override
  // TODO: implement initialState
  get initialState => CompletedElementsHidden();

  @override
  Stream<NextState> mapEventToState(event) async* {
    if (event is HideCompletedElements) {
      yield* _mapHideCompletedElementsToState(event);
    }
  }

  Stream<NextState> _mapHideCompletedElementsToState(HideCompletedElements event) async* {
    if(event.shouldBeHidden) {
      yield CompletedElementsShown();
    } else {
      yield CompletedElementsHidden();
    }
  }

}