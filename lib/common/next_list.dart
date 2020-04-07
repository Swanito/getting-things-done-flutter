import 'package:flutter/material.dart';
import 'package:gtd/core/models/gtd_element.dart';

class NextList extends StatelessWidget {
  List<GTDElement> elements = [];

  NextList(this.elements);

  @override
  Widget build(BuildContext context) {
    if (elements.isNotEmpty) {
      return ListView(
        shrinkWrap: true,
        children: [
          Card(
            child: Text('List of elements'),
          )
        ],
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('No has creado ningún elemento todavía.'),
            ),
          ),
        ),
      );
    }

  }
}
