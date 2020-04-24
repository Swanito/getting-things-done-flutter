import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/capture/capture_bloc.dart';
import 'package:gtd/capture/capture_event.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/models/gtd_element.dart';

class AttachedImageCard extends StatelessWidget {
  Image image;
  String fileName;
  GTDElement element;

  AttachedImageCard({@required this.image, @required this.fileName, this.element});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      width: 200,
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => {_showImageDetail(image, fileName, context, element)},
          child: Row(
            children: <Widget>[
              Image(image: image.image),
              Spacer(),
              Text(fileName)
            ],
          ),
        ),
      )),
    );
  }

  Future<void> _showImageDetail(
      Image image, String fileName, BuildContext context, GTDElement element) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Image(image: image.image),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigatorActionPop());
              },
            ),
            FlatButton(
              child: Text('Borrar'),
              onPressed: () {
                BlocProvider.of<CaptureBloc>(context)
                    .add(DeleteAttachedImage(element));
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigatorActionPop());
              },
            ),
          ],
        );
      },
    );
  }
}
