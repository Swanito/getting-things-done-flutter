import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/home/elements/element_bloc.dart';

class WaitingForCard extends StatelessWidget {
  final GTDElement _deletedElement;
  ElementBloc _elementBloc;

  WaitingForCard({GTDElement deletedElement})
      : assert(deletedElement != null),
        _deletedElement = deletedElement;

  @override
  Widget build(BuildContext context) {
    _elementBloc = BlocProvider.of<ElementBloc>(context);

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        _deletedElement.summary,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.assignment_ind,size: 13,
                          color: Colors.grey[600],),
                    Text(
                      'En espera por ${_deletedElement.asignee}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
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
                      _onDeletePressed(_deletedElement, context);
                    },
                    child: Text('ELIMINAR',
                        style: TextStyle(color: Colors.orange))),
                FlatButton(
                    onPressed: () {
                      _onCompletePressed();
                    },
                    child: Text('COMPLETAR',
                        style: TextStyle(color: Colors.orange))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _onDeletePressed(GTDElement element, BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Quieres eliminar el elemento definitivamente?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                BlocProvider.of<NavigatorBloc>(context).add(NavigatorActionPop());
              },
            ),
            FlatButton(
              child: Text('Borrar'),
              onPressed: () {
                    _elementBloc.add(DeleteElement(element));
                BlocProvider.of<NavigatorBloc>(context).add(NavigatorActionPop());
              },
            ),
          ],
        );
      },
    );
  }

  void _onCompletePressed() {
    _elementBloc.add(MarkAsCompleted(_deletedElement));
  }
}
