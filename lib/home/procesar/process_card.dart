import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/styles.dart';
import 'package:gtd/home/elements/element_bloc.dart';

class ProcessCard extends StatelessWidget {
  final GTDElement _collectedElement;

  ProcessCard({GTDElement collectedElement})
      : assert(collectedElement != null),
        _collectedElement = collectedElement;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: Border(
          left: BorderSide(
        color: Colors.orange,
        width: 3,
      )),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 22.0, left: 30.0),
            child: Row(
              children: [
                Text(
                  _collectedElement.summary,
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                    onPressed: () {
                      _onDeletePressed(_collectedElement, context);
                    },
                    child: Text('ELIMINAR',
                        style: TextStyle(color: Colors.orange))),
                FlatButton(
                    onPressed: () {
                      _onEditPressed;
                    },
                    child:
                        Text('EDITAR', style: TextStyle(color: Colors.orange))),
                FlatButton(
                    onPressed: () {
                      _onProcessPressed(_collectedElement, context);
                    },
                    child: Text('PROCESAR',
                        style: TextStyle(color: Colors.orange))),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onDeletePressed(GTDElement element, BuildContext context) {
    BlocProvider.of<ElementBloc>(context).add(MoveToDelete(element));
  }

  void _onEditPressed() {

  }

  void _onProcessPressed(GTDElement element, BuildContext context) {
    BlocProvider.of<NavigatorBloc>(context).add(OpenProcessScreen(elementToBeProcessed: element));
  }
}
