import 'package:flutter/material.dart';

enum BarSizeFactor { Big, Small }

class GTDAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String _title;
  final bool _canSearch;
  final BarSizeFactor _factor;
  final String _currentUser;

  final TextEditingController _searchController = TextEditingController();

  GTDAppBar({@required String title, bool canSearch = false, BarSizeFactor factor = BarSizeFactor.Small, String currentUser,})
      : assert(title != null),
        assert(canSearch != null),
        _canSearch = canSearch,
        _currentUser = currentUser,
        _factor = factor,
        _title = title;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;

    return SizedBox(
      height: _factor == BarSizeFactor.Big ? media.height / 3 : media.height / 4.5,
      width: media.width,
      child: Container(
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
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 20.0, // has the effect of softening the shadow
              spreadRadius: 5.0, // has the effect of extending the shadow
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  _title,
                  style: TextStyle(color: Colors.white, fontSize: 52),
                ),
                SizedBox(height: 20,),
                _currentUser != null ? Text('Sesión iniciada como $_currentUser', style: TextStyle(color: Colors.white),) : Container(),
                SizedBox(height: 20,),
                _canSearch ? TextFormField(
                        controller: _searchController,
                        style:  TextStyle(
                            fontWeight: FontWeight.normal, color: Colors.white),
                        decoration: InputDecoration(
                          icon: Icon(Icons.search, color: Colors.white),
                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder:  UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                                style: BorderStyle.solid),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        autovalidate: true,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(60);

}
