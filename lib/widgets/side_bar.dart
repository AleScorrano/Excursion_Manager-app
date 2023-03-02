import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sacs_app/blocs/calendar/bloc/calendar_bloc.dart';
import 'package:sacs_app/cubits/auth/cubit/auth_cubit.dart';
import 'package:sacs_app/extensions/user_initials.dart';
import 'package:sacs_app/pages/widgets/calendar_mode_radio.dart';
import 'package:sacs_app/theme.dart';
import 'package:sidebarx/sidebarx.dart';

class SideBar extends StatelessWidget {
  final SidebarXController controller;
  final User user;

  SideBar({
    super.key,
    required this.controller,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      headerBuilder: (context, extended) =>
          extended ? extendedHeaderWidget(context) : normalHeaderWidget(),
      separatorBuilder: (context, index) => Divider(
        color: CustomTheme.primaryColorlight,
        indent: 8,
        endIndent: 8,
        thickness: 1,
      ),
      footerDivider: Divider(
        color: CustomTheme.primaryColorlight,
        thickness: 1,
      ),
      controller: controller,
      extendedTheme: SidebarXTheme(
        textStyle: TextStyle(
          letterSpacing: 1,
          color: CustomTheme.complementaryColor2,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        selectedTextStyle: TextStyle(color: CustomTheme.complementaryColor1),
        selectedItemTextPadding: EdgeInsets.only(left: 16),
        width: 160,
        itemTextPadding: EdgeInsets.only(left: 16),
      ),
      theme: SidebarXTheme(
        selectedIconTheme: IconThemeData(
          color: CustomTheme.complementaryColor1,
        ),
        iconTheme: IconThemeData(
          color: CustomTheme.primaryColorDark,
        ),
        decoration: BoxDecoration(
          color: CustomTheme.primaryColor,
        ),
        width: 100,
      ),
      items: _sideBarItems(context),
      footerBuilder: (context, extended) => extended
          ? CalendarModeRadio()
          : Container(
              margin: EdgeInsets.all(4),
              padding: EdgeInsets.all(8),
              child: Text(
                BlocProvider.of<CalendarBloc>(context).calendarView ?? '',
                style: TextStyle(
                    color: CustomTheme.primaryColorDark,
                    fontWeight: FontWeight.w600),
              ),
              decoration: BoxDecoration(
                color: CustomTheme.primaryColorlight,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
    );
  }

  List<SidebarXItem> _sideBarItems(BuildContext context) => [
        SidebarXItem(
          icon: FontAwesomeIcons.chartLine,
          label: 'Statistiche',
        ),
        SidebarXItem(icon: FontAwesomeIcons.calendar, label: 'Calendario'),
        SidebarXItem(
            icon: Platform.isIOS || Platform.isAndroid
                ? FontAwesomeIcons.qrcode
                : FontAwesomeIcons.ticket,
            label: Platform.isIOS || Platform.isAndroid
                ? 'Scansiona'
                : 'Convalida'),
        SidebarXItem(icon: FontAwesomeIcons.gear, label: 'Impostazioni'),
        SidebarXItem(icon: FontAwesomeIcons.boxArchive, label: 'Archivio'),
      ];

  Widget extendedHeaderWidget(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 30.0, bottom: 0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: CustomTheme.primaryColorlight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.user,
                      size: 32,
                    ),
                    SizedBox(height: 8),
                    Text(
                      user.displayNameInitials,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 4,
              child: Card(
                shadowColor: Colors.black,
                elevation: 7,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                color: CustomTheme.secondaryColorDark,
                child: IconButton(
                  splashRadius: 20,
                  onPressed: () => onLogOut(context),
                  icon: Icon(
                    Icons.logout,
                    size: 18,
                    color: CustomTheme.complementaryColor2,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget normalHeaderWidget() => Padding(
        padding: const EdgeInsets.only(top: 30.0, bottom: 30),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: CustomTheme.primaryColorlight,
          child: Text(
            user.displayNameInitials,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      );

  void onLogOut(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('Sei sicuro di voler uscire?'),
          actions: [
            TextButton(
              onPressed: () {
                BlocProvider.of<AuthCubit>(context).signOut();
                context.router.popUntilRoot();
              },
              child: Text('SI'),
            ),
            TextButton(
              onPressed: () {
                context.router.pop();
              },
              child: Text('NO'),
            ),
          ],
        ),
      );
}
