import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/home/more/more_screen.dart';
import 'package:gtd/home/next/next_screen.dart';
import 'package:gtd/home/procesar/process_screen.dart';
import 'package:gtd/home/revisar/review_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserRepository _userRepository;

  HomeScreen({Key key, UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState(userRepository: _userRepository);
  }
}

class HomeScreenState extends State<HomeScreen> {
  final UserRepository _userRepository;
  int _selectedTabIndex = 0;

  HomeScreenState({Key key, UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  _changeIndex(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List _pages = [
      NextScreen(userRepository: _userRepository),
      ProcessScreen(userRepository: _userRepository),
      ReviewScreen(userRepository: _userRepository),
      MoreScreen(userRepository: _userRepository),
    ];
    return Scaffold(
      body: Center(child: _pages[_selectedTabIndex]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          BlocProvider.of<NavigatorBloc>(context).add(NavigatorAction.OpenCaptureScreen)
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
  }
}
