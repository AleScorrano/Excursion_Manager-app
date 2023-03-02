import 'package:sacs_app/models/excursion_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ExcursionDataSource extends CalendarDataSource {
  ExcursionDataSource(List<Excursion>? source) {
    appointments = source;
  }
}
