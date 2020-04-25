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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.projects.length + 1,
          itemBuilder: (BuildContext context, int index) {
              if(index < widget.projects.length) {
                print('creando tarjeta para el proyecto ${widget.projects[index].title}');
                return ReviewCard(project: widget.projects[index], elements: widget.elements);
              } else {
                print('creando tarjeta para los elementos sin proyecto');
                return ReviewCard(project: null, elements: widget.elements);
              }
          },
        ),
      ),
    );
  }
}
