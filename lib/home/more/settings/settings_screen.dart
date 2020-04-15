import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/common/gtd_app_bar.dart';
import 'package:gtd/core/repositories/local/local_repository.dart';
import 'package:gtd/core/repositories/local/local_state_bloc.dart';
import 'package:gtd/core/repositories/remote/element_repository.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/home/elements/element_bloc.dart';
import 'package:gtd/home/more/trash/trash_list.dart';

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
    return SettingsScreenState(userRepository: _userRepository, localRepository: _localRepository);
  }
}

class SettingsScreenState extends State<SettingsScreen> {
  // GTDLevel gtdLevel;
  String gtdLevel;

  final UserRepository _userRepository;
  final LocalRepository _localRepository;

  SettingsScreenState(
      {Key key, UserRepository userRepository, LocalRepository localRepository})
      : assert(userRepository != null),
        assert(localRepository != null),
        _localRepository = localRepository,
        _userRepository = userRepository;

  @override
  void initState() {
    super.initState();
    _localRepository.getGTDLevel().then((level) {
      gtdLevel = level;
      print(level);
    });
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
                // Colors.orange[100],
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
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text('Nivel de GTD'),
                    subtitle:
                        Text('Esto cambiará la manera de procesar elementos'),
                    contentPadding:
                        EdgeInsets.only(left: 40, right: 40, top: 20),
                    trailing: new DropdownButton<String>(
                      value: gtdLevel == 'GTDLevel.Low' ? 'Basico' : 'Avanzado',
                      items: <String>['Basico', 'Avanzado'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value, style: TextStyle(color: Colors.black),),
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ),
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