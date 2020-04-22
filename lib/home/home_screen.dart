import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/repositories/local/local_state_bloc.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/home/more/more_screen.dart';
import 'package:gtd/home/next/next_screen.dart';
import 'package:gtd/home/procesar/process_screen.dart';
import 'package:gtd/home/review/review_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserRepository _userRepository;
  final String _currentUser;

  HomeScreen({Key key, UserRepository userRepository, String currentUser = "Unknown"})
      : assert(userRepository != null),
      assert(currentUser != null),
        _userRepository = userRepository,
        _currentUser = currentUser;

  @override
  State<StatefulWidget> createState() {
    print('Current user is $_currentUser');
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;

  _changeIndex(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List _pages = [
      NextScreen(userRepository: widget._userRepository),
      ProcessScreen(userRepository: widget._userRepository),
      ReviewScreen(userRepository: widget._userRepository),
      MoreScreen(userRepository: widget._userRepository, currentUser: widget._currentUser,),
    ];

    return BlocBuilder<LocalStatusBloc, LocalState>(builder: (context, state) {
      if (state is GTDLevelUnknown) {
        return AlertDialog(
          content:
              Text('Antes de empezar, cúal dirías que es tu nivel usando GTD?'),
          actions: [
            FlatButton(
              child: Text('Básico'),
              onPressed: () {
                BlocProvider.of<LocalStatusBloc>(context)
                    .add(SetGTDLevel(level: GTDLevel.Low));
              },
            ),
            FlatButton(
              child: Text('Avanzado'),
              onPressed: () {
                BlocProvider.of<LocalStatusBloc>(context)
                    .add(SetGTDLevel(level: GTDLevel.High));
              },
            ),
          ],
        );
      }
      return Scaffold(
        body: Center(child: _pages[_selectedTabIndex]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            BlocProvider.of<NavigatorBloc>(context)
                .add(OpenCaptureScreen())
          },
          backgroundColor: Colors.orange,
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTabIndex,
          onTap: _changeIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.orange,
          items: [
            BottomNavigationBarItem(
                title: Text('Next'), icon: Icon(Icons.next_week)),
            BottomNavigationBarItem(
                title: Text('Procesar'), icon: Icon(Icons.store)),
            BottomNavigationBarItem(
                title: Text('Revisar'), icon: Icon(Icons.youtube_searched_for)),
            BottomNavigationBarItem(
                title: Text('Más'), icon: Icon(Icons.settings))
          ],
        ),
      );
    });
  }
}
