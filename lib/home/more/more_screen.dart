import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/auth/authentication_bloc.dart';
import 'package:gtd/common/gtd_app_bar.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/repositories/local/local_state_bloc.dart';
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
            title: 'Más',
            factor: BarSizeFactor.Small,
          ),
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
                    onTap: () => {
                      BlocProvider.of<NavigatorBloc>(context)
                          .add(NavigateToTrash())
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.lightbulb_outline),
                    title: Text('Proyectos'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => {
                      BlocProvider.of<NavigatorBloc>(context)
                          .add(NavigateToProjects())
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Ajustes'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => {
                      BlocProvider.of<NavigatorBloc>(context)
                          .add(OpenSettings())
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.security),
                    title: Text('Permisos'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => {
                      BlocProvider.of<NavigatorBloc>(context)
                          .add(OpenSystemSettings())
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Cerrar Sesión'),
                    onTap: () => {
                      BlocProvider.of<AuthenticationBloc>(context)
                          .add(LoggedOut()),
                      BlocProvider.of<LocalStatusBloc>(context).add(Logout()),
                      BlocProvider.of<NavigatorBloc>(context)
                          .add(GoToSplashScreen())
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
