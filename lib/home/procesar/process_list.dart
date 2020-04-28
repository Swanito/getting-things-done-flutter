import 'package:flutter/material.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/home/procesar/process_card.dart';

class ProcessList extends StatefulWidget {

  List<GTDElement> elements = [];
  List<GTDElement> filteredList = [];

  ProcessList(this.elements)
      : filteredList = elements
            .where(
              (e) => e.currentStatus == 'COLLECTED',
            )
            .toList();

  @override
  _ProcessListState createState() => _ProcessListState();
}

class _ProcessListState extends State<ProcessList> {
  @override
  Widget build(BuildContext context) {
    if (widget.filteredList.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.filteredList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProcessCard(
                collectedElement: widget.filteredList[index],
              ),
            );
          },
        ),
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
