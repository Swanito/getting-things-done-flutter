import 'package:flutter/material.dart';
import 'package:gtd/common/gtd_app_bar.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/repositories/remote/element_repository.dart';
import 'package:gtd/home/elements/element_bloc.dart';
import 'package:gtd/home/procesar/process_list.dart';

class ProcessScreen extends StatelessWidget {
  final UserRepository _userRepository;
  GTDAppBar _gtdAppBar = GTDAppBar(
    title: 'Procesar',
    canSearch: false,
    factor: BarSizeFactor.Small,
  );

  ProcessScreen({Key key, UserRepository userRepository})
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
          _gtdAppBar,
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
                        height: MediaQuery.of(context).size.height / 2,
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.orange,
                          ),
                        ),
                      );
                    } else if (state is SucessLoadingElements) {
                      return ProcessList(state.elements);
                    } else if (state is FailedLoadingElements) {
                      _showErrorSnackbar(context);
                    } else if (state is ElementProcessed) {
                      _showSuccessSnackbar(context, 'Elemento procesado correctamente');
                      BlocProvider.of<ElementBloc>(context).add(LoadElements());
                    } else if(state is ElementDeleted) {
                      _showSuccessSnackbar(context, 'Elemento eliminado correctamente');
                      BlocProvider.of<ElementBloc>(context).add(LoadElements());
                    }
                    return Container();
                  },
                )
              )
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
              Text(
                  'Error recuperarndo los elementos. Intentalo de nuevo más tarde.'),
              Icon(Icons.error)
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
  }

  _showSuccessSnackbar(BuildContext context, String text) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text),
              Icon(Icons.check)
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );
  }
}
