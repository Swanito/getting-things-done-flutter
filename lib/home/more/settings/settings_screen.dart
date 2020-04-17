import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/common/gtd_app_bar.dart';
import 'package:gtd/core/repositories/local/local_repository.dart';
import 'package:gtd/core/repositories/local/local_state_bloc.dart';
import 'package:gtd/core/repositories/remote/element_repository.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/home/elements/element_bloc.dart';
import 'package:gtd/home/more/trash/trash_list.dart';
import 'package:path/path.dart';

class SettingsScreen extends StatefulWidget {
  final UserRepository _userRepository;
  final LocalRepository _localRepository;

  SettingsScreen(
      {Key key, UserRepository userRepository, LocalRepository localRepository})
      : assert(userRepository != null),
        assert(localRepository != null),
        _localRepository = localRepository,
        _userRepository = userRepository;

  @override
  State<StatefulWidget> createState() {
    return SettingsScreenState(
        userRepository: _userRepository, localRepository: _localRepository);
  }
}

class SettingsScreenState extends State<SettingsScreen> {
  String selectedGTDLevel;
  String currentGtdLevel;

  final UserRepository _userRepository;
  final LocalRepository _localRepository;
  LocalStatusBloc _localStatusBloc;

  SettingsScreenState(
      {Key key, UserRepository userRepository, LocalRepository localRepository})
      : assert(userRepository != null),
        assert(localRepository != null),
        _localRepository = localRepository,
        _userRepository = userRepository;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    BlocProvider.of<LocalStatusBloc>(context).add(LoadLocalSettings());

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
          BlocBuilder<LocalStatusBloc, LocalState>(
            builder: (context, state) {
              if (state is SettingsLoaded) {
                currentGtdLevel = state.gtdLevel;
                print('Current GTD level is $currentGtdLevel');
              }
              if (state is SettingsSaved) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Preferencias guardadas con éxito'),
                  ));
                  BlocProvider.of<LocalStatusBloc>(context).add(LoadLocalSettings());
                });
              }
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text('Nivel de GTD'),
                    subtitle:
                        Text('Esto cambiará la manera de procesar elementos'),
                    contentPadding:
                        EdgeInsets.only(left: 40, right: 40, top: 20),
                    trailing: new DropdownButton<String>(
                      value: selectedGTDLevel,
                      items: <String>['Básico', 'Avanzado'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(
                            value,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGTDLevel = value;
                        });
                      },
                    ),
                  ),
                  Divider(),
                  RaisedButton(
                    onPressed: () {
                      if (selectedGTDLevel.contains('Avanzado')) {
                        BlocProvider.of<LocalStatusBloc>(context)
                            .add(UpdateGTDLevel(level: GTDLevel.High));
                      } else {
                        BlocProvider.of<LocalStatusBloc>(context)
                            .add(UpdateGTDLevel(level: GTDLevel.Low));
                      }
                    },
                    child: Text('Guardar cambios'),
                    color: Colors.white,
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }

  _showErrorSnackbar(BuildContext context) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  'Error recuperarndo los elementos. Intentalo de nuevo más tarde.'),
              Icon(Icons.error)
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
  }
}
