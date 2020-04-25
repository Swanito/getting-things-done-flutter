import 'package:flutter/material.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/models/gtd_project.dart';
import 'package:gtd/home/review/review_card.dart';

class ReviewList extends StatefulWidget {
  final List<GTDElement> elements;
  final List<Project> projects;

  ReviewList({@required this.elements, @required this.projects});

  @override
  _ReviewListState createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  @override
  Widget build(BuildContext context) {
    // projects + 1 cards (sin proyecto)
    // a cada card pasarle toda la lista de elementos y filtrarlos en cada card

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.projects.length + 1,
          itemBuilder: (BuildContext context, int index) {
            try {
              return ReviewCard(project: widget.projects[index], elements: widget.elements);
            } catch (error) {
              return ReviewCard(project: null, elements: widget.elements);
            }
          },
        ),
      ),
    );
  }

  List<GTDElement> _getElementsWithoutProject(List<GTDElement> elements) {
    List<GTDElement> _elementsWithoutProject = [];
    for (var element in elements) {
      if (element.project == null) {
        _elementsWithoutProject.add(element);
        elements.remove(element);
      }
    }
    return _elementsWithoutProject;
  }
}
