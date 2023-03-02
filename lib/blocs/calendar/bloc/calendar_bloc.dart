import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sacs_app/providers/shared_preferences_provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final SharedPreferencesProvider sharedPreferencesProvider;
  CalendarController calendarController = CalendarController();
  String? calendarView = '';
  CalendarBloc({
    required this.sharedPreferencesProvider,
  }) : super(CalendarViewModeState()) {
    on<CalendarEvent>((event, emit) {});
  }

  void init() async {
    calendarView = (await sharedPreferencesProvider.calendarView);
  }

  void changeView(String? view) async {
    if (view == 'Giorno') {
      calendarController.view = CalendarView.day;
      await sharedPreferencesProvider.setCalendarView(view!);
      calendarView = view;
    } else if (view == 'Settimana') {
      calendarController.view = CalendarView.week;
      await sharedPreferencesProvider.setCalendarView(view!);
      calendarView = view;
    } else if (view == 'Mese') {
      calendarController.view = CalendarView.month;
      await sharedPreferencesProvider.setCalendarView(view!);
      calendarView = view;
    }
  }
}
