import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sacs_app/theme.dart';

import '../../cubits/cubit/calendar_view_cubit.dart';

class CalendarModeDropdown extends StatelessWidget {
  CalendarModeDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: CustomTheme.complementaryColor2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton(
        elevation: 1,
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
          padding: const EdgeInsets.all(8.0),
          child: Text('Tipo Calendario'),
        ),
        onChanged: (value) =>
            BlocProvider.of<CalendarViewCubit>(context).changeView(value),
        items: _calendarMode.map<DropdownMenuItem<String>>(
          (String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          },
        ).toList(),
      ),
    );
    ;
  }
}

const List<String> _calendarMode = ['Giorno', 'Mese', 'Settimana'];
