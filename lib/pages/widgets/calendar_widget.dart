import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sacs_app/blocs/calendar/bloc/calendar_bloc.dart';
import 'package:sacs_app/blocs/sliding_panel_bloc/bloc/sliding_panel_bloc.dart';
import 'package:sacs_app/models/excursion_data_source.dart';
import 'package:sacs_app/models/excursion_model.dart';
import 'package:sacs_app/pages/widgets/dialog/new_excursion_dialog.dart';
import 'package:sacs_app/pages/widgets/excursion_widget.dart';
import 'package:sacs_app/theme.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatelessWidget {
  final AsyncSnapshot snapshot;
  final CalendarState calendarState;
  const CalendarWidget({
    super.key,
    required this.snapshot,
    required this.calendarState,
  });

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      cellEndPadding: 0,
      timeSlotViewSettings: TimeSlotViewSettings(
        timeFormat: 'h a',
      ),
      timeZone: 'Central European Standard Time',
      appointmentBuilder: ExcursionWeekWidget,
      onTap: (calendarTapDetails) =>
          onCalendarCellTap(calendarTapDetails, context, snapshot.data!),
      dataSource: ExcursionDataSource(snapshot.data!),
      controller: BlocProvider.of<CalendarBloc>(context).calendarController,
      view:
          getCalendarView(BlocProvider.of<CalendarBloc>(context).calendarView),
    );
  }

  void onCalendarCellTap(CalendarTapDetails tapDetails, BuildContext context,
      List<Excursion> calendarData) {
    if (tapDetails.appointments == null) {
      List<Excursion> thisDayExcursions =
          getDayExcursion(tapDetails, calendarData);
      showNewExcursionDialog(
        tapDetails,
        context,
        thisDayExcursions,
      );
    } else {
      BlocProvider.of<SlidingPanelBloc>(context)
          .openPanel(tapDetails.appointments!.first);
    }
  }

  List<Excursion> getDayExcursion(
      CalendarTapDetails tapDetail, List<Excursion> excursions) {
    return excursions
        .where((excursion) => excursion.startTime.day == tapDetail.date!.day)
        .toList();
  }

  CalendarView getCalendarView(String? view) {
    if (view == 'Giorno') {
      return CalendarView.day;
    } else if (view == 'Settimana') {
      return CalendarView.week;
    } else if (view == 'Mese') {
      return CalendarView.month;
    }
    return CalendarView.week;
  }

  Widget _loadingIndicator() => Center(child: CircularProgressIndicator());

  Widget _errorWidget() => Center(
        child: Text('Errore durante il download dei dati.'),
      );

  void showNewExcursionDialog(CalendarTapDetails details, BuildContext context,
          List<Excursion> thisDayExcursion) =>
      showDialog(
        context: context,
        builder: (context) => NewExcursionDialog(
          dateDetails: details,
          thisDayExcursions: thisDayExcursion,
        ),
      );

  void openBottomSheet(CalendarTapDetails details, BuildContext context) =>
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        context: context,
        builder: (BuildContext context) => _bottomSheet(),
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
}
