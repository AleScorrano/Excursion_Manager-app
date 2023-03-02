import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sacs_app/blocs/sliding_panel_bloc/bloc/sliding_panel_bloc.dart';
import 'package:sacs_app/cubits/cubit/calendar_view_cubit.dart';
import 'package:sacs_app/theme.dart';
import 'package:sacs_app/widgets/page_selector.dart';
import 'package:sacs_app/widgets/side_bar.dart';
import 'package:sacs_app/widgets/sliding_panel.dart';
import 'package:sacs_app/widgets/view_excursion_details_panel.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class DesktopHomePage extends StatefulWidget {
  final User user;
  DesktopHomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage>
    with TickerProviderStateMixin {
  SidebarXController _sidebarController =
      SidebarXController(selectedIndex: 2, extended: false);
  late bool expanded;
  late AnimationController animationController;
  late Animation<Offset> animation;

  @override
  void initState() {
    expanded = true;
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, -1.0),
    ).animate(
        CurvedAnimation(parent: animationController, curve: Curves.bounceOut));
    super.initState();
  }

  ExpandableController expandController = ExpandableController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: _fab(),
      extendBodyBehindAppBar: true,
      body: _body(context),
    );
  }
/*
  Widget _fab() => BlocBuilder<SlidingPanelBloc, SlidingPanelBlocState>(
        builder: (context, state) {
          if (state == SlidingPanelCloseState()) {
            return FloatingActionButton(
              backgroundColor: CustomTheme.complementaryColor1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onPressed: () =>
                  BlocProvider.of<SlidingPanelBloc>(context).openPanel(),
              child: Icon(FontAwesomeIcons.add),
            );
          } else {
            return SizedBox();
          }
        },
      );
    */

  Widget _body(BuildContext context) => Row(
        children: [
          sideBar(),
          Flexible(
            child: Stack(
              children: [
                pageSelector(),
                SlidingPanel(
                  child: BlocBuilder<SlidingPanelBloc, SlidingPanelBlocState>(
                    builder: (context, state) {
                      if (state is SLidingPanelOpenState) {
                        return ExcursionDetailsPanel(
                          excursion: state.excursionStream,
                          reservations: state.reservationsStream,
                        );
                      }
                      return SizedBox();
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      );

  Widget sideBar() => MoveWindow(
        child: SideBar(
          user: widget.user,
          controller: _sidebarController,
        ),
      );

  Widget pageSelector() => Padding(
        padding: const EdgeInsets.only(
          top: 16.0,
          left: 8,
          right: 4,
        ),
        child: PageSelector(controller: _sidebarController),
      );

  Widget confirmButton() => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              backgroundColor:
                  MaterialStatePropertyAll(CustomTheme.complementaryColor1),
            ),
            onPressed: () {},
            child: Text(
              'Prenota',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: CustomTheme.complementaryColor2,
              ),
            ),
          ),
        ),
      );

  Widget datePicker() => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: CustomTheme.seconadaryColorLight,
            width: 2,
          ),
        ),
        child: SfDateRangePicker(
          selectionMode: DateRangePickerSelectionMode.single,
        ),
      );

  Widget _datePicker(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 12, right: 12),
        child: Container(
          decoration: BoxDecoration(
            color: CustomTheme.complementaryColor2,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TimePickerSpinnerPopUp(
            mode: CupertinoDatePickerMode.date,
            controller: TimePickerSpinnerController(),
            onChange: (date) =>
                BlocProvider.of<CalendarViewCubit>(context).changeDate(date),
          ),
        ),
      );
}
