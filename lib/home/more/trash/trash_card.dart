import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/home/elements/element_bloc.dart';

class TrashCard extends StatelessWidget {
  final GTDElement _deletedElement;
  ElementBloc _elementBloc;

  TrashCard({GTDElement deletedElement})
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
            child: Row(
              children: [
                Text(
                  _deletedElement.summary,
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
                      _onDeletePressed(_deletedElement, context);
                    },
                    child: Text('ELIMINAR',
                        style: TextStyle(color: Colors.orange))),
                FlatButton(
                    onPressed: () {
                      try{
                        _onRecoverPressed(_deletedElement);
                        _showSucessSnackbar(context);
                      } catch (error) {
                        _showErrorSnackbar(context);
                      }
                    },
                    child: Text('RECUPERAR',
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

  void _onRecoverPressed(GTDElement element) {
    _elementBloc.add(RecoverFromTrash(element));
  }

  void _showSucessSnackbar(BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Elemento recuperado con éxito.'),));
  }

    void _showErrorSnackbar(BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('No se pudo recuperar el elemento.'),));
  }
}
