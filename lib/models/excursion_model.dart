import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:sacs_app/models/reservation_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
part 'excursion_model.g.dart';

@CopyWith()
class Excursion extends Appointment {
  final Color color;
  final String excursionCode;
  final ExcursionTipe excursionTipe;
  List<Reservation>? reservations;
  List<dynamic>? reservationsReference;
  final DateTime excursionStart;
  final DateTime excursionEnd;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int maxPassengers;
  int? totalPassengers;
  Excursion({
    required this.excursionCode,
    required this.color,
    required this.excursionTipe,
    required this.excursionStart,
    required this.excursionEnd,
    required this.maxPassengers,
    this.totalPassengers,
    this.reservations,
    this.reservationsReference,
    required this.createdAt,
    required this.updatedAt,
  }) : super(
          startTime: excursionStart,
          endTime: excursionEnd,
          color: color,
        ) {
    subject = getExcursionTipeToString(excursionTipe);
    notes = '${totalPassengers.toString()}/${maxPassengers}';
  }

  String getExcursionTipeToString(ExcursionTipe tipe) {
    switch (tipe) {
      case ExcursionTipe.normal:
        return 'Normale';
      case ExcursionTipe.personalized:
        return 'Personal';
      case ExcursionTipe.sunset:
        return 'Tramonto';
    }
  }

  int getMaxPassengersFromExcursionTipe(ExcursionTipe tipe) {
    switch (tipe) {
      case ExcursionTipe.normal:
        return 13;
      case ExcursionTipe.personalized:
        return 15;
      case ExcursionTipe.sunset:
        return 13;
    }
  }

  double get pricePerPassengersFromType {
    switch (excursionTipe) {
      case ExcursionTipe.normal:
        return 25.00;
      case ExcursionTipe.personalized:
        return 30.00;
      case ExcursionTipe.sunset:
        return 35.00;
    }
  }

  int getNumberOfPassengers(AsyncSnapshot<List<int>> snapshot) => snapshot.data!
      .fold(0, (previousValue, element) => previousValue + element);

  static Color ColorByTypeOfExcursions(ExcursionTipe tipe) {
    switch (tipe) {
      case ExcursionTipe.normal:
        {
          return Color.fromARGB(1, 62, 199, 11);
        }

      case ExcursionTipe.personalized:
        {
          return Color.fromARGB(1, 59, 68, 246);
        }

      case ExcursionTipe.sunset:
        {
          return Color.fromARGB(1, 255, 87, 51);
        }
    }
  }
}

enum ExcursionTipe {
  normal,
  personalized,
  sunset,
}
