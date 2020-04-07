import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/common/gtd_app_bar.dart';
import 'package:gtd/common/loading_screen.dart';
import 'package:gtd/core/repositories/remote/element_repository.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/home/elements/element_bloc.dart';

class NextScreen extends StatelessWidget {
  final UserRepository _userRepository;

  NextScreen({Key key, UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GTDAppBar(title: 'Next'),
          MultiBlocProvider(
              providers: [
                BlocProvider<ElementBloc>(
                  create: (context) {
                    return ElementBloc(
                      elementRepository: ElementRepositoryImpl(),
                    )..add(LoadElements());
                  },
                )
              ],
              child: BlocBuilder<ElementBloc, ElementState>(
                builder: (context, state) {
                  if (state is LoadingElements) {
                    return Container(
                        decoration: BoxDecoration(color: Colors.red),
                        height: 100,
                        width: 100);
                  } else if (state is SucessLoadingElements) {
                    if (state.elements.isNotEmpty) {
                    return Container(
                        decoration: BoxDecoration(color: Colors.blue),
                        height: 100,
                        width: 100);
                    } else {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('No has creado ningún elemento todavía.'),
                        ),

                      );
                    }
                  } else if (state is FailedLoadingElements) {
                    _showErrorSnackbar(context);
                    return Container();
                  }
                },
              ))
        ],
      ),
    );
  }

  _showErrorSnackbar(BuildContext context) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Error recuperarndo los elementos. Intentalo de nuevo más tarde.'),
              Icon(Icons.error)
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
  }
}
