import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/home/next/next_bloc.dart';
import 'package:gtd/home/next/next_card.dart';
import 'package:gtd/home/next/next_event.dart';

class NextList extends StatefulWidget {
  List<GTDElement> elements = [];
  bool completedElementsHidden;

  NextList(this.elements, {@required this.completedElementsHidden});

  @override
  _NextListState createState() => _NextListState();
}

class _NextListState extends State<NextList> {
  bool _initialValue;
  bool _currentValue;

  @override
  Widget build(BuildContext context) {
    _initialValue = widget.completedElementsHidden;

    if (widget.elements.isNotEmpty) {
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
                      value: _currentValue ?? _initialValue,
                      onChanged: (value) => {
                            setState(() {
                              print(
                                  'compelted elements should be hidden: $value');
                              _currentValue = value;
                              BlocProvider.of<NextBloc>(context).add(
                                  HideCompletedElements(
                                      shouldBeHidden: _currentValue));
                            })
                          })
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.elements.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: NextCard(
                        processedElement: widget.elements[index],
                      ));
                },
              ),
            ),
          ],
        ),
      );
    } else {
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
                      value: _currentValue ?? _initialValue,
                      onChanged: (value) => {
                            setState(() {
                              print(
                                  'compelted elements should be hidden: $value');
                              _currentValue = value;
                              BlocProvider.of<NextBloc>(context).add(
                                  HideCompletedElements(
                                      shouldBeHidden: _currentValue));
                            })
                          })
                ],
              ),
            ),
            Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Genial! 😃 \n No tienes ningún elemento pendiente de completar! \n 👏👏👏👏',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
