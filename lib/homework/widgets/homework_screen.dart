import 'package:collection/collection.dart' show groupBy;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schulcloud/app/app.dart';

import '../bloc.dart';
import '../data.dart';
import 'homework_card.dart';

class HomeworkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProxyProvider2<NetworkService, UserService, Bloc>(
      builder: (_, network, user, __) => Bloc(network: network, user: user),
      child: Scaffold(body: _HomeworkList()),
    );
  }
}

class _HomeworkList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Homework>>(
      stream: Provider.of<Bloc>(context).getHomework(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error occurred: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var assignments = groupBy<Homework, DateTime>(
          snapshot.data,
          (Homework h) =>
              DateTime(h.dueDate.year, h.dueDate.month, h.dueDate.day),
        );
        var dates = assignments.keys.toList()..sort((a, b) => b.compareTo(a));
        return ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              for (var key in dates) ...[
                ListTile(title: Text(dateTimeToString(key))),
                for (var homework in assignments[key])
                  HomeworkCard(homework: homework),
              ],
            ],
          ).toList(),
        );
      },
    );
  }
}