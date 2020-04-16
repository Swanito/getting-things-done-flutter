import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/capture/capture_bloc.dart';
import 'package:gtd/capture/capture_event.dart';
import 'package:gtd/capture/capture_state.dart';
import 'package:gtd/common/attached_image_card.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/home/procesar/bloc/process_bloc.dart';
import 'package:gtd/home/procesar/bloc/process_event.dart';

class AdvancedProcessForm extends StatefulWidget {
  final UserRepository _userRepository;
  final bool _isEditing;
  final GTDElement _element;

  AdvancedProcessForm({@required userRepository, @required isEditing, @required element})
      : assert(userRepository != null),
        assert(isEditing != null),
        assert(element != null),
        _element = element,
        _isEditing = isEditing,
        _userRepository = userRepository;

  @override
  State<StatefulWidget> createState() {
    return AdvancedProcessFormState(
        userRepository: _userRepository, isEditing: _isEditing, elementInFocus: _element);
  }
}

class AdvancedProcessFormState extends State<AdvancedProcessForm> {
  final UserRepository _userRepository;
  final GTDElement _elementInFocus;

  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _contextController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  ProcessBloc _processBloc;

  bool isRecurrent = false;
  bool _isEditing;
  int dropdownDayValue;
  String dropdownPeriodValue;
  Image _attachedImage;
  List<Chip> contextList = [];
  DateTime selectedDate = DateTime.now();

  Chip newContextChip;

  bool get isPopulated => _summaryController.text.isNotEmpty;
  bool get isContextPopulated => _contextController.text.isNotEmpty;

  AdvancedProcessFormState({@required userRepository, @required isEditing, @required elementInFocus})
      : assert(userRepository != null),
        assert(isEditing != null),
        assert(elementInFocus != null),
        _isEditing = isEditing,
        _userRepository = userRepository,
        _elementInFocus = elementInFocus;

  @override
  void initState() {
    super.initState();
    _processBloc = BlocProvider.of<ProcessBloc>(context);
    _summaryController.addListener(_onSummaryChanged);
    _descriptionController.addListener(_onDescriptionChanged);
    _projectController.addListener(_onProjectChanged);
    _contextController.addListener(_onContextChanged);
    _dateController.addListener(_onDateChanged);
    _summaryController.text = _elementInFocus.summary;
    _descriptionController.text = _elementInFocus.description;
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
                Colors.orange[300],
              ]),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            bottomOpacity: 0.0,
            title: Text('Procesar'),
            leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  BlocProvider.of<CaptureBloc>(context).add(ClearForm());
                  BlocProvider.of<NavigatorBloc>(context)
                      .add(NavigatorActionPop());
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
                    controller: _summaryController,
                    style: new TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.white),
                    decoration: InputDecoration(
                      icon: Icon(Icons.edit, color: Colors.white),
                      labelText: 'Título',
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                      errorStyle: TextStyle(color: Colors.white),
                      errorBorder: new UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white,
                            width: 1.0,
                            style: BorderStyle.solid),
                      ),
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
                      ? AttachedImageCard(
                          image: state.attachedImage, fileName: state.fileName)
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _projectController,
                    style: new TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.white),
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
                    keyboardType: TextInputType.text,
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
                        suffix: FlatButton(
                          onPressed: isContextPopulated
                              ? () {
                                  _addChip(_contextController.text);
                                }
                              : null,
                          child: Text('AÑADIR',
                              style: TextStyle(color: Colors.white)),
                        )),
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    autovalidate: true,
                    onChanged: (text) {
                      setState(() {});
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: contextList.toList()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _dateController,
                    style: new TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.white),
                    decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today, color: Colors.white),
                      labelText: 'Fecha ocurrencia',
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                      enabledBorder: new UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white,
                            width: 1.0,
                            style: BorderStyle.solid),
                      ),
                    ),
                    onTap: () => _selectDate(context),
                    keyboardType: TextInputType.text,
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
                  isRecurrent ? _showRecurrentField() : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    color: Colors.white,
                    onPressed: isPopulated ? _onFormSubmitted : null,
                    child: Text('Procesar'),
                  ),
                  FlatButton(
                    onPressed: isPopulated ? _onFormSubmitted : null,
                    child: Text('Mover a Referencias', style: TextStyle(color: Colors.white)),
                  ),
                  FlatButton(
                    onPressed: isPopulated ? _onFormSubmitted : null,
                    child: Text('Esperando por...', style: TextStyle(color: Colors.white)),
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
    _processBloc.add(ProcessElement(element: _elementInFocus));
    BlocProvider.of<NavigatorBloc>(context)
        .add(NavigatorActionPop());
  }

  void _addChip(String chipLabel) => setState(() => {
        newContextChip = Chip(
            label: Text(chipLabel),
            backgroundColor: Colors.white,
            deleteIconColor: Colors.orange,
            onDeleted: () {
              setState(() {
                contextList.removeWhere((entryChip) {
                  entryChip.label == chipLabel;
                });
              });
            }),
        contextList.add(newContextChip)
      });

  void _checkBoxMarked(bool newValue) => setState(() {
        isRecurrent = newValue;
      });

  Widget _showRecurrentField() {
    var list = new List<int>.generate(31, (i) => i + 1);

    return Row(
      children: <Widget>[
        Text('Ocurre cada ', style: TextStyle(color: Colors.white)),
        DropdownButton<int>(
          value: dropdownDayValue,
          underline: Container(
            height: 2,
            color: Colors.white,
          ),
          onChanged: (int newValue) {
            setState(() {
              dropdownDayValue = newValue;
            });
          },
          items: list.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString()),
            );
          }).toList(),
        ),
        Text(' '),
        DropdownButton<String>(
          value: dropdownPeriodValue,
          underline: Container(
            height: 2,
            color: Colors.white,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownPeriodValue = newValue;
            });
          },
          items: <String>['Dias', 'Semanas']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )
      ],
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        locale: const Locale('es', 'ES'),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateController.text = selectedDate.toLocal().toString().split(' ')[0];
      });
  }
}
