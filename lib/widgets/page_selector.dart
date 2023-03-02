import 'package:flutter/material.dart';
import 'package:sacs_app/pages/archive_page.dart';
import 'package:sacs_app/pages/qr_scan_page.dart';
import 'package:sacs_app/pages/settings_page.dart';
import 'package:sacs_app/pages/statistic_page.dart';
import 'package:sacs_app/pages/calendar_page.dart';
import 'package:sidebarx/sidebarx.dart';

class PageSelector extends StatelessWidget {
  const PageSelector({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.selectedIndex) {
          case 0:
            return StatisticPage();
          case 1:
            return CalendarPage();
          case 2:
            return QrScanPage();
          case 3:
            return SettingsPage();
          case 4:
            return ArchivePage();

          default:
            return Text(
              'Not found page',
            );
        }
      },
    );
  }
}
