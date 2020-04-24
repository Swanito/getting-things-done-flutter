import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/common/gtd_app_bar.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/home/elements/element_bloc.dart';
import 'package:gtd/home/next/next_bloc.dart';
import 'package:gtd/home/next/next_list.dart';
import 'package:gtd/home/next/next_state.dart';

class NextScreen extends StatelessWidget {
  final UserRepository _userRepository;

  NextScreen({Key key, UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.topLeft,
              colors: [
                Colors.orange[600],
                Colors.orange[400],
                Colors.orange[200],
                // Colors.orange[100],
              ]),
        )),
      ),
      body: Column(
        children: [
          GTDAppBar(
            title: 'Next',
            canSearch: false,
            factor: BarSizeFactor.Small,
          ),
          MultiBlocListener(
              listeners: [
                BlocListener<ElementBloc, ElementState>(
                    listener: (context, elementState) {
                  if (elementState is FailedLoadingElements) {
                    _showSnackbar(context, 'Error cargando los elementos', isError: true);
                  } else if (elementState is ElementDeleted) {
                    _showSnackbar(context, 'Elemento eliminado', isError: true);
                  } else if (elementState is ElementCompleted) {
                    _showSnackbar(context, 'Genial! has completado ${elementState.element.summary}!', isError: false);
                  }
                }),
              ],
              child: BlocBuilder<ElementBloc, ElementState>(
                builder: (context, state) {
                  return BlocBuilder<NextBloc, NextState>(
                      builder: (context, nextState) {
                    if (state is LoadingElements) {
                      return _showLoader(context);
                    } else if (state is SucessLoadingElements) {
                      if (nextState is CompletedElementsHidden) {
                        List<GTDElement> filteredElements = state.elements
                            .where(
                              (element) => element.currentStatus == 'PROCESSED',
                            )
                            .toList();
                        return NextList(filteredElements,
                            completedElementsHidden: false);
                      } else {
                        List<GTDElement> filteredElements = state.elements
                            .where(
                              (element) =>
                                  element.currentStatus == 'PROCESSED' ||
                                  element.currentStatus == 'COMPLETED',
                            )
                            .toList();
                        return NextList(filteredElements,
                            completedElementsHidden: true);
                      }
                    }
                    return _showLoader(context);
                  });
                },
              ))
        ],
      ),
    );
  }

  Widget _showLoader(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.orange,
        ),
      ),
    );
  }

  _showSnackbar(BuildContext context, String message, {bool isError}) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(message),
              isError ? Icon(Icons.error) : Icon(Icons.check)
            ],
          ),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
  }
}
