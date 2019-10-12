import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schulcloud/settings/settings.dart';
import 'package:schulcloud/login/login.dart';

import '../data.dart';
import '../app.dart';
import 'schulcloud_app.dart';

/// A menu displaying the current user and [NavigationItem]s.
class Menu extends StatelessWidget {
  final Stream<Screen> activeScreenStream;

  const Menu({@required this.activeScreenStream})
      : assert(activeScreenStream != null);

  void _navigateTo(BuildContext context, Screen target) =>
      Navigator.pop(context, target);

  void _openSettings(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => SettingsScreen(),
    ));
  }

  Future<void> _logOut(BuildContext context) async {
    await Provider.of<StorageService>(context).clear();
    Navigator.of(context).pushReplacement(TopLevelPageRoute(
      builder: (_) => LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 12,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: StreamBuilder<Screen>(
        stream: activeScreenStream,
        builder: (context, snapshot) {
          var activeScreen = snapshot.data;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8),
              _buildUserInfo(context),
              Divider(),
              ..._buildNavigationItems(context, activeScreen),
              SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return StreamBuilder<User>(
      stream: Provider.of<MeService>(context).meStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text('Not logged in yet.');
        }
        var user = snapshot.data;

        return Row(
          children: <Widget>[
            SizedBox(width: 24),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: TextStyle(fontSize: 20)),
                  Text(user.email, style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => _openSettings(context),
            ),
            IconButton(
              icon: Icon(Icons.airline_seat_legroom_reduced),
              onPressed: () => _logOut(context),
            ),
            SizedBox(width: 8),
          ],
        );
      },
    );
  }

  List<Widget> _buildNavigationItems(
      BuildContext context, Screen activeScreen) {
    Widget buildItem(Screen screen, String text, IconData iconData) {
      return NavigationItem(
        iconBuilder: (color) => Icon(iconData, color: color),
        text: text,
        onPressed: () => _navigateTo(context, screen),
        isActive: activeScreen == screen,
      );
    }

    return [
      buildItem(Screen.dashboard, 'Dashboard', Icons.dashboard),
      buildItem(Screen.news, 'News', Icons.new_releases),
      buildItem(Screen.courses, 'Courses', Icons.school),
      buildItem(Screen.homework, 'Assignments', Icons.playlist_add_check),
      buildItem(Screen.files, 'Files', Icons.folder),
    ];
  }
}

class NavigationItem extends StatelessWidget {
  final Widget Function(Color color) iconBuilder;
  final String text;
  final VoidCallback onPressed;
  final bool isActive;

  NavigationItem({
    @required this.iconBuilder,
    @required this.text,
    @required this.onPressed,
    @required this.isActive,
  })  : assert(iconBuilder != null),
        assert(text != null),
        assert(onPressed != null),
        assert(isActive != null);

  @override
  Widget build(BuildContext context) {
    var color = isActive ? Theme.of(context).primaryColor : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: isActive ? color.withOpacity(0.2) : Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: <Widget>[
                iconBuilder(color),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
