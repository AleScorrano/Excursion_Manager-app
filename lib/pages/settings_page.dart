import 'package:flutter/material.dart';
import 'package:sacs_app/widgets/time_picker.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TimePickerWidget(
        startTime: DateTime(2023, 1, 17, 18, 00),
        endTime: DateTime(2023, 1, 17, 21, 00),
      ),
    );
  }
}
