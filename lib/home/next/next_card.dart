import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/capture/capture_bloc.dart';
import 'package:gtd/capture/capture_event.dart';
import 'package:gtd/capture/capture_state.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/home/elements/element_bloc.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

class NextCard extends StatefulWidget {
  final GTDElement _processedElement;

  NextCard({GTDElement processedElement})
      : assert(processedElement != null),
        _processedElement = processedElement;

  @override
  _NextCardState createState() => _NextCardState();
}

class _NextCardState extends State<NextCard> {
  ElementBloc _elementBloc;
  CaptureBloc _captureBloc;
  int recurrencyInterval;
  bool isRecurrent = false;
  String period;

  bool get hasAttachedElements =>
      widget._processedElement.imageRemotePath != null;

  @override
  Widget build(BuildContext context) {
    _elementBloc = BlocProvider.of<ElementBloc>(context);
    _captureBloc = BlocProvider.of<CaptureBloc>(context);

    if (widget._processedElement.period != null) {
      recurrencyInterval = _calculateRecurrency(
          widget._processedElement.repeatInterval,
          widget._processedElement.period);
      isRecurrent = true;
      period = widget._processedElement.period == "WEEK" ? 'semanas' : 'días';
    }

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
                            widget._processedElement.project != null
                                ? widget._processedElement.project.title
                                : 'Sin proyecto',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600]))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                        children: [
                          Text(widget._processedElement.summary,
                              style: TextStyle(
                                  fontSize: 18,
                                  decoration:
                                      widget._processedElement.currentStatus ==
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
                            widget._processedElement.dueDate != null
                                ? widget._processedElement.dueDate.toString()
                                : 'Sin fecha',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600])),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(Icons.assignment_ind,
                            size: 13, color: Colors.grey[600]),
                        Text(
                            widget._processedElement.contexts != null &&
                                    widget._processedElement.contexts.length > 0
                                ? '${widget._processedElement.contexts.first} y ${widget._processedElement.contexts.length - 1} más'
                                : 'Sin contexto',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600])),
                      ],
                    ),
                    isRecurrent
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.replay,
                                  size: 13,
                                  color: Colors.grey[600],
                                ),
                                Text('Ocurre cada $recurrencyInterval $period',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[600]))
                              ],
                            ),
                          )
                        : Container(),
                    hasAttachedElements
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.attach_file,
                                  size: 13,
                                  color: Colors.grey[600],
                                ),
                                Text('Contiene adjuntos',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[600]))
                              ],
                            ),
                          )
                        : Container(),
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
                        value: widget._processedElement.currentStatus ==
                                'COMPLETED'
                            ? true
                            : false,
                        onChanged: (check) => {
                              if (check)
                                {
                                  _elementBloc.add(MarkAsCompleted(
                                      widget._processedElement)),
                                }
                              else
                                {
                                  _elementBloc.add(UnmarkAsCompleted(
                                      widget._processedElement))
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
                      _onDeletePressed(widget._processedElement);
                    },
                    child: Text('ELIMINAR',
                        style: TextStyle(color: Colors.orange))),
                FlatButton(
                    onPressed: () {
                      _onDetailsPressed(context);
                    },
                    child: Text('DETALLES',
                        style: TextStyle(color: Colors.orange))),
                widget._processedElement.dueDate != null
                    ? FlatButton(
                        onPressed: () {
                          _addToCalendar();
                        },
                        child: Text('AL CALENDARIO',
                            style: TextStyle(color: Colors.orange)))
                    : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _addToCalendar() {
    final Event event = Event(
      title: widget._processedElement.summary,
      description: _buildEventDescription(),
      startDate: DateTime.parse(widget._processedElement.dueDate),
      endDate: DateTime.parse(widget._processedElement.dueDate),
    );

    Add2Calendar.addEvent2Cal(event);
  }

  String _buildEventDescription() {
    return ''' Hola! 👋 
    
    Este evento ha sido creado por Do Things App para recordarte completar el elemento ${widget._processedElement.summary}. ''';
  }

  void _onDeletePressed(GTDElement element) {
    _elementBloc.add(MoveToDelete(element));
  }

  bool isNullOrEmpty(dynamic object) {
    return (object == null || object.isNotEmpty);
  }

  void _onDetailsPressed(BuildContext context) {
    if (widget._processedElement.imageRemotePath != null) {
      _captureBloc.add(DownloadAttachedImage(widget._processedElement));
    }

    String elementTitle = widget._processedElement.summary ?? 'Sin título';
    String elementDescription =
        isNullOrEmpty(widget._processedElement.description)
            ? 'Sin descripción'
            : widget._processedElement.description;
    String projectTitle = widget._processedElement.project != null
        ? widget._processedElement.project.title
        : 'Sin proyecto';
    List<dynamic> contexts = widget._processedElement.contexts ?? [];
    String dueDate = widget._processedElement.dueDate ?? 'Sin fecha prevista';
    dynamic createdAt =
        widget._processedElement.createdAt ?? 'Sin fecha de creación';

    List<Widget> list = [];
    for (var context in contexts) {
      list.add(Chip(label: Text(context)));
    }

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles de $elementTitle'),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Descripción',
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(elementDescription),
                ),
                Text(
                  'Proyecto',
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(projectTitle),
                ),
                Text(
                  'Contexto(s)',
                  textAlign: TextAlign.left,
                ),
                Row(
                  children: list,
                ),
                Text(
                  'Fecha prevista',
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(dueDate),
                ),
                Text(
                  'Creado el',
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(createdAt.toDate().toString()),
                ),
                Text(
                  'Archivos adjuntos',
                  textAlign: TextAlign.left,
                ),
                BlocBuilder<CaptureBloc, CaptureState>(
                  builder: (context, state) {
                    if (state is ImageDownloaded) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: _showAttachedImage(state.attachedImage),
          );
                    } else {
          return Text('Sin archivos adjuntos');
                    }
                  },
                ),
              ],
            ),
          actions: [
            FlatButton(
                onPressed: () {
                  _captureBloc.add(ClearForm());
                  BlocProvider.of<NavigatorBloc>(context)
                      .add(NavigatorActionPop());
                },
                child: Text('Cerrar')),
          ],
        );
      },
    );
  }

  Widget _showAttachedImage(Image image) {
    return Center(child: Container(child: image, height: 200, width:150));
  }

  int _calculateRecurrency(int timeInterval, String period) {
    if (period == 'WEEK') {
      return (timeInterval ~/ 604800).toInt();
    } else {
      return (timeInterval ~/ 86400).toInt();
    }
  }
}
