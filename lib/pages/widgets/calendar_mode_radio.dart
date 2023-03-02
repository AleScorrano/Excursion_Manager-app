import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_button/group_button.dart';
import 'package:sacs_app/blocs/calendar/bloc/calendar_bloc.dart';
import 'package:sacs_app/theme.dart';
import 'package:sidebarx/sidebarx.dart';

class CalendarModeRadio extends StatelessWidget {
  CalendarModeRadio({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GroupButton(
        onSelected: (value, index, isSelected) =>
            BlocProvider.of<CalendarBloc>(context).changeView(value),
        maxSelected: 1,
        options: GroupButtonOptions(
          elevation: 2,
          selectedColor: CustomTheme.complementaryColor1,
          unselectedColor: CustomTheme.primaryColorlight,
          selectedTextStyle: TextStyle(
            color: CustomTheme.primaryColorDark,
            fontWeight: FontWeight.w600,
          ),
          unselectedTextStyle: TextStyle(
            color: CustomTheme.complementaryColor2,
            fontWeight: FontWeight.w500,
          ),
          buttonWidth: 130,
          crossGroupAlignment: CrossGroupAlignment.start,
          borderRadius: BorderRadius.circular(12),
          direction: Axis.vertical,
        ),
        isRadio: true,
        buttons: _calendarMode,
      ),
    );
  }
}

const List<String> _calendarMode = [
  'Giorno',
  'Settimana',
  'Mese',
];
