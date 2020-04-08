import 'package:flutter/material.dart';
import 'package:gtd/common/gtd_app_bar.dart';

class ProjectScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProjectScreenState();
  }
}

class ProjectScreenState extends State<ProjectScreen> {
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
            title: 'Proyectos',
            canSearch: true,
            factor: BarSizeFactor.Small,
          ),
        ],
      ),
    );
  }
}
