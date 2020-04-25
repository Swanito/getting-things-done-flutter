import 'package:flutter/material.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/models/gtd_project.dart';

class ReviewCard extends StatefulWidget {
  final List<GTDElement> elements;
  final Project project;

  ReviewCard({@required this.project, @required this.elements});

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  List<GTDElement> filteredElementList = [];
  List<GTDElement> _completedList = [];
  int _completedElements = 0;
  int _totalElements = 0;
  double _progressIndicator = 0;
  int _averageTime = 0;
  String _projectCreationDate;
  String _projectTitle;

  @override
  void initState() {
    _calculateProjectInfo();
    super.initState();
  }

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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _showProgressIndicator(value: _progressIndicator),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _projectTitle,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(_projectCreationDate ?? ''),
                  ],
                )
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(children: <Widget>[
              Row(
                children: <Widget>[
                  Text('Elementos completados'),
                  Spacer(),
                  Text(_completedElements.toString())
                ],
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Text('Elementos totales'),
                  Spacer(),
                  Text(_totalElements.toString())
                ],
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Text('Tiempo medio para \ncompletar un elemento'),
                  Spacer(),
                  Text(_averageTime != null
                      ? _averageTime.toString() + ' días.'
                      : 'No hay \nelementos completados')
                ],
              ),
              Divider(),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                    onPressed: () {},
                    child: Text('ACTION 1',
                        style: TextStyle(color: Colors.orange))),
                FlatButton(
                    onPressed: () {},
                    child: Text('ACTION 2',
                        style: TextStyle(color: Colors.orange))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _showProgressIndicator({double value}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          value: value,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation(Colors.orange),
        ),
      ),
    );
  }

  _calculateProjectInfo() {
    _getElementsForProject();
    _getProjectTitle();
    _getProjectCreationDate();
    _calculateCompletedElementsForProject();
    _calculateTotalElementsForProject();
    _calculateAverageTimeToCompleteElementForProject();
    _calculateProgressForProject();
  }

  _getElementsForProject() {
    filteredElementList = widget.elements.where((element) {
      if (element.project != null && widget.project != null) {
        return element.project.title == widget.project.title;
      } 
      if (element.project == null && widget.project == null) {
        return true;
      } else {
        return false;
      }
    }).toList();
  }

  _getProjectTitle() {
    _projectTitle = widget.project != null ? widget.project.title : 'Sin Proyecto Asignado';
  }

  _getProjectCreationDate() {
    if (widget.project != null) {
      _projectCreationDate = 'Creado el ${widget.project.createdAt.toDate().toString().split(' ')[0]}';
    }
  }

  _calculateCompletedElementsForProject() {
    _completedList = filteredElementList
        .where(
          (element) => element.currentStatus == 'COMPLETED',
        )
        .toList();
    _completedElements = _completedList != null ? _completedList.length : 0;
  }

  _calculateTotalElementsForProject() {
    _totalElements = filteredElementList.length;
  }

  _calculateProgressForProject() {
    if (_totalElements != 0) {
      _progressIndicator = (_completedElements / _totalElements);
    }
  }

  _calculateAverageTimeToCompleteElementForProject() {
    DateTime completedAt;
    DateTime createdAt;
    if (_completedList.isNotEmpty) {
      for (var element in _completedList) {
        completedAt = element.completedAt.toDate();
        createdAt = element.createdAt.toDate();
        _averageTime += completedAt.difference(createdAt).inDays;
      }
    }
  }
}
