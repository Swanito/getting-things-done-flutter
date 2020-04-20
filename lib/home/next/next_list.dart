import 'package:flutter/material.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/home/next/next_card.dart';

class NextList extends StatefulWidget {
  List<GTDElement> elements = [];
  List<GTDElement> filteredList = [];
  List<GTDElement> uncompletedList = [];

  NextList(this.elements)
      : filteredList = elements
            .where(
              (e) =>
                  e.currentStatus == 'PROCESSED' ||
                  e.currentStatus == 'COMPLETED',
            )
            .toList(),
        uncompletedList =
            elements.where((e) => e.currentStatus == 'PROCESSED').toList();

  @override
  _NextListState createState() => _NextListState();
}

class _NextListState extends State<NextList> {
  bool _showAllElements = false;

  @override
  Widget build(BuildContext context) {
    if (widget.filteredList.isNotEmpty || widget.uncompletedList.isNotEmpty) {
      return Expanded(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Row(
                children: <Widget>[
                  Text('Mostrar los elementos completados'),
                  Spacer(),
                  Checkbox(
                      value: _showAllElements,
                      onChanged: (value) => {
                            setState(() {
                              _showAllElements = value;
                            })
                          })
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.filteredList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: _showAllElements
                        ? NextCard(
                            processedElement: widget.uncompletedList[index],
                          )
                        : NextCard(
                            processedElement: widget.filteredList[index],
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Genial! 😃 \n No tienes ningún elemento pendiente de completar! \n 👏👏👏👏',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
  }

  void _filterLists() {
    widget.filteredList = widget.elements
        .where(
          (e) =>
              e.currentStatus == 'PROCESSED' || e.currentStatus == 'COMPLETED',
        )
        .toList();
    widget.uncompletedList =
        widget.elements.where((e) => e.currentStatus == 'PROCESSED').toList();
  }
}
