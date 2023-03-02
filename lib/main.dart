import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fimber/fimber.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sacs_app/app.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  Fimber.plantTree(DebugTree());
  Intl.defaultLocale = 'it_IT';
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  timeago.setLocaleMessages('it', timeago.ItMessages());

  runApp(App());
  if (Platform.isMacOS || Platform.isWindows) {
    doWhenWindowReady(
      () {
        const initialSize = Size(1000, 750);
        appWindow.minSize = initialSize;
        appWindow.size = initialSize;
        appWindow.alignment = Alignment.center;
        appWindow.show();
      },
    );
  }
}
