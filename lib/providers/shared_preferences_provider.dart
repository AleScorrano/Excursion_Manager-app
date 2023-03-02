import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  final Future<SharedPreferences> sharedPreferences;

  SharedPreferencesProvider({required this.sharedPreferences});

  Future<String?> get calendarView async {
    return (await sharedPreferences).getString('calendar_View');
  }

  Future<void> setCalendarView(String value) async =>
      (await sharedPreferences).setString('calendar_View', value);
}
