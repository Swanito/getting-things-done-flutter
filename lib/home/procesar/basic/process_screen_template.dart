import 'package:flutter/material.dart';
import 'package:gtd/core/models/gtd_element.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:gtd/core/styles.dart';
import 'package:lottie/lottie.dart';

// typedef void ContinueCallback(
//     {GTDElement element, UserRepository userRepository});
// typedef void AlternativeCallback(
//     {GTDElement element, UserRepository userRepository});

class ProcessScreenTemplate extends StatelessWidget {
  final String title;
  final String description;
  final String lottie;
  final Function continueFunction;
  final Function alternativeFunction;

  final UserRepository userRepository;

  final GTDElement elementBeingProcessed;

  ProcessScreenTemplate(
      {@required this.title,
      @required this.description,
      @required this.lottie,
      @required this.continueFunction,
      @required this.alternativeFunction,
      @required this.userRepository,
      @required this.elementBeingProcessed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width - 100,
              child: Lottie.asset(lottie),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height / 15,
              width: MediaQuery.of(context).size.width - 100,
              child: Center(child: Text(title, style: TextStyle(fontSize: 26), textAlign: TextAlign.center,))
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                height: MediaQuery.of(context).size.height / 10,
                width: MediaQuery.of(context).size.width - 100,
                child: Center(child: Text(description, textAlign: TextAlign.center))),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(children: [
              yesButton(context, continueFunction),
              noButton(context, alternativeFunction)
            ]),
          )
        ],
      ),
    );
  }

  Widget yesButton(BuildContext context, Function continueFunction) {
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      child: RaisedButton(
        color: Colors.orange,
        textColor: Colors.white,
        onPressed: () => continueFunction(userRepository: userRepository, element: elementBeingProcessed),
        child: Text('Sí'),
      ),
    );
  }

  Widget noButton(BuildContext context, Function alternativeFunction) {
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      child: RaisedButton(
        color: Colors.white,
        onPressed: () => alternativeFunction(userRepository: userRepository, element: elementBeingProcessed),
        child: Text('No'),
      ),
    );
  }
}
