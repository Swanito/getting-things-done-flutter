import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:gtd/core/repositories/local/local_state_bloc.dart';
import 'package:gtd/core/repositories/remote/user_repository.dart';
import 'package:lottie/lottie.dart';

import 'package:gtd/core/styles.dart';

class OnboardingScreen extends StatefulWidget {
  final UserRepository _userRepository;

  OnboardingScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _OnboardingScreenState createState() =>
      _OnboardingScreenState(userRepository: _userRepository);
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final int _numPages = 4;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  var _bgColors = [
    Colors.blue[200],
    Colors.green[200],
    Colors.pink[200],
    Colors.orange[200]
  ];

  final UserRepository _userRepository;

  _OnboardingScreenState({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  /*
  Builds the page indicator widget
  */
  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  /*
  Builds each indicator of the page indicator.
  */
  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 16.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 3),
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  /*
  Builds each page of the onboarding.
  */
  Widget _createOnboardingPage(BuildContext context,
      {String lottieUri, String title, String subtitle}) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(40.0),
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(child: Lottie.asset(
                            lottieUri,
                            width: constraints.maxWidth / 2,
                            height: constraints.maxHeight / 2,
                          ),),
              SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: kTitleStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Text(
                subtitle,
                style: kSubtitleStyle,
                textAlign: TextAlign.center,
              ),
            ],
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(color: _bgColors[_currentPage]),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: (MediaQuery.of(context).size.height / 10) * 8,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      _createOnboardingPage(context,
                          lottieUri: 'assets/onb_capturar.json',
                          title: 'Captura',
                          subtitle:
                              'Escriba, grabe o reúna todo lo que tenga su atención en una herramienta de recopilación.'),
                      _createOnboardingPage(context,
                          lottieUri: 'assets/onb_procesar.json',
                          title: 'Procesa',
                          subtitle:
                              '¿Es procesable? Si es así, decida la próxima acción y proyecto (si se requiere más de una acción). De lo contrario, decida si es basura, referencia o algo para poner en espera.'),
                      _createOnboardingPage(context,
                          lottieUri: 'assets/onb_organizar.json',
                          title: 'Organiza',
                          subtitle:
                              'Estacione recordatorios de su contenido categorizado en lugares apropiados.'),
                      _createOnboardingPage(context,
                          lottieUri: 'assets/onb_revisar.json',
                          title: 'Revisa',
                          subtitle:
                              'Actualice y revise todos los contenidos pertinentes del sistema para recuperar el control y el enfoque.'),
                    ],
                  ),
                ),
                Align(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: 100.0,
              width: double.infinity,
              color: Colors.white,
              child: GestureDetector(
                onTap: () => {
                  BlocProvider.of<LocalStatusBloc>(context)
                      .add(LocalStatusEvent.CompleteOnboardingAction),
                  BlocProvider.of<NavigatorBloc>(context)
                      .add(NavigatorAction.NavigateToAuthEvent),
                },
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: Text('Entendido!', style: kTitleStyleOrange),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }
}
