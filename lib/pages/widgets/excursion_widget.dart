import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sacs_app/models/excursion_model.dart';
import 'package:sacs_app/repositories/excursion_repository.dart';
import 'package:sacs_app/theme.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

Widget ExcursionWeekWidget(BuildContext context,
    CalendarAppointmentDetails calendarAppointmentDetails) {
  Excursion appointment = calendarAppointmentDetails.appointments.first;
  num appointmentDuration =
      appointment.endTime.hour - appointment.startTime.hour;

  ExcursionRepository excursionRepository = context.read<ExcursionRepository>();

  return Card(
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    shadowColor: appointment.color,
    child: Column(
      children: [
        Container(
          width: calendarAppointmentDetails.bounds.width,
          height: calendarAppointmentDetails.bounds.height - 8,
          decoration: BoxDecoration(
            color: CustomTheme.complementaryColor2,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: 5,
                  height: double.maxFinite,
                  decoration: BoxDecoration(
                      color: appointment.color,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: appointment.color.withAlpha(60),
                          blurRadius: 6.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                            0.0,
                            3.0,
                          ),
                        ),
                      ]),
                ),
              ),
              Expanded(child: SizedBox()),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (appointmentDuration > 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        appointment.getExcursionTipeToString(
                            appointment.excursionTipe),
                        style: TextStyle(
                            fontSize: 16,
                            color: appointment.color,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                    ),
                  if (appointmentDuration > 1)
                    Padding(
                      padding: EdgeInsets.only(top: 6.0),
                      child: Text(
                        '${DateFormat('hh:mm', 'It').format(appointment.startTime)} - ${DateFormat('hh:mm', 'It').format(appointment.endTime)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  // if (appointmentDuration > 1)
                  StreamBuilder<List<int>>(
                      stream: excursionRepository
                          .getTotalPassengers(appointment.excursionCode),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return SizedBox();

                        return Padding(
                          padding: EdgeInsets.only(top: 6.0, bottom: 3),
                          child: Text(
                            '${appointment.getNumberOfPassengers(snapshot)}/ ${appointment.maxPassengers}',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        );
                      })
                ],
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        )
      ],
    ),
  );
}
