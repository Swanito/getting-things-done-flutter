import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/auth/authentication_bloc.dart';

class HomeScreen extends StatelessWidget {
  final String name;

  HomeScreen({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(
                LoggedOut(),
              );
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(child: Text('Welcome $name!')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(title: Text('Next'), icon: Icon(Icons.next_week)),
        BottomNavigationBarItem(title: Text('Revisar'), icon: Icon(Icons.youtube_searched_for)),
        BottomNavigationBarItem(title: Text('Procesar'), icon: Icon(Icons.store)),
        BottomNavigationBarItem(title: Text('Ajustes'), icon: Icon(Icons.settings))
      ]),
    );
  }
}
