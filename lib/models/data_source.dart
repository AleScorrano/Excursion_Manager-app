import 'package:sacs_app/models/excursion_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Excursion> source) {
    appointments = source;
  }
}
