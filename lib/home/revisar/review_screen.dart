import 'package:flutter/material.dart';
import 'package:gtd/common/gtd_app_bar.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';

class ReviewScreen extends StatelessWidget {
  final UserRepository _userRepository;

  ReviewScreen({Key key, UserRepository userRepository})
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
          GTDAppBar(title: 'Revisar'),
        ],
      ),
    );
  }
}
