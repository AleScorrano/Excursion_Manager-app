import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sacs_app/router/app_router.gr.dart';

class StatisticPage extends StatelessWidget {
  const StatisticPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('Statistic Page'),
          ),
          ElevatedButton(
              onPressed: () => context.router.push(ArchiveRoute()),
              child: Text('Route'))
        ],
      );
}
