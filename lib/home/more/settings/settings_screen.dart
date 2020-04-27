import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/common/gtd_app_bar.dart';
import 'package:gtd/core/keys.dart';
import 'package:gtd/core/repositories/local/local_repository.dart';
import 'package:gtd/core/repositories/local/local_state_bloc.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';

class SettingsScreen extends StatefulWidget {
  final UserRepository _userRepository;
  final LocalRepository _localRepository;

  bool _notificationsSwitch;
  String selectedGTDLevel;
  SettingsScreen(
      {Key key, UserRepository userRepository, LocalRepository localRepository})
      : assert(userRepository != null),
        assert(localRepository != null),
        _localRepository = localRepository,
        _userRepository = userRepository;

  @override
  State<StatefulWidget> createState() {
    return SettingsScreenState();
  }
}

class SettingsScreenState extends State<SettingsScreen> {
  LocalStatusBloc _localStatusBloc;

  @override
  void initState() {
    _localStatusBloc = BlocProvider.of<LocalStatusBloc>(context);
    _localStatusBloc.add(LoadLocalSettings());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.topLeft,
              colors: [
                Colors.orange[600],
                Colors.orange[400],
                Colors.orange[200],
              ]),
        )),
      ),
      body: Column(
        children: [
          GTDAppBar(
            title: 'Settings',
            canSearch: false,
            factor: BarSizeFactor.Small,
          ),
          BlocListener<LocalStatusBloc, LocalState>(
            listener: (context, state) {
              if (state is SettingsSaved) {
                _showSnackBar(context, 'Preferencias guardadas con éxito',
                    isError: false);
                _localStatusBloc.add(LoadLocalSettings());
              }
            },
            child: BlocBuilder<LocalStatusBloc, LocalState>(
              bloc: _localStatusBloc,
              builder: (context, state) {
                if (state is SettingsLoaded) {
                  widget.selectedGTDLevel = state.gtdLevel;
                  widget._notificationsSwitch = state.reviewNotifications;

                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text('Nivel de GTD'),
                        subtitle: Text(
                            'Esto cambiará la manera de procesar elementos'),
                        contentPadding:
                            EdgeInsets.only(left: 40, right: 40, top: 20),
                        trailing: new DropdownButton<String>(
                          value:
                              _mapStringToTranslation(widget.selectedGTDLevel),
                          items: GTDLevel.values.map((GTDLevel value) {
                            return new DropdownMenuItem<String>(
                              value: _mapGTDLevelToString(value),
                              child: new Text(
                                _mapGTDLevelToString(value),
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (String value) {
                            setState(() {
                              widget.selectedGTDLevel =
                                  _mapTranslationToString(value);
                              _localStatusBloc.add(UpdateGTDLevel(
                                  level: _mapStringToGTDLevel(value)));
                            });
                          },
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Activar notificaciones de revisión'),
                        subtitle: Text(
                            'Estos activará las notificaciones para realizar las revisiones semanales y mensuales.'),
                        contentPadding:
                            EdgeInsets.only(left: 40, right: 40, top: 20),
                        trailing: Switch(
                          value: widget._notificationsSwitch,
                          onChanged: (value) {
                            setState(() {
                              widget._notificationsSwitch = value;
                              _localStatusBloc.add(SetNotificationsAllowed(
                                  notificationsAllowed:
                                      widget._notificationsSwitch));
                            });
                          },
                          activeTrackColor: Colors.orangeAccent,
                          activeColor: Colors.orange,
                        ),
                      ),
                    ],
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          )
        ],
      ),
    );
  }

  _showSnackBar(BuildContext context, String message, {bool isError}) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(message), Icon(Icons.error)],
          ),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
  }

  String _mapGTDLevelToString(GTDLevel level) {
    switch (level) {
      case GTDLevel.High:
        return 'Avanzado';
        break;
      case GTDLevel.Low:
        return 'Básico';
        break;
    }
  }

  GTDLevel _mapStringToGTDLevel(String level) {
    switch (level) {
      case 'Avanzado':
        return GTDLevel.High;
        break;
      case 'Básico':
        return GTDLevel.Low;
        break;
    }
  }

  String _mapStringToTranslation(String level) {
    switch (level) {
      case 'GTDLevel.High':
        return 'Avanzado';
        break;
      case 'GTDLevel.Low':
        return 'Básico';
        break;
    }
  }

  String _mapTranslationToString(String level) {
    switch (level) {
      case 'Avanzado':
        return 'GTDLevel.High';
        break;
      case 'Básico':
        return 'GTDLevel.Low';
        break;
    }
  }
}
