import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/models/gtd_project.dart';

// ignore: must_be_immutable
class ReviewCard extends StatelessWidget{
  List<GTDElement> filteredElementList = [];
  List<GTDElement> _completedList = [];
  List<GTDElement> elements;
  Project project;
  int _completedElements = 0;
  int _totalElements = 0;
  double _progressIndicator = 0;
  int _averageTime = 0;
  String _projectCreationDate;
  String _projectTitle;

    ReviewCard({@required this.project, @required this.elements});

  @override
  Widget build(BuildContext context) {

    _calculateProjectInfo();

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
                    onPressed: () {
                      _onShowElementsPressed(
                          context: context, elementsForProject: filteredElementList, project: project);
                    },
                    child: Text('VER ELEMENTOS',
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
    filteredElementList = elements.where((element) {
      if (element.project != null && project != null) {
        return element.project.title == project.title;
      }
      if (element.project == null && project == null) {
        return true;
      } else {
        return false;
      }
    }).toList();
  }

  _getProjectTitle() {
    _projectTitle =
        project != null ? project.title : 'Sin Proyecto Asignado';
  }

  _getProjectCreationDate() {
    if (project != null) {
      _projectCreationDate =
          'Creado el ${project.createdAt.toDate().toString().split(' ')[0]}';
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

Future<void> _onShowElementsPressed({BuildContext context, List<GTDElement> elementsForProject, Project project}) {
    return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: project != null ? Text('Elementos de ${project.title}') : Text('Elementos sin proyecto'),
        content: Container(
          width: double.maxFinite,
          height: 150,
          child: ListView.builder(
                itemCount: elementsForProject.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      title: Text('Elemento: ' + elementsForProject[index].summary),
                      subtitle: Text('Creado el ' + elementsForProject[index].createdAt.toDate().toString().split(' ')[0]),);
                },
              ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              BlocProvider.of<NavigatorBloc>(context).add(NavigatorActionPop());
            },
          ),
        ],
      );
    },
  );
  }
}
