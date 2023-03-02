import 'package:bloc/bloc.dart';
import 'package:sacs_app/providers/shared_preferences_provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarViewCubit extends Cubit<String?> {
  final SharedPreferencesProvider sharedPreferencesProvider;
  CalendarController calendarController = CalendarController();
  CalendarViewCubit({
    required this.sharedPreferencesProvider,
  }) : super('');

  String? calendarView = '';

  void init() async {
    emit(await sharedPreferencesProvider.calendarView);
    calendarView = (await sharedPreferencesProvider.calendarView);
  }

  void changeDate(DateTime date) => calendarController.displayDate = date;

  void changeView(String? view) async {
    if (view == 'Giorno') {
      calendarController.view = CalendarView.day;
      await sharedPreferencesProvider.setCalendarView(view!);
      emit(view);
    } else if (view == 'Settimana') {
      calendarController.view = CalendarView.week;
      await sharedPreferencesProvider.setCalendarView(view!);
      emit(view);
    } else if (view == 'Mese') {
      calendarController.view = CalendarView.month;
      await sharedPreferencesProvider.setCalendarView(view!);
      emit(view);
    }
  }
}
