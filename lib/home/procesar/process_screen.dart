import 'package:flutter/material.dart';
import 'package:gtd/common/gtd_app_bar.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/home/elements/element_bloc.dart';
import 'package:gtd/home/procesar/process_list.dart';

class ProcessScreen extends StatelessWidget {

  final GTDAppBar _gtdAppBar = GTDAppBar(
    title: 'Procesar',
    canSearch: false,
    factor: BarSizeFactor.Small,
  );

  ProcessScreen({Key key});

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
          BlocListener<ElementBloc, ElementState>(
            listener: (context, state) {
              if (state is FailedLoadingElements) {
                _showErrorSnackbar(context);
              } else if (state is ElementProcessed) {
                BlocProvider.of<ElementBloc>(context).add(LoadElements());
                _showSuccessSnackbar(
                    context, 'Elemento procesado correctamente');
              } else if (state is ElementDeleted) {
                BlocProvider.of<ElementBloc>(context).add(LoadElements());
                _showSuccessSnackbar(
                    context, 'Elemento eliminado correctamente');
              }
              return Container();
            },
            child: BlocBuilder<ElementBloc, ElementState>(
                builder: (context, state) {
              if (state is LoadingElements ||
                  state is StartingAdvancedProcessing ||
                  state is StartingBasicProcessing) {
                return _showLoader(context);
              } else if (state is SucessLoadingElements) {
                return ProcessList(state.elements);
              }
              return _showLoader(context);
            }),
          )
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
            children: [Text(text), Icon(Icons.check)],
          ),
          backgroundColor: Colors.green,
        ),
      );
  }
}
