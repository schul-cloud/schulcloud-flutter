import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schulcloud/app/services/navigation.dart';

import 'menu.dart';

class MyAppBar extends StatefulWidget {
  final List<Widget> actions;

  MyAppBar({this.actions = const []});

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  Future<void> _showMenu() async {
    String targetScreen = await showModalBottomSheet(
      context: context,
      builder: (context) =>
          Menu(navigation: Provider.of<NavigationService>(context)),
    );

    if (targetScreen != null) {
      Navigator.popUntil(context, (_) => true);
      Navigator.pushReplacementNamed(context, targetScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'bottom_app_bar',
      child: Material(
        color: Theme.of(context).primaryColor,
        elevation: 6,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: _showMenu,
              ),
              Spacer(),
              ...widget.actions
            ],
          ),
        ),
      ),
    );
  }
}
