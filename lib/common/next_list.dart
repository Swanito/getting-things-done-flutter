import 'package:flutter/material.dart';
import 'package:gtd/common/next_card.dart';
import 'package:gtd/core/models/gtd_element.dart';

class NextList extends StatelessWidget {
  List<GTDElement> elements = [];
  List<GTDElement> filteredList = [];

  NextList(this.elements)
      : filteredList = elements.where((e) => 
              e.currentStatus == 'PROCESSED' || e.currentStatus == 'COMPLETED',
            ).toList();

  @override
  Widget build(BuildContext context) {

    if (filteredList.isNotEmpty) {
      return Expanded(
              child: ListView.builder(
          shrinkWrap: true,
          itemCount: filteredList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: NextCard(processedElement: filteredList[index],)
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
              child: Text('No tienes ningún elemento pendiente de completar!'),
            ),
          ),
        ),
      );
    }
  }
}
