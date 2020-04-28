import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/capture/capture_bloc.dart';
import 'package:gtd/capture/capture_event.dart';
import 'package:gtd/capture/capture_state.dart';
import 'package:gtd/common/attached_image_card.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';

class CaptureForm extends StatefulWidget {

  CaptureForm();

  @override
  State<StatefulWidget> createState() {
    return CaptureFormState();
  }
}

class CaptureFormState extends State<CaptureForm> {

  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _contextController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  CaptureBloc _captureBloc;

  bool isRecurrent = false;
  int dropdownDayValue;
  String dropdownPeriodValue;
  File _attachedImage;
  List<Chip> contextList = [];
  DateTime selectedDate = DateTime.now();

  Chip ContextChip;

  bool get isPopulated => _summaryController.text.isNotEmpty;
  bool get isContextPopulated => _contextController.text.isNotEmpty;

  CaptureFormState();

  @override
  void initState() {
    super.initState();
    _captureBloc = BlocProvider.of<CaptureBloc>(context);
    _summaryController.addListener(_onSummaryChanged);
    _descriptionController.addListener(_onDescriptionChanged);
    _projectController.addListener(_onProjectChanged);
    _contextController.addListener(_onContextChanged);
    _dateController.addListener(_onDateChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaptureBloc, CaptureState>(builder: (context, state) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Colors.orange[600],
                Colors.orange[400],
              ]),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            bottomOpacity: 0.0,
            title: Text('Capturar'),
            leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  BlocProvider.of<NavigatorBloc>(context)
                      .add(NavigatorActionPop());
                  BlocProvider.of<CaptureBloc>(context).add(ClearForm());
                }),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: ListView(
                shrinkWrap: true,
                controller: ScrollController(),
                children: [
                  TextFormField(
                    autofocus: true,
                    controller: _summaryController,
                    style:  TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.white),
                    decoration: InputDecoration(
                      icon: Icon(Icons.edit, color: Colors.white),
                      labelText: 'Título',
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                      errorStyle: TextStyle(color: Colors.white),
                      errorBorder:  UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white,
                            width: 1.0,
                            style: BorderStyle.solid),
                      ),
                      enabledBorder:  UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white,
                            width: 1.0,
                            style: BorderStyle.solid),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !isPopulated ? 'Título no válido.' : null;
                    },
                    onChanged: (text) {
                      setState(() {});
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 6,
                    child: TextFormField(
                      controller: _descriptionController,
                      style:  TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.white),
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        icon: Icon(Icons.description, color: Colors.white),
                        labelText: 'Descripción',
                        labelStyle: TextStyle(color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder:  UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 1.0,
                              style: BorderStyle.solid),
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      autocorrect: false,
                      autovalidate: true,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      FlatButton(
                          padding: const EdgeInsets.all(16.0),
                          onPressed: _onPhotoPressed,
                          child: Icon(
                            Icons.photo_camera,
                            color: Colors.white,
                          )),
                      Spacer(),
                      FlatButton(
                          padding: const EdgeInsets.all(16.0),
                          onPressed: () {},
                          child: Icon(
                            Icons.mic,
                            color: Colors.white,
                          )),
                      Spacer(),
                    ],
                  ),
                  state is ImageAttached
                      ? showTakenPicture(state)
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    color: Colors.white,
                    onPressed: isPopulated ? _onFormSubmitted : null,
                    child: Text('Crear'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _summaryController.dispose();
    _descriptionController.dispose();
    _projectController.dispose();
    super.dispose();
  }

  void _onPhotoPressed() async {
    BlocProvider.of<NavigatorBloc>(context).add(OpenCamera());
  }

  void _onSummaryChanged() {}

  void _onDescriptionChanged() {}

  void _onProjectChanged() {}

  void _onContextChanged() {}

  void _onDateChanged() {}

  void _onFormSubmitted() {
    _captureBloc.add(Capture(
        summary: _summaryController.text,
        description: _descriptionController.text,
        project: _projectController.text,
        attachedImage: _attachedImage));
    BlocProvider.of<NavigatorBloc>(context).add(NavigatorActionPop());
  }

  Widget showTakenPicture(ImageAttached state) {
    _attachedImage = state.imageFile;
    return AttachedImageCard(
      image: state.attachedImage,
      fileName: state.fileName,
    );
  }
}
