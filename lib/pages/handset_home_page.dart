import 'package:auto_route/auto_route.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sacs_app/blocs/calendar/bloc/calendar_bloc.dart';
import 'package:sacs_app/cubits/cubit/calendar_view_cubit.dart';
import 'package:sacs_app/pages/new_excursion_page.dart';
import 'package:sacs_app/pages/qr_scan_page.dart';
import 'package:sacs_app/pages/statistic_page.dart';
import 'package:sacs_app/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sacs_app/pages/calendar_page.dart';
import 'package:sacs_app/router/app_router.gr.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HandsetHomePage extends StatefulWidget {
  final User user;
  HandsetHomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<HandsetHomePage> createState() => _HandsetHomePageState();
}

class _HandsetHomePageState extends State<HandsetHomePage>
    with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          context: context,
          builder: (BuildContext context) => _bottomSheet(),
        ),
        child: Icon(Icons.add),
      ),
      extendBodyBehindAppBar: true,
      appBar: _appBar(context),
      bottomNavigationBar: _bottomBar(),
      body: _body(context),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) => AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: _appBarLeading(),
        title: _calendarModeDropDown(context),
        actions: [
          _appBarAction(context),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      );

  Widget _body(BuildContext context) => SafeArea(
        child: TabBarView(
          controller: tabController,
          children: [
            CalendarPage(),
            NewExcursionPage(),
            QrScanPage(),
            StatisticPage(),
          ],
        ),
      );

  Widget _bottomBar() => ConvexAppBar(
        backgroundColor: CustomTheme.primaryColor,
        controller: tabController,
        disableDefaultTabController: false,
        items: _bottomBarItems(),
        initialActiveIndex: 1,
      );

  List<TabItem> _bottomBarItems() => [
        TabItem(icon: FontAwesomeIcons.calendar, title: 'Home'),
        TabItem(icon: FontAwesomeIcons.add, title: 'Nuova'),
        TabItem(icon: FontAwesomeIcons.qrcode, title: 'Scansiona'),
        TabItem(icon: FontAwesomeIcons.chartLine, title: 'Statistiche'),
      ];

  Widget _appBarAction(BuildContext context) => Padding(
        padding: EdgeInsets.only(right: 4),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(6),
          elevation: 1,
          color: CustomTheme.complementaryColor2,
          child: IconButton(
            onPressed: () => context.router.push(SettingsRoute()),
            icon: Icon(
              FontAwesomeIcons.gear,
              color: CustomTheme.complementaryColor1,
            ),
          ),
        ),
      );

  Widget _appBarLeading() => Card(
        margin: EdgeInsets.all(8),
        color: CustomTheme.complementaryColor2,
        elevation: 1,
        shape: CircleBorder(),
        child: IconButton(
          splashColor: Colors.transparent,
          onPressed: () {},
          icon: Icon(
            FontAwesomeIcons.userLarge,
            color: CustomTheme.complementaryColor1,
            size: 24,
          ),
        ),
      );

  Widget _calendarModeDropDown(BuildContext context) => Card(
        elevation: 1,
        color: CustomTheme.complementaryColor2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButton(
          elevation: 2,
          alignment: Alignment.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: CustomTheme.complementaryColor1),
          itemHeight: null,
          iconSize: 28,
          focusColor: CustomTheme.complementaryColor1Light,
          icon: Icon(
            Icons.arrow_drop_down,
            color: CustomTheme.complementaryColor1,
          ),
          dropdownColor: CustomTheme.complementaryColor2,
          borderRadius: BorderRadius.circular(12),
          hint: Padding(
            padding: const EdgeInsets.all(6.0),
            child: BlocBuilder<CalendarViewCubit, String?>(
              builder: (context, state) {
                return Text(state ?? '');
              },
            ),
          ),
          onChanged: (value) =>
              BlocProvider.of<CalendarBloc>(context).changeView(value),
          items: _calendarMode.map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Center(child: Text(value)),
              );
            },
          ).toList(),
        ),
      );

  Widget _bottomSheet() => Container(
        decoration: BoxDecoration(
          color: CustomTheme.complementaryColor2,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
      );

  void openBottomSheet(CalendarTapDetails details) => showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        context: context,
        builder: (BuildContext context) => _bottomSheet(),
      );
}

const List<String> _calendarMode = ['Giorno', 'Mese', 'Settimana'];
