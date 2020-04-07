import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/auth/authentication_bloc.dart';
import 'package:gtd/common/gtd_app_bar.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/main.dart';

class MoreScreen extends StatelessWidget {
  final UserRepository _userRepository;

  MoreScreen({Key key, UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GTDAppBar(title: 'Más'),
          Flexible(
            child: ListView(
              children: [
                Card(
                  child: ListTile(
                    leading: Icon(Icons.link),
                    title: Text('Referenciados'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => {},
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.watch_later),
                    title: Text('En Espera'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => {},
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Papelera'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => {},
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.lightbulb_outline),
                    title: Text('Proyectos'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => {},
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Ajustes'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => {},
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.security),
                    title: Text('Permisos'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => {},
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Cerrar Sesión'),
                    onTap: () => {
                      BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut()),
                      BlocProvider.of<NavigatorBloc>(context).add(NavigatorAction.NavigateToAuthEvent)
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
