import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/home/elements/element_bloc.dart';

class NextCard extends StatelessWidget {
  final GTDElement _processedElement;
  ElementBloc _elementBloc;

  NextCard({GTDElement processedElement})
      : assert(processedElement != null),
        _processedElement = processedElement;

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
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                            _processedElement.project != null
                                ? _processedElement.project.title
                                : 'Sin proyecto',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600]))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                        children: [
                          Text(_processedElement.summary,
                              style: TextStyle(
                                  fontSize: 18,
                                  decoration: _processedElement.currentStatus ==
                                          'COMPLETED'
                                      ? TextDecoration.lineThrough
                                      : null))
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 13,
                          color: Colors.grey[600],
                        ),
                        Text(
                            _processedElement.dueDate != null
                                ? _processedElement.dueDate.toString()
                                : 'Sin fecha',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600])),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(Icons.assignment_ind,
                            size: 13, color: Colors.grey[600]),
                        Text(
                            _processedElement.contexts != null
                                ? '${_processedElement.contexts[0]} y ${_processedElement.contexts.length - 1} más'
                                : 'Sin contexto',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Checkbox(
                        checkColor: Colors.orange,
                        activeColor: Colors.white,
                        value: _processedElement.currentStatus == 'COMPLETED'
                            ? true
                            : false,
                        onChanged: (check) => {
                              if (check)
                                {
                                  _elementBloc
                                      .add(MarkAsCompleted(_processedElement))
                                }
                              else
                                {
                                  _elementBloc
                                      .add(UnmarkAsCompleted(_processedElement))
                                }
                            }),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                    onPressed: () {
                      _onDeletePressed(_processedElement);
                    },
                    child: Text('ELIMINAR',
                        style: TextStyle(color: Colors.orange))),
                FlatButton(
                    onPressed: () {
                      _onEditPressed;
                    },
                    child:
                        Text('DETALLES', style: TextStyle(color: Colors.orange))),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onDeletePressed(GTDElement element) {
    _elementBloc.add(DeleteElement(element));
  }

  void _onEditPressed() {}

  void _onProcessPressed() {}
}
