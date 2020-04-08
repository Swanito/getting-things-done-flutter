import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/capture/capture_bloc.dart';
import 'package:gtd/capture/capture_event.dart';
import 'package:gtd/capture/capture_state.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';

class CaptureForm extends StatefulWidget {
  final UserRepository _userRepository;

  CaptureForm({@required userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  State<StatefulWidget> createState() {
    return CaptureFormState(userRepository: _userRepository);
  }
}

class CaptureFormState extends State<CaptureForm> {
  final UserRepository _userRepository;

  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _contextController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  CaptureBloc _captureBloc;

  bool isRecurrent = false;

  CaptureFormState({@required userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

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
    Size size = MediaQuery.of(context).size;
    return BlocListener<CaptureBloc, CaptureState>(
      listener: (context, state) {
        //if state is blabla
      },
      child: BlocBuilder<CaptureBloc, CaptureState>(builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.orange,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            bottomOpacity: 0.0,
            title: Text('Capturar'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TextFormField(
                  controller: _summaryController,
                  style: new TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.white),
                  decoration: InputDecoration(
                    icon: Icon(Icons.edit, color: Colors.white),
                    labelText: 'Título',
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: new UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white,
                          width: 1.0,
                          style: BorderStyle.solid),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  autovalidate: true,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _descriptionController,
                  style: new TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.white),
                  maxLines: null,
                  decoration: InputDecoration(
                    icon: Icon(Icons.description, color: Colors.white),
                    labelText: 'Descripción',
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: new UnderlineInputBorder(
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
                        onPressed: () {},
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
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _projectController,
                  style: new TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.white),
                  maxLines: null,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lightbulb_outline, color: Colors.white),
                    labelText: 'Proyecto',
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: new UnderlineInputBorder(
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
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _contextController,
                  style: new TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.white),
                  maxLines: null,
                  decoration: InputDecoration(
                    icon: Icon(Icons.dialpad, color: Colors.white),
                    labelText: 'Contexto',
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: new UnderlineInputBorder(
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
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _dateController,
                  style: new TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.white),
                  maxLines: null,
                  decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today, color: Colors.white),
                    labelText: 'Fecha fin',
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: 'dd/mm/AAAA',
                    enabledBorder: new UnderlineInputBorder(
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
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isRecurrent,
                      onChanged: _checkBoxMarked,
                      activeColor: Colors.transparent,
                      checkColor: Colors.white,
                    ),
                    Text(
                      'Es un evento recurrente',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: _onFormSubmitted,
                  child: Text('Crear'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _summaryController.dispose();
    _descriptionController.dispose();
    _projectController.dispose();
    super.dispose();
  }

  void _onSummaryChanged() {}

  void _onDescriptionChanged() {}

  void _onProjectChanged() {}

  void _onContextChanged() {}

  void _onDateChanged() {}

  void _onFormSubmitted() {
    _captureBloc.add(Capture(
      summary: _summaryController.text,
      description: _descriptionController.text
    ));
    BlocProvider.of<NavigatorBloc>(context).add(NavigatorAction.NavigatorActionPop);
  }

  void _checkBoxMarked(bool newValue) => setState(() {
        isRecurrent = newValue;

        if (isRecurrent) {
          // TODO: Here goes your functionality that remembers the user.
        } else {
          // TODO: Forget the user
        }
      });
}