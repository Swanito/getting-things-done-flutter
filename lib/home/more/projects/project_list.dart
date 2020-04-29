import 'package:flutter/material.dart';
import 'package:gtd/core/models/gtd_project.dart';
import 'package:gtd/home/more/projects/new-project-button.dart';
import 'package:gtd/home/more/projects/project_card.dart';

// ignore: must_be_immutable
class ProjectList extends StatefulWidget {
  List<Project> elements = [];

  ProjectList(this.elements);

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  @override
  Widget build(BuildContext context) {
    if (widget.elements.isNotEmpty) {
      return Expanded(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: widget.elements.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ProjectCard(
                        project: widget.elements[index],
                      ));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: NewProjectButton(),
            )
          ],
        ),
      );
    } else {
      return Column(children: [
        Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('No hay ningún proyecto creado.'),
          ),
        ),
      ),
        NewProjectButton()
      ]);
    }
  }
}
