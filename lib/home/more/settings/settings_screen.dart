import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/auth/authentication_bloc.dart';
import 'package:gtd/common/gtd_app_bar.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/repositories/local/local_repository.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/main.dart';

class MoreScreen extends StatelessWidget {
  final UserRepository _userRepository;
  final LocalRepository _localRepository = LocalRepository.instance;

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
                
              ],
            ),
          )
        ],
      ),
    );
  }
}
