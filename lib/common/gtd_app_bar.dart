import 'package:flutter/material.dart';

class GTDAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String _title;

  GTDAppBar({@required String title})
      : assert(title != null),
        _title = title;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;

    return SizedBox(
      height: media.height / 3,
      width: media.width,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                Colors.orange[600],
                Colors.orange[400],
                Colors.orange[200],
                // Colors.orange[100],
              ]),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 20.0, // has the effect of softening the shadow
              spreadRadius: 5.0, // has the effect of extending the shadow
            )
          ],
        ),
        child: Center(
          child: Text(
            _title,
            style: TextStyle(color: Colors.white, fontSize: 52),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(60);
}
