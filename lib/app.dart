import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loadingindicator/flutter_loadingindicator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sacs_app/di/dependency_injector.dart';
import 'package:sacs_app/router/app_router.gr.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

class App extends StatelessWidget {
  final _appRouter = AppRouter();

  App({super.key});

  @override
  Widget build(BuildContext context) => DependencyInjector(
        child: MaterialApp.router(
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Inter',
          ),
          routerDelegate: AutoRouterDelegate(_appRouter),
          routeInformationParser: _appRouter.defaultRouteParser(),
          localizationsDelegates: [
            GlobalCupertinoLocalizations.delegate,
            SfGlobalLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [const Locale('it')],
          locale: const Locale('it'),
        ),
      );
}
