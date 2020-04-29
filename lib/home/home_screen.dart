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

  HomeScreen(
      {Key key, UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  LocalStatusBloc _localStatusBloc;

  _changeIndex(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _localStatusBloc = BlocProvider.of<LocalStatusBloc>(context)
      ..add(SetNotificationsAllowed(notificationsAllowed: false));
    _localStatusBloc.add(CheckIfGTDLevelIsKnwon());
  }

  @override
  Widget build(BuildContext context) {
    List _pages = [
      NextScreen(),
      ProcessScreen(),
      ReviewScreen(),
      MoreScreen(
        userRepository: widget._userRepository,
      ),
    ];

    return BlocListener<LocalStatusBloc, LocalState>(
        listener: (context, state) {
      if (state is GTDLevelUnknown) {
        return _showGTDLevelDialog(context);
      }
    }, child:
            BlocBuilder<LocalStatusBloc, LocalState>(builder: (context, state) {
      return Scaffold(
        body: Center(child: _pages[_selectedTabIndex]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            BlocProvider.of<NavigatorBloc>(context).add(OpenCaptureScreen())
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
            BottomNavigationBarItem(title: Text('Más'), icon: Icon(Icons.menu))
          ],
        ),
      );
    }));
  }

  _showGTDLevelDialog(BuildContext context) async {
    await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
                'Antes de empezar, cúal dirías que es tu nivel usando GTD?'),
            actions: [
              FlatButton(
                child: Text('Básico'),
                onPressed: () {
                  BlocProvider.of<LocalStatusBloc>(context)
                      .add(SetGTDLevel(level: GTDLevel.Low));
                  BlocProvider.of<NavigatorBloc>(context)
                      .add(NavigatorActionPop());
                },
              ),
              FlatButton(
                child: Text('Avanzado'),
                onPressed: () {
                  BlocProvider.of<LocalStatusBloc>(context)
                      .add(SetGTDLevel(level: GTDLevel.High));
                  BlocProvider.of<NavigatorBloc>(context)
                      .add(NavigatorActionPop());
                },
              ),
            ],
          );
        });
  }
}
